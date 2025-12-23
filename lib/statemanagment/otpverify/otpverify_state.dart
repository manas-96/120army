part of 'otpverify_bloc.dart';

sealed class OtpverifyState extends Equatable {
  const OtpverifyState();

  @override
  List<Object> get props => [];
}

final class OtpverifyInitial extends OtpverifyState {}

final class OtpverifyLoading extends OtpverifyState {}

final class OtpverifyLoaded extends OtpverifyState {
  final Otpverifymodel model;
  const OtpverifyLoaded(this.model);
  @override
  List<Object> get props => [model];
}

final class OtpverifyError extends OtpverifyState {
  final String error;
  const OtpverifyError(this.error);
  @override
  List<Object> get props => [error];
}
