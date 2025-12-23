part of 'profillecoverchange_bloc.dart';

sealed class ProfillecoverchangeState extends Equatable {
  const ProfillecoverchangeState();

  @override
  List<Object?> get props => [];
}

final class ProfillecoverchangeInitial extends ProfillecoverchangeState {}

class ProfileCoverLoaded extends ProfillecoverchangeState {
  final String? profilePic;
  final String? coverPic;

  const ProfileCoverLoaded({this.profilePic, this.coverPic});

  ProfileCoverLoaded copyWith({String? profilePic, String? coverPic}) {
    return ProfileCoverLoaded(
      profilePic: profilePic ?? this.profilePic,
      coverPic: coverPic ?? this.coverPic,
    );
  }

  @override
  List<Object?> get props => [profilePic, coverPic];
}
