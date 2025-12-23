part of 'login_bloc.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginLoaded extends LoginState {
  final Loginmodel model;
  const LoginLoaded(this.model);
  @override
  List<Object> get props => [model];
}

final class LoginError extends LoginState {
  final String error;
  const LoginError(this.error);
  @override
  List<Object> get props => [error];
}
