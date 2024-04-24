import 'package:equatable/equatable.dart';
import 'package:speakly/widget/screens/exercise_screens/part_screens/exercise_shared/exercise_result_feedback_widgets.dart';

abstract class SmallChatEvent extends Equatable {
  const SmallChatEvent();

  @override
  List<Object?> get props => [];
}

class SmallChatInitializeRecorderEvent extends SmallChatEvent {}

class TranslateAiMessageEvent extends SmallChatEvent {
  const TranslateAiMessageEvent({required this.messageId});

  final String messageId;

  @override
  List<Object?> get props => [messageId];
}

class SpeakAudioMessageSmallChatEvent extends SmallChatEvent {
  const SpeakAudioMessageSmallChatEvent(
      {required this.messageId,
      required this.isHuman,
      this.exerciseResultEnumType,
      this.isOpenDialog = false});

  final String messageId;
  final bool isHuman;
  final bool isOpenDialog;
  final ExerciseResultEnumType? exerciseResultEnumType;

  @override
  List<Object?> get props =>
      [messageId, isHuman, isOpenDialog, exerciseResultEnumType];
}

class StartRecordFileSmallChatEvent extends SmallChatEvent {}

class StartRecordSmallChatEvent extends SmallChatEvent {}

class GetSmallChatResultEvent extends SmallChatEvent {}

class SmallChatChangeRecordMessageEvent extends SmallChatEvent {}

class StopRecordSmallChatEvent extends SmallChatEvent {
  const StopRecordSmallChatEvent({required this.isOnlyStop});

  final bool isOnlyStop;

  @override
  List<Object?> get props => [isOnlyStop];
}

class TryAgainSmallChatEvent extends SmallChatEvent {}

class ListenButtonAudioSmallChatEvent extends SmallChatEvent {
  const ListenButtonAudioSmallChatEvent({required this.isStart});

  final bool isStart;

  @override
  List<Object?> get props => [isStart];
}
