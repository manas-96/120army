part of 'rewardlist_bloc.dart';

sealed class RewardlistState extends Equatable {
  const RewardlistState();

  @override
  List<Object> get props => [];
}

final class RewardlistInitial extends RewardlistState {}

final class RewardlistLoading extends RewardlistState {}

final class RewardlistLoaded extends RewardlistState {
  final Rewardtasklist model;
  const RewardlistLoaded(this.model);
  @override
  List<Object> get props => [model];
}

final class RewardlistError extends RewardlistState {
  final String error;
  const RewardlistError(this.error);
  @override
  List<Object> get props => [error];
}
