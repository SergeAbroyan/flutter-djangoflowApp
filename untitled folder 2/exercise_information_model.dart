import 'package:speakly/models/exercise_models/exercise_part_models/choose_right_word_model.dart';
import 'package:speakly/models/exercise_models/exercise_part_models/create_sentence_model.dart';
import 'package:speakly/models/exercise_models/exercise_part_models/grammar_lesson_model.dart';
import 'package:speakly/models/exercise_models/exercise_part_models/learn_word_model.dart';
import 'package:speakly/models/exercise_models/exercise_part_models/repeat_sentence_model.dart';
import 'package:speakly/models/exercise_models/exercise_part_models/repeat_word_model.dart';
import 'package:speakly/models/exercise_models/exercise_part_models/small_chat_model.dart';
import 'package:speakly/models/exercise_models/exercise_part_models/translate_sentence_model.dart';
import 'package:speakly/models/exercise_models/exercise_part_models/translate_word_model.dart';

class ExerciseInformationAbstractModel {
  factory ExerciseInformationAbstractModel.fromSnapshot(
      Map<String, dynamic> snapshot) {
    final type = ExerciseTypeEnum.values
        .firstWhere((element) => snapshot['exerciseType'] == element.name);
    switch (type) {
      case ExerciseTypeEnum.repeatSentence:
        return RepeatSentenceModel.fromSnapshot(snapshot);
      case ExerciseTypeEnum.learnWord:
        return LearnWordModel.fromSnapshot(snapshot);
      case ExerciseTypeEnum.translateSentences:
        return TranslateSentenceModel.fromSnapshot(snapshot);
      case ExerciseTypeEnum.createSentence:
        return CreateSentenceModel.fromSnapshot(snapshot);
      case ExerciseTypeEnum.smallChat:
        return SmallChatModel.fromSnapshot(snapshot);
      case ExerciseTypeEnum.grammarLesson:
        return GrammarLessonModel.fromSnapshot(snapshot);
      case ExerciseTypeEnum.repeatWord:
        return RepeatWordModel.fromSnapshot(snapshot);
      case ExerciseTypeEnum.translateWord:
        return TranslateWordModel.fromSnapshot(snapshot);
      case ExerciseTypeEnum.chooseRightWord:
        return ChooseRightWordModel.fromSnapshot(snapshot);
    }
  }
  ExerciseInformationAbstractModel(
      {required this.priority,
      required this.exerciseTypeEnum,
      this.showDialog = false});

  final int priority;
  final ExerciseTypeEnum exerciseTypeEnum;
  final bool showDialog;
}

enum ExerciseTypeEnum {
  translateSentences,
  repeatSentence,
  grammarLesson,
  createSentence,
  learnWord,
  repeatWord,
  smallChat,
  translateWord,
  chooseRightWord
}
