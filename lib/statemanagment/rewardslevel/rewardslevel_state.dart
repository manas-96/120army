part of 'rewardslevel_bloc.dart';

sealed class RewardslevelState extends Equatable {
  const RewardslevelState();

  @override
  List<Object> get props => [];
}

final class RewardslevelInitial extends RewardslevelState {}

final class RewardslevelLoading extends RewardslevelState {}

final class RewardslevelLoaded extends RewardslevelState {
  final Rewardlevelmodel model;
  const RewardslevelLoaded(this.model);
  @override
  List<Object> get props => [model];
}

final class RewardslevelError extends RewardslevelState {
  final String error;
  const RewardslevelError(this.error);
  @override
  List<Object> get props => [error];
}
