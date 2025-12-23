part of 'weeklypc_bloc.dart';

sealed class WeeklypcState extends Equatable {
  const WeeklypcState();

  @override
  List<Object> get props => [];
}

final class WeeklypcInitial extends WeeklypcState {}

final class WeeklypcLoading extends WeeklypcState {}

final class WeeklypcLoaded extends WeeklypcState {
  final Weeklypcmodel model;
  const WeeklypcLoaded(this.model);
  @override
  List<Object> get props => [model];
}

final class WeeklypcError extends WeeklypcState {
  final String error;
  const WeeklypcError(this.error);
  @override
  List<Object> get props => [error];
}
