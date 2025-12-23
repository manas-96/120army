part of 'rewardslevel_bloc.dart';

sealed class RewardslevelEvent extends Equatable {
  const RewardslevelEvent();

  @override
  List<Object?> get props => [];
}

final class RewardslevelEventTrigger extends RewardslevelEvent {
  final String? userId;

  const RewardslevelEventTrigger({this.userId});

  @override
  List<Object?> get props => [userId];
}
