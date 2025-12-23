part of 'challenges_bloc.dart';

sealed class ChallengesState extends Equatable {
  const ChallengesState();

  @override
  List<Object> get props => [];
}

final class ChallengesInitial extends ChallengesState {}

final class ChallengesLoading extends ChallengesState {}

final class ChallengesLoaded extends ChallengesState {
  final Challengesmodel model;
  const ChallengesLoaded(this.model);
  @override
  List<Object> get props => [model];
}

final class ChallengesError extends ChallengesState {
  final String error;
  const ChallengesError(this.error);
  @override
  List<Object> get props => [error];
}
