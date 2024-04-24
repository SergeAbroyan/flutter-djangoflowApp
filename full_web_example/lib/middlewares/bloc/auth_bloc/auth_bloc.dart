import 'package:npua_project/middlewares/bloc/auth_bloc/auth_event.dart';
import 'package:npua_project/middlewares/bloc/auth_bloc/auth_state.dart';
import 'package:npua_project/middlewares/repositories/abstraction/storage_repository_abstract.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._storageRepositoryAbstract) : super(InitialState()) {
    on<AppStartEvent>(_onAppStartEvent);
    on<LogOutEvent>(_onLogOutEvent);
  }

  final StorageRepositoryAbstract _storageRepositoryAbstract;

  Future<void> _onAppStartEvent(AppStartEvent event, Emitter emit) async {
    final result = await _storageRepositoryAbstract.get();

    if (result != null) {
      return emit(AuthenticatedState());
    }

    emit(UnAuthenticatedState());
  }

  Future<void> _onLogOutEvent(LogOutEvent event, Emitter emit) async {}
}
