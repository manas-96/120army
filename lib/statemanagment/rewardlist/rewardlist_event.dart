part of 'rewardlist_bloc.dart';

sealed class RewardlistEvent extends Equatable {
  const RewardlistEvent();

  @override
  List<Object> get props => [];
}

final class RewardlistEventLoaded extends RewardlistEvent {}
