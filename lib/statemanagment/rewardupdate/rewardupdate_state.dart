part of 'rewardupdate_bloc.dart';

sealed class RewardupdateState extends Equatable {
  const RewardupdateState();

  @override
  List<Object> get props => [];
}

final class RewardupdateInitial extends RewardupdateState {}

final class RewardupdateLoading extends RewardupdateState {}

final class RewardupdateLoaded extends RewardupdateState {
  final Rewardupdate model;
  const RewardupdateLoaded(this.model);
  @override
  List<Object> get props => [model];
}

final class RewardupdateError extends RewardupdateState {
  final String error;
  const RewardupdateError(this.error);
  @override
  List<Object> get props => [error];
}
