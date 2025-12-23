part of 'profillecoverchange_bloc.dart';

sealed class ProfillecoverchangeEvent extends Equatable {
  const ProfillecoverchangeEvent();

  @override
  List<Object?> get props => [];
}

// Load profile+cover from SharedPref
class LoadProfileCoverEvent extends ProfillecoverchangeEvent {}

// Update profile image
class UpdateProfilePicEvent extends ProfillecoverchangeEvent {
  final String profilePic;
  const UpdateProfilePicEvent(this.profilePic);

  @override
  List<Object?> get props => [profilePic];
}

// Update cover image
class UpdateCoverPicEvent extends ProfillecoverchangeEvent {
  final String coverPic;
  const UpdateCoverPicEvent(this.coverPic);

  @override
  List<Object?> get props => [coverPic];
}
