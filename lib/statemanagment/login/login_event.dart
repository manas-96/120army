part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

final class LoginEventTrigger extends LoginEvent {
  final String username;
  final String password;
  final String device_token;
  const LoginEventTrigger({
    required this.username,
    required this.password,
    required this.device_token,
  });
  @override
  List<Object> get props => [username, password, device_token];
}
