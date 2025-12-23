part of 'profiledatashare_bloc.dart';

sealed class ProfiledatashareState extends Equatable {
  const ProfiledatashareState();

  @override
  List<Object> get props => [];
}

final class ProfiledatashareInitial extends ProfiledatashareState {}

final class ProfiledatashareLoaded extends ProfiledatashareState {
  final Profiledata model;
  const ProfiledatashareLoaded(this.model);
  @override
  List<Object> get props => [model];
}
