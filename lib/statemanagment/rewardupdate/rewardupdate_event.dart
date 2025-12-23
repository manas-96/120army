part of 'rewardupdate_bloc.dart';

sealed class RewardupdateEvent extends Equatable {
  const RewardupdateEvent();

  @override
  List<Object> get props => [];
}

final class RewardupdateEventTrigger extends RewardupdateEvent {
  final String rewardid;
  final String taskid;
  const RewardupdateEventTrigger(this.rewardid, this.taskid);
  @override
  List<Object> get props => [rewardid, taskid];
}
