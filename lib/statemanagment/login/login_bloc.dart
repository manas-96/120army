import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/login_model.dart';
import '../../services/main_service.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final _service = MainService();
  LoginBloc() : super(LoginInitial()) {
    on<LoginEventTrigger>(_logineventtrigger);
  }

  void _logineventtrigger(
    LoginEventTrigger event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    try {
      Loginmodel? response = await _service.loginService(
        username: event.username,
        password: event.password,
        device_token: event.device_token,
      );
      emit(LoginLoaded(response!));
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }
}
