import 'package:speakly/models/registration_models/dedicated_time_model.dart';
import 'package:speakly/models/registration_models/language_model.dart';
import 'package:speakly/models/registration_models/level_model.dart';
import 'package:speakly/models/registration_models/practice_time_model.dart';
import 'package:speakly/models/registration_models/reasons_model.dart';
import 'package:speakly/models/registration_models/topics_model.dart';
import 'package:speakly/models/registration_models/tutor_model.dart';
import 'package:speakly/repositories/implement_repositories/registration_data_repository.dart';

class UserModel {
  factory UserModel.empty() => UserModel(userId: '');

  UserModel(
      {required this.userId,
      this.type,
      this.name,
      this.email,
      this.avatarUrl,
      this.languageModel,
      this.levelModel,
      this.tutorModel,
      this.dedicatedTimeModel,
      this.reasonsModel,
      this.topicsModel,
      this.appLanguageModel,
      this.isOnboarded,
      this.isPayedUser,
      this.practiceTime});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      userId: json['id'],
      name: json['name'],
      email: json['email'],
      type: json['type'],
      avatarUrl: json['avatarUrl'],
      languageModel: LanguageModel.fromSnapshot(json['languageModel']),
      appLanguageModel: LanguageModel.fromSnapshot(json['appLanguageModel']),
      levelModel: LevelModel.fromSnapshot(json['levelModel']),
      tutorModel: TutorModel.heygen(),
      dedicatedTimeModel:
          DedicatedTimeModel.fromSnapshot(json['dedicatedTimeModel']),
      reasonsModel: json['reasonsModel']
          .map<ReasonsModel>((json) => ReasonsModel.fromSnapshot(json))
          .toList(),
      topicsModel: json['topicsModel']
          .map<TopicsModel>((json) => TopicsModel.fromSnapshot(json))
          .toList(),
      isOnboarded: json['isOnboarded'],
      isPayedUser: json['isPayedUser'],
      practiceTime: PracticeTimeModel.fromSnapshot(json['practiceTime']));

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': userId,
        'name': name,
        'email': email,
        'type': type,
        'avatarUrl': avatarUrl,
        'languageModel': languageModel?.toSnapshot(),
        'appLanguageModel': RegistrationDataRepository
            .registrationDataModel.appLanguageList.first
            .toSnapshot(),
        'levelModel': levelModel?.toSnapshot(),
        'tutorModel': TutorModel.heygen().toSnapshot(),
        'dedicatedTimeModel': dedicatedTimeModel?.toSnapshot(),
        'reasonsModel': reasonsModel?.map((e) => e.toSnapshot()),
        'topicsModel': topicsModel?.map((e) => e.toSnapshot()),
        'isOnboarded': isOnboarded,
        'isPayedUser': isPayedUser,
        'practiceTime': practiceTime?.toSnapshot()
      };

  final String userId;
  final String? name;
  final String? email;
  final String? type;
  final String? avatarUrl;
  final LanguageModel? languageModel;
  final LanguageModel? appLanguageModel;
  final LevelModel? levelModel;
  final TutorModel? tutorModel;
  final DedicatedTimeModel? dedicatedTimeModel;
  final List<ReasonsModel>? reasonsModel;
  final List<TopicsModel>? topicsModel;
  final bool? isOnboarded;
  final bool? isPayedUser;
  final PracticeTimeModel? practiceTime;
}

extension UserModelExtension on UserModel {
  UserModel copyWith(
      {String? avatarUrl,
      String? userId,
      String? type,
      String? name,
      String? email,
      LanguageModel? languageModel,
      LanguageModel? appLanguageModel,
      LevelModel? levelModel,
      TutorModel? tutorModel,
      DedicatedTimeModel? dedicatedTimeModel,
      List<ReasonsModel>? reasonsModel,
      List<TopicsModel>? topicsModel,
      bool? isOnboarded,
      bool? isPayedUser,
      PracticeTimeModel? practiceTime}) {
    return UserModel(
        practiceTime: practiceTime ?? this.practiceTime,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        userId: userId ?? this.userId,
        type: type ?? this.type,
        name: name ?? this.name,
        email: email ?? this.email,
        languageModel: languageModel ?? this.languageModel,
        appLanguageModel: appLanguageModel ?? this.appLanguageModel,
        levelModel: levelModel ?? this.levelModel,
        tutorModel: tutorModel ?? this.tutorModel,
        dedicatedTimeModel: dedicatedTimeModel ?? this.dedicatedTimeModel,
        reasonsModel: reasonsModel ?? this.reasonsModel,
        topicsModel: topicsModel ?? this.topicsModel,
        isOnboarded: isOnboarded ?? this.isOnboarded,
        isPayedUser: isPayedUser ?? this.isPayedUser);
  }
}
