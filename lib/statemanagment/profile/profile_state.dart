part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileLoaded extends ProfileState {
  final Profilemodel model;
  const ProfileLoaded(this.model);
  @override
  List<Object> get props => [model];
}

final class ProfileError extends ProfileState {
  final String error;
  const ProfileError(this.error);
  @override
  List<Object> get props => [error];
}
