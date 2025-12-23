part of 'signup_bloc.dart';

class SignupState extends Equatable {
  final String firstName;
  final String lastName;
  final String email;
  final String gender;
  final DateTime? dob;
  final String mobile;
  final String password;
  final String type;

  const SignupState({
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.gender = '',
    this.dob,
    this.mobile = '',
    this.password = '',
    this.type = 'phone',
  });

  SignupState copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? gender,
    DateTime? dob,
    String? mobile,
    String? password,
    String? type,
  }) {
    return SignupState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      mobile: mobile ?? this.mobile,
      password: password ?? this.password,
      type: type ?? this.type,
    );
  }

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    gender,
    dob,
    mobile,
    password,
    type,
  ];
}
