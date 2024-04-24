import 'dart:async';
import 'dart:io';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:google_speech/config/recognition_config.dart';
import 'package:google_speech/config/recognition_config_v1.dart';
import 'package:google_speech/config/streaming_recognition_config.dart';
import 'package:google_speech/speech_client_authenticator.dart';
import 'package:google_speech/speech_to_text.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:rxdart/rxdart.dart';
import 'package:speakly/blocs/map_bloc/small_chat_bloc/small_chat_event.dart';
import 'package:speakly/blocs/map_bloc/small_chat_bloc/small_chat_state.dart';
import 'package:speakly/middleware/enums/chat_hint_load.dart';
import 'package:speakly/middleware/enums/message_owner_enum.dart';
import 'package:speakly/middleware/enums/record_state_enum.dart';
import 'package:speakly/middleware/extensions/icons_image_extension.dart';
import 'package:speakly/models/exercise_models/exercise_part_models/small_chat_model.dart';
import 'package:speakly/models/exercise_models/map_models/exercise_information_model.dart';
import 'package:speakly/models/exercise_models/small_chat_message_model.dart';
import 'package:speakly/repositories/implement_repositories/open_ai_microsoft_repository_implement.dart';
import 'package:speakly/widget/screens/exercise_screens/part_screens/exercise_shared/exercise_result_feedback_widgets.dart';

class SmallChatBloc extends Bloc<SmallChatEvent, SmallChatState> {
  SmallChatBloc({required this.smallChatModel})
      : super(SmallChatInitialState()) {
    on<SmallChatInitializeRecorderEvent>(_onSmallChatInitializeRecorderEvent);
    on<TranslateAiMessageEvent>(_onTranslateAiMessageEvent);
    on<StartRecordFileSmallChatEvent>(_onStartRecordFileSmallChatEvent);
    on<StartRecordSmallChatEvent>(_onStartRecordSmallChatEvent);
    on<GetSmallChatResultEvent>(_onGetSmallChatResultEvent);
    on<StopRecordSmallChatEvent>(_onStopRecordSmallChatEvent);
    on<TryAgainSmallChatEvent>(_onTryAgainSmallChatEvent);
    on<SpeakAudioMessageSmallChatEvent>(_onSpeakAudioMessageSmallChatEvent);
    on<ListenButtonAudioSmallChatEvent>(_onListenButtonAudioSmallChatEvent);
  }
  final player = AudioPlayer();

  final SmallChatModel smallChatModel;
  OpenAiMicrosoftRepositoryImplement openAiMicrosoftRepositoryImplement =
      OpenAiMicrosoftRepositoryImplement();

  late StreamController<bool>? controller = StreamController();
  late SpeechToText speechToText;
  late BehaviorSubject<Uint8List> _audioStream;
  String temporaryLastRecordingWords = '';
  RecordMessageState recordMessageState = RecordMessageState.canRecord;
  ChatHintLoadEnumType chatHintLoadEnumType = ChatHintLoadEnumType.show;

  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();

  StreamController<Food>? _recordingDataController;
  StreamSubscription? _recordingDataSubscription;

  final _recordFileAudio = AudioRecorder();

  Timer? _timer;

  int messageCount = 1;

  int pronScore = 0;

  late SmallChatModel temporarySmallChatModel = SmallChatModel(
      priority: smallChatModel.priority,
      exerciseTypeEnum: ExerciseTypeEnum.smallChat,
      messageList: [
        SmallChatMessageModel(
          messageId: smallChatModel.messageList.first.messageId,
          value: smallChatModel.messageList.first.value,
          owner: smallChatModel.messageList.first.owner,
          fileUrl: smallChatModel.messageList.first.fileUrl,
          hintMessage: smallChatModel.messageList.first.hintMessage,
        ),
      ]);

  @override
  Future<void> close() async {
    await player.stop();
    await _onStopSmallChatRecordEvent();

    await controller?.close();

    await player.dispose();

    super.close();
  }

  Future<void> _onSmallChatInitializeRecorderEvent(
      SmallChatInitializeRecorderEvent event, Emitter emit) async {
    emit(SmallChatInitialState());

    temporarySmallChatModel.messageList.first.translateMessage = '';

    final googleSpeechToText =
        await rootBundle.loadString('assets/json/google_speech_to_text.json');
    _audioStream = BehaviorSubject<Uint8List>();
    speechToText = SpeechToText.viaServiceAccount(
        ServiceAccount.fromString(googleSpeechToText));
  }

  Future<void> _onListenButtonAudioSmallChatEvent(
      ListenButtonAudioSmallChatEvent event, Emitter emit) async {
    emit(SmallChatInitialState());
    await player.setAsset(
        event.isStart ? AppIcons.startRecordAudio : AppIcons.stopRecordAudio);

    await player.play();

    emit(ListenButtonAudioSmallChatState());
  }

  Future<void> _onStartRecordFileSmallChatEvent(
      StartRecordFileSmallChatEvent event, Emitter emit) async {
    emit(SmallChatInitialState());

    final temporaryPath = (await getTemporaryDirectory()).path;
    await _recordFileAudio.start(
        const RecordConfig(
            encoder: AudioEncoder.wav, numChannels: 1, noiseSuppress: true),
        path: '$temporaryPath/small_chat.wav');

    controller = StreamController();
    controller?.stream.listen((event) async {
      if (event == false) {
        add(GetSmallChatResultEvent());
        controller?.close();

        return;
      }
    });

    add(StartRecordSmallChatEvent());
    await startTimer();
  }

  Future<void> _onStartRecordSmallChatEvent(
      StartRecordSmallChatEvent event, Emitter emit) async {
    temporaryLastRecordingWords = '';

    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth |
              AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
          AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));
    await _recorder.openRecorder();
    temporaryLastRecordingWords = '';

    _audioStream = BehaviorSubject<Uint8List>();

    // Create recording stream
    _recordingDataController = StreamController<Food>();
    _recordingDataSubscription =
        _recordingDataController?.stream.listen((buffer) {
      if (buffer is FoodData) {
        final data = buffer.data;
        if (data != null) {
          _audioStream.add(data);
        }
      }
    });

    await _recorder.startRecorder(
        toStream: _recordingDataController,
        codec: Codec.pcm16,
        sampleRate: 16000,
        numChannels: 1,
        bitRate: 16000);
    var isEvent = true;
    var responseText = '';
    temporaryLastRecordingWords = responseText;
    speechToText
        .streamingRecognize(
            StreamingRecognitionConfig(
                interimResults: true,
                config: RecognitionConfig(
                    useEnhanced: true,
                    enableAutomaticPunctuation: true,
                    model: RecognitionModel.basic,
                    sampleRateHertz: 16000,
                    audioChannelCount: 1,
                    maxAlternatives: 30,
                    encoding: AudioEncoding.LINEAR16,
                    languageCode: 'en-US')),
            _audioStream)
        .listen((data) async {
      final currentText =
          data.results.map((e) => e.alternatives.first.transcript).join(' ');
      if (data.results.first.isFinal) {
        responseText += ' $currentText';

        temporaryLastRecordingWords = responseText;
        isEvent = false;
      } else {
        temporaryLastRecordingWords = '$responseText $currentText';
        isEvent = true;
        return;
      }
      await Future.delayed(const Duration(seconds: 1));
      if (!isEvent) {
        final content = temporaryLastRecordingWords.trim();
        if (controller?.hasListener == true && content.isNotEmpty) {
          add(const ListenButtonAudioSmallChatEvent(isStart: false));
          controller?.add(isEvent);
        }
      }
    });
    await Future.delayed(const Duration(milliseconds: 200));
    recordMessageState = RecordMessageState.record;
    emit(SmallChatChangeRecordMessageState());
  }

  Future<void> _onGetSmallChatResultEvent(
      GetSmallChatResultEvent event, Emitter emit) async {
    emit(SmallChatInitialState());

    recordMessageState = RecordMessageState.loading;
    emit(SmallChatLoadingState());
    await _onStopSmallChatRecordEvent();
    final temporaryPath = (await getTemporaryDirectory()).path;

    final file = File('$temporaryPath/small_chat.wav');

    final result = await openAiMicrosoftRepositoryImplement
        .getConversationSkillsScoresFromMicrosoft(
            file: file,
            id: '',
            content: temporarySmallChatModel
                    .messageList[messageCount - 1].hintMessage ??
                '');

    messageCount += 1;
    temporarySmallChatModel.messageList.add(SmallChatMessageModel(
        messageId: messageCount.toString(),
        value: temporaryLastRecordingWords,
        owner: MessageOwnerEnum.user,
        fileUrl: file.path));
    temporarySmallChatModel.messageList.add(
      SmallChatMessageModel(
          messageId: smallChatModel.messageList[messageCount - 1].messageId,
          value: smallChatModel.messageList[messageCount - 1].value,
          owner: smallChatModel.messageList[messageCount - 1].owner,
          fileUrl: smallChatModel.messageList[messageCount - 1].fileUrl,
          hintMessage:
              smallChatModel.messageList[messageCount - 1].hintMessage),
    );

    pronScore += result?.pronScore ?? 0;

    if (messageCount == smallChatModel.messageList.length) {
      recordMessageState = RecordMessageState.none;
      chatHintLoadEnumType = ChatHintLoadEnumType.iconNone;
      emit(GetSmallChatScoreState());
      pronScore = (pronScore / (smallChatModel.messageList.length - 1)).ceil();
      if (result != null) {
        await player.pause();
        add(SpeakAudioMessageSmallChatEvent(
            isHuman: false,
            messageId: temporarySmallChatModel.messageList.last.messageId,
            isOpenDialog: true,
            exerciseResultEnumType: pronScore > 80
                ? ExerciseResultEnumType.correct
                : ExerciseResultEnumType.incorrect));
      }
    } else {
      recordMessageState = RecordMessageState.canRecord;

      temporaryLastRecordingWords = '';

      emit(GetSmallChatScoreState());

      add(SpeakAudioMessageSmallChatEvent(
        isHuman: false,
        messageId: temporarySmallChatModel.messageList.last.messageId,
      ));
    }
  }

  Future<void> _onStopRecordSmallChatEvent(
      StopRecordSmallChatEvent event, Emitter emit) async {
    emit(SmallChatInitialState());
    if (event.isOnlyStop) {
      add(const ListenButtonAudioSmallChatEvent(isStart: false));
      controller?.close();
      await _onStopSmallChatRecordEvent();

      emit(SmallChatChangeRecordMessageState());
    } else {
      add(GetSmallChatResultEvent());
    }
  }

  Future<void> _onStopSmallChatRecordEvent() async {
    _timer?.cancel();
    await _recorder.stopRecorder();
    await _recordingDataController?.close();
    await _audioStream.close();
    speechToText.dispose();
    await _recordingDataSubscription?.cancel();
    await _recordFileAudio.stop();

    recordMessageState = RecordMessageState.canRecord;
  }

  Future<void> startTimer() async {
    _timer?.cancel();
    var _start = 10;
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) async {
        final content = temporaryLastRecordingWords.trim();
        if (_start == 5 && content.isEmpty) {
          add(const StopRecordSmallChatEvent(isOnlyStop: true));
        } else if (_start == 0) {
          add(const ListenButtonAudioSmallChatEvent(isStart: false));
          add(const StopRecordSmallChatEvent(isOnlyStop: false));
        } else {
          _start--;
        }
      },
    );
  }

  Future<void> _onTranslateAiMessageEvent(
      TranslateAiMessageEvent event, Emitter emit) async {
    emit(SmallChatInitialState());
    emit(TranslateAiMessageLoadingState(messageId: event.messageId));

    if (temporarySmallChatModel.messageList
            .firstWhere((element) => element.messageId == event.messageId)
            .translateMessage !=
        '') {
      temporarySmallChatModel.messageList
          .firstWhere((element) => element.messageId == event.messageId)
          .translateMessage = '';
      return emit(TranslateAiMessageState());
    }

    temporarySmallChatModel.messageList
            .firstWhere((element) => element.messageId == event.messageId)
            .translateMessage =
        smallChatModel.messageList
            .firstWhere((element) => element.messageId == event.messageId)
            .translateMessage;
    emit(TranslateAiMessageState());
  }

  Future<void> _onTryAgainSmallChatEvent(
      TryAgainSmallChatEvent event, Emitter emit) async {
    emit(SmallChatInitialState());
    pronScore = 0;
    chatHintLoadEnumType = ChatHintLoadEnumType.show;

    recordMessageState = RecordMessageState.canRecord;
    temporarySmallChatModel = SmallChatModel(
        priority: smallChatModel.priority,
        exerciseTypeEnum: ExerciseTypeEnum.smallChat,
        messageList: [
          SmallChatMessageModel(
              messageId: smallChatModel.messageList.first.messageId,
              value: smallChatModel.messageList.first.value,
              owner: smallChatModel.messageList.first.owner,
              fileUrl: smallChatModel.messageList.first.fileUrl,
              hintMessage: smallChatModel.messageList.first.hintMessage),
        ]);
    messageCount = 1;
    emit(TryAgainSmallChatState());
    add(SpeakAudioMessageSmallChatEvent(
        isHuman: false,
        messageId: temporarySmallChatModel.messageList.first.messageId));
  }

  Future<void> _onSpeakAudioMessageSmallChatEvent(
      SpeakAudioMessageSmallChatEvent event, Emitter emit) async {
    emit(SmallChatInitialState());
    try {
      if (player.playing &&
          player.playerState.processingState != ProcessingState.completed) {
        await player.pause();
        return;
      }
      emit(SpeakAudioLoadingSmallChatState());
      final url = event.isHuman
          ? temporarySmallChatModel.messageList
              .firstWhere((element) => element.messageId == event.messageId)
              .fileUrl
          : temporarySmallChatModel.messageList
              .firstWhere((element) => element.messageId == event.messageId)
              .fileUrl;
      event.isHuman ? await player.setFilePath(url) : await player.setUrl(url);
      emit(SpeakAudioPlaySmallChatState());

      await player.play();

      emit(SpeakAudioSmallChatState());
      if (event.isOpenDialog) {
        if (pronScore > 80) {
          return emit(const SmallChatSuccessState(
              exerciseResultEnumType: ExerciseResultEnumType.correct));
        } else {
          return emit(const SmallChatSuccessState(
              exerciseResultEnumType: ExerciseResultEnumType.incorrect));
        }
      }
    } on Exception {
      emit(SmallChatInitialState());
    }
  }
}
