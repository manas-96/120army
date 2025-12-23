part of 'signupregistration_bloc.dart';

sealed class SignupregistrationState extends Equatable {
  const SignupregistrationState();

  @override
  List<Object> get props => [];
}

final class SignupregistrationInitial extends SignupregistrationState {}

final class SignupregistrationLoading extends SignupregistrationState {}

final class SignupregistrationLoaded extends SignupregistrationState {
  final Registermodel model;
  const SignupregistrationLoaded(this.model);
  @override
  List<Object> get props => [model];
}

final class SignupregistrationError extends SignupregistrationState {
  final String error;
  const SignupregistrationError(this.error);
  @override
  List<Object> get props => [error];
}
