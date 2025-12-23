part of 'profiledatashare_bloc.dart';

sealed class ProfiledatashareEvent extends Equatable {
  const ProfiledatashareEvent();

  @override
  List<Object> get props => [];
}

final class ProfiledatashareEventLoaded extends ProfiledatashareEvent {
  final Profiledata model;
  const ProfiledatashareEventLoaded(this.model);
  @override
  List<Object> get props => [model];
}
