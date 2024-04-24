import 'package:get_it/get_it.dart';
import 'package:speakly/blocs/feedback_history_bloc/feedback_history_bloc.dart';
import 'package:speakly/blocs/map_bloc/exercise_bloc/exercise_bloc.dart';
import 'package:speakly/repositories/implement_repositories/exercise_repository_implement.dart';
import 'package:speakly/repositories/implement_repositories/feedback_history_repository.dart';
import 'package:speakly/store/root_state/root_state.dart';
import '../repositories/implement_repositories/firebase_analytics_service_repository.dart';
import '../store/auth_state/auth_state.dart';

Future<void> reRegisterStoreGetIt() async {
  final authState = GetIt.I<AuthState>();
  final feedBackHistoryBloc = GetIt.I<FeedbackHistoryBloc>();
  final analyticService = GetIt.I<AnalyticServiceRepository>();
  final rootState = GetIt.I<RootState>();
  final exersiceBloc = GetIt.I<ExerciseBloc>();
  await InterceptorInitialize.di.unregister(instance: authState);
  await InterceptorInitialize.di.unregister(instance: feedBackHistoryBloc);
  await InterceptorInitialize.di.unregister(instance: analyticService);
  await InterceptorInitialize.di.unregister(instance: rootState);
  await InterceptorInitialize.di.unregister(instance: exersiceBloc);
  InterceptorInitialize.di.registerSingleton(AuthState());
  InterceptorInitialize.di.registerSingleton(AnalyticServiceRepository());
  InterceptorInitialize.di.registerSingleton(FeedbackHistoryBloc(
      feedbackHistoryAbstractRepository: FeedbackHistoryRepository()));
  InterceptorInitialize.di.registerSingleton(
      ExerciseBloc(exerciseRepositoryAbstract: ExerciseRepositoryImplement()));
}

class InterceptorInitialize {
  InterceptorInitialize._();

  static final GetIt di = GetIt.instance;

  static Future<void> diInit() async {
    di
      ..registerLazySingleton<AuthState>(AuthState.new)
      ..registerLazySingleton<FeedbackHistoryBloc>(() => FeedbackHistoryBloc(
          feedbackHistoryAbstractRepository: FeedbackHistoryRepository()))
      ..registerLazySingleton<ExerciseBloc>(() => ExerciseBloc(
          exerciseRepositoryAbstract: ExerciseRepositoryImplement()))
      ..registerLazySingleton<AnalyticServiceRepository>(
          AnalyticServiceRepository.new);
  }
}
