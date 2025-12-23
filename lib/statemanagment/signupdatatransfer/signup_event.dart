part of 'signup_bloc.dart';

sealed class SignupEvent extends Equatable {
  const SignupEvent();

  @override
  List<Object> get props => [];
}

class UpdateName extends SignupEvent {
  final String firstname;
  final String lastname;

  const UpdateName(this.firstname, this.lastname);
  @override
  List<Object> get props => [firstname, lastname];
}

class UpdateGender extends SignupEvent {
  final String gender;

  const UpdateGender(this.gender);
  @override
  List<Object> get props => [gender];
}

class UpdateDob extends SignupEvent {
  final DateTime dateofbirth;
  const UpdateDob(this.dateofbirth);
  @override
  List<Object> get props => [dateofbirth];
}

class UpdateType extends SignupEvent {
  final String type;
  const UpdateType(this.type);
  @override
  List<Object> get props => [type];
}

// class UpdateEmailPhonePass extends SignupEvent {
//   final String email;
//   final int phoneno;
//   final String pass;
//   const UpdateEmailPhonePass(this.email, this.phoneno, this.pass);
//   @override
//   List<Object> get props => [email, phoneno, pass];
// }
