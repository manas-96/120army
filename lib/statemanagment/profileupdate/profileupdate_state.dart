part of 'profileupdate_bloc.dart';

sealed class ProfileupdateState extends Equatable {
  const ProfileupdateState();

  @override
  List<Object> get props => [];
}

final class ProfileupdateInitial extends ProfileupdateState {}

final class ProfileUpdateLoading extends ProfileupdateState {}

final class ProfileUpdateSuccess extends ProfileupdateState {
  final Profileupdatemodel model;

  const ProfileUpdateSuccess(this.model);
  @override
  List<Object> get props => [model];
}

final class ProfileUpdateFailure extends ProfileupdateState {
  final String error;

  const ProfileUpdateFailure(this.error);
  @override
  List<Object> get props => [error];
}
