import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:speakly/interceptors/interceptor_initialize.dart';
import 'package:speakly/models/all_chat_prompt_model.dart';
import 'package:speakly/models/chat_feedback_models/conversation_skills_scores_model.dart';
import 'package:speakly/models/chat_feedback_models/feedback_model.dart';
import 'package:speakly/models/chat_feedback_models/grammar_message_model.dart';
import 'package:speakly/models/chat_feedback_models/summary_goals_model.dart';
import 'package:speakly/models/feature_instance_model.dart';
import 'package:speakly/models/features_instances_data_model.dart';
import 'package:speakly/models/registration_models/reasons_model.dart';
import 'package:speakly/models/session_model.dart';
import 'package:speakly/repositories/abstract_repositories/chat_repository_abstract.dart';
import 'package:speakly/store/auth_state/auth_state.dart';
import 'package:speakly/widget/screens/chat_screen/chat_screens/chat_screen.dart';

class ChatRepositoryImplement extends ChatRepositoryAbstract {
  String get userId => InterceptorInitialize.di<AuthState>().userModel.userId;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  
  @override
  Future<List<String>> getAllOpenAiToken() async {
    try {
      final snapshot = await _db.collection('openAiToken').limit(1).get();

      final aiTokenList = List<String>.from(snapshot.docs
          .map((docSnapshot) => docSnapshot.data()['tokens'])
          .first);

      return aiTokenList;
    } on FirebaseException catch (error, stackTrace) {
      await FirebaseCrashlytics.instance.recordError(error, stackTrace);
      return [];
    }
  }

  @override
  Future<List<FeatureInstanceModel>> getAllFeaturesInstances(
      {required bool isRoleBased,
      required List<ReasonsModel> reasonList}) async {
    try {
      final list = <FeatureInstanceModel>[];
      final resultReason = await _db
          .collection(
              isRoleBased ? 'role-based-feature' : 'thematic-chat-feature')
          .where('reason_type',
              whereIn: reasonList.map((e) => e.value).toList())
          .get();

      list.addAll(resultReason.docs
          .map((event) =>
              FeatureInstanceModel.fromDocumentSnapshot(event.data()))
          .toList());

      final resultDefault = await _db
          .collection(
              isRoleBased ? 'role-based-feature' : 'thematic-chat-feature')
          .where('reason_type',
              whereNotIn: reasonList.map((e) => e.value).toList())
          .get();

      list.addAll(resultDefault.docs
          .map((event) =>
              FeatureInstanceModel.fromDocumentSnapshot(event.data()))
          .toList());

      return list;
    } on FirebaseException catch (error, stackTrace) {
      await FirebaseCrashlytics.instance.recordError(error, stackTrace);
      return [];
    }
  }

  @override
  Future<FeatureInstanceModel> getTrialFeatureInstanceModel() async {
    final result = await _db
        .collection('thematic-chat-feature')
        .where('is_trial', isEqualTo: true)
        .limit(1)
        .get();

    final data = result.docs
        .map((event) => FeatureInstanceModel.fromDocumentSnapshot(event.data()))
        .toList()
        .first;

    return data;
  }

  @override
  Future<FeaturesInstancesDataModel?> getFeaturesInstancesInformation(
      String id, bool isRoleBased) async {
    try {
      final result = await _db
          .collection(isRoleBased
              ? 'role-based-information'
              : 'thematic-chat-information')
          .doc(id)
          .get();

      final data = result.data();
      if (data != null) {
        return FeaturesInstancesDataModel.fromDocumentSnapshot(data);
      }
      return null;
    } on FirebaseException catch (error, stackTrace) {
      await FirebaseCrashlytics.instance.recordError(error, stackTrace);
      return null;
    }
  }

  @override
  Future<SessionModel?> getSessionByFeatureId(String featureId) async {
    try {
      final result = await _db
          .collection('users')
          .doc(userId)
          .collection('sessions')
          .doc(featureId)
          .get();

      final data = result.data();
      if (data != null) {
        if (data['chat'] != null) {
          return SessionModel.fromDocumentSnapshot(data['chat']);
        }
      }
      return null;
    } on FirebaseException catch (error, stackTrace) {
      await FirebaseCrashlytics.instance.recordError(error, stackTrace);
      return null;
    }
  }

  @override
  Future<void> createOrUpdateSession(SessionModel sessionModel) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('sessions')
          .doc(sessionModel.featureId)
          .set({'chat': sessionModel.toSnapshot()}, SetOptions(merge: true));
    } on FirebaseException catch (error, stackTrace) {
      await FirebaseCrashlytics.instance.recordError(error, stackTrace);
    }
  }

  @override
  Future<void> deleteSession(String featureId) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('sessions')
          .doc(featureId)
          .delete();
    } on FirebaseException catch (error, stackTrace) {
      await FirebaseCrashlytics.instance.recordError(error, stackTrace);
    }
  }

  @override
  Future<void> createOrUpdateSummaryGoals(
      SummaryGoalsModel summaryGoalsModel, String featureId) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('sessions')
          .doc(featureId)
          .set({'summaryGoals': summaryGoalsModel.toSnapshot()},
              SetOptions(merge: true));
    } on FirebaseException catch (error, stackTrace) {
      await FirebaseCrashlytics.instance.recordError(error, stackTrace);
    }
  }

  @override
  Future<FeedBackModel?> getFeedBackModel(
      String featureId, int messageCount) async {
    try {
      final result = await _db
          .collection('users')
          .doc(userId)
          .collection('sessions')
          .doc(featureId)
          .get();

      final response = result.data();
      if (response != null) {
        return FeedBackModel.fromSnapshot(response);
      }
      return null;
    } on FirebaseException catch (error, stackTrace) {
      await FirebaseCrashlytics.instance.recordError(error, stackTrace);
      return null;
    }
  }

  @override
  Future<void> createOrUpdateConversationSkillsScoresModel(
      List<ConversationSkillsScoresModel> conversationSkillsScoresModel,
      String featureId) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('sessions')
          .doc(featureId)
          .set({
        'conversationSkillsScoresModel':
            conversationSkillsScoresModel.map((e) => e.toSnapshot()).toList()
      }, SetOptions(merge: true));
    } on FirebaseException catch (error, stackTrace) {
      await FirebaseCrashlytics.instance.recordError(error, stackTrace);
    }
  }

  @override
  Future<List<ConversationSkillsScoresModel>> getConversationSkillsScoresModel(
      String featureId) async {
    try {
      final result = await _db
          .collection('users')
          .doc(userId)
          .collection('sessions')
          .doc(featureId)
          .get();

      if (result.data()?['conversationSkillsScoresModel'] != null) {
        return List.from(result
            .data()?['conversationSkillsScoresModel']
            .map((event) => ConversationSkillsScoresModel.fromSnapshot(event)));
      }
      return [];
    } on FirebaseException catch (error, stackTrace) {
      await FirebaseCrashlytics.instance.recordError(error, stackTrace);
      return [];
    }
  }

  @override
  Future<List<GrammarMessageModel>> getGrammarScoresModel(
      String featureId) async {
    try {
      final result = await _db
          .collection('users')
          .doc(userId)
          .collection('sessions')
          .doc(featureId)
          .get();

      if (result.data()?['grammarMessageModel'] != null) {
        return List.from(result
            .data()?['grammarMessageModel']
            .map((event) => GrammarMessageModel.fromSnapshot(snapshot: event)));
      }
      return [];
    } on FirebaseException catch (error, stackTrace) {
      await FirebaseCrashlytics.instance.recordError(error, stackTrace);
      return [];
    }
  }

  @override
  Future<void> putSummaryModel(String summary, String featureId) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('sessions')
          .doc(featureId)
          .set({'summary': summary}, SetOptions(merge: true));
    } on FirebaseException catch (error, stackTrace) {
      await FirebaseCrashlytics.instance.recordError(error, stackTrace);
    }
  }

  @override
  Future<void> putGrammarScore(int grammarScore, String featureId) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('sessions')
          .doc(featureId)
          .set({'grammarScore': grammarScore}, SetOptions(merge: true));
    } on FirebaseException catch (error, stackTrace) {
      await FirebaseCrashlytics.instance.recordError(error, stackTrace);
    }
  }

  @override
  Future<void> createOrUpdateGrammarMessageModel(
      List<GrammarMessageModel> grammarMessageModel, String featureId) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('sessions')
          .doc(featureId)
          .set({
        'grammarMessageModel':
            grammarMessageModel.map((e) => e.toSnapshot()).toList()
      }, SetOptions(merge: true));
    } on FirebaseException catch (error, stackTrace) {
      await FirebaseCrashlytics.instance.recordError(error, stackTrace);
    }
  }

  @override
  Future<AllPromptModel?> getAllPrompts() async {
    try {
      final snapshot =
          await _db.collection('generic-without-auth').doc('prompt').get();

      final result = snapshot.data();

      if (result != null) {
        return AllPromptModel.fromDocumentSnapshot(result);
      }
    } on FirebaseException catch (error, stackTrace) {
      await FirebaseCrashlytics.instance.recordError(error, stackTrace);
      throw FirebaseException(plugin: error.toString());
    }
    return null;
  }

  @override
  Future<void> chatEnd(
      {required String featureId, required ChatEndEnum chatEndEnum}) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('sessions')
          .doc(featureId)
          .update({'chat.isEnded': chatEndEnum.name});
    } on FirebaseException catch (error, stackTrace) {
      await FirebaseCrashlytics.instance.recordError(error, stackTrace);
    }
  }

  @override
  Future<void> isPutFeedbackModel(String featureId) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('sessions')
          .doc(featureId)
          .update({'chat.isPutFeedback': true});
    } on FirebaseException catch (error, stackTrace) {
      await FirebaseCrashlytics.instance.recordError(error, stackTrace);
    }
  }
}
