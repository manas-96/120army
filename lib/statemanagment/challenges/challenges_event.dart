part of 'challenges_bloc.dart';

sealed class ChallengesEvent extends Equatable {
  const ChallengesEvent();

  @override
  List<Object?> get props => [];
}

final class ChallengesTrigger extends ChallengesEvent {
  final String? userId;

  const ChallengesTrigger({this.userId});

  @override
  List<Object?> get props => [userId];
}
