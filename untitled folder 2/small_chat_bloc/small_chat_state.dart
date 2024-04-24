import 'package:equatable/equatable.dart';
import 'package:speakly/widget/screens/exercise_screens/part_screens/exercise_shared/exercise_result_feedback_widgets.dart';

abstract class SmallChatState extends Equatable {
  const SmallChatState();

  @override
  List<Object?> get props => [];
}

class SmallChatInitialState extends SmallChatState {}

class SmallChatChangeRecordMessageState extends SmallChatState {}

class SmallChatLoadingState extends SmallChatState {}

class SpeakAudioMessageLoadingState extends SmallChatState {
  const SpeakAudioMessageLoadingState({required this.messageId});

  final String messageId;

  @override
  List<Object?> get props => [messageId];
}

class SpeakAudioAiMessageState extends SmallChatState {}

class TranslateAiMessageLoadingState extends SmallChatState {
  const TranslateAiMessageLoadingState({required this.messageId});

  final String messageId;

  @override
  List<Object?> get props => [messageId];
}

class TranslateAiMessageState extends SmallChatState {}

class SmallChatSuccessState extends SmallChatState {
  const SmallChatSuccessState({required this.exerciseResultEnumType});

  final ExerciseResultEnumType exerciseResultEnumType;

  @override
  List<Object?> get props => [exerciseResultEnumType];
}

class StopSmallChatRecordState extends SmallChatState {}

class GetSmallChatScoreState extends SmallChatState {}

class TryAgainSmallChatState extends SmallChatState {}

class SpeakAudioLoadingSmallChatState extends SmallChatState {}

class SpeakAudioPlaySmallChatState extends SmallChatState {}

class SpeakAudioSmallChatState extends SmallChatState {}

class ListenButtonAudioSmallChatState extends SmallChatState {}
