part of 'profileupdate_bloc.dart';

sealed class ProfileupdateEvent extends Equatable {
  const ProfileupdateEvent();

  @override
  List<Object> get props => [];
}

class SubmitProfileUpdateevent extends ProfileupdateEvent {
  final int formnum;
  final String? firstName;
  final String? lastName;
  final String? bio;
  final String? phoneNo;
  final String? email;
  final String? gender;
  final String? dateOfBirth;
  final String? language;
  final String? placesLived;
  final String? image;

  const SubmitProfileUpdateevent({
    required this.formnum,
    this.firstName,
    this.lastName,
    this.bio,
    this.phoneNo,
    this.email,
    this.gender,
    this.dateOfBirth,
    this.language,
    this.placesLived,
    this.image,
  });

  @override
  List<Object> get props => [
    formnum,
    firstName.toString(),
    lastName.toString(),
    bio.toString(),
    phoneNo.toString(),
    email.toString(),
    gender.toString(),
    dateOfBirth.toString(),
    language.toString(),
    placesLived.toString(),
    image.toString(),
  ];
}
