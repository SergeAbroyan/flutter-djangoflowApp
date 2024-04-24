import 'package:npua_project/components/buttons/centered_button.dart';
import 'package:npua_project/middlewares/repositories/abstraction/storage_repository_abstract.dart';
import 'package:npua_project/screens/login/login_bloc/login_event.dart';
import 'package:npua_project/screens/login/login_bloc/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._storageRepositoryAbstract) : super(InitialState()) {
    on<TryLoginEvent>(_onTryLoginEvent);
  }

  final StorageRepositoryAbstract _storageRepositoryAbstract;

  Future<void> _onTryLoginEvent(TryLoginEvent event, Emitter emit) async {
    emit(InitialState());
    emit(ChangeButtonState(ButtonState.loading));
    if (event.email == 'npua@gmail.com' && event.password == 'npua1234') {
      await _storageRepositoryAbstract.save(value: 'npua');
      return emit(LoginSuccessState());
    }
    emit(LoginFailedState());
  }
}
