part of 'weeklypc_bloc.dart';

sealed class WeeklypcEvent extends Equatable {
  const WeeklypcEvent();

  @override
  List<Object> get props => [];
}

final class WeeklypcTrigger extends WeeklypcEvent {}
