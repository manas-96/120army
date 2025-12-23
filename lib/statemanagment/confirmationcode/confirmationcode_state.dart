part of 'confirmationcode_bloc.dart';

sealed class ConfirmationcodeState extends Equatable {
  const ConfirmationcodeState();

  @override
  List<Object> get props => [];
}

final class ConfirmationcodeInitial extends ConfirmationcodeState {}

final class ConfirmationcodeLoading extends ConfirmationcodeState {}

final class ConfirmationcodeLoaded extends ConfirmationcodeState {
  final Otpmodel model;
  const ConfirmationcodeLoaded(this.model);
  @override
  List<Object> get props => [model];
}

final class ConfirmationcodeError extends ConfirmationcodeState {
  final String error;
  const ConfirmationcodeError(this.error);
}
