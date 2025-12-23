part of 'signupregistration_bloc.dart';

sealed class SignupregistrationEvent extends Equatable {
  const SignupregistrationEvent();

  @override
  List<Object> get props => [];
}

final class SignupregistrationEventTrigger extends SignupregistrationEvent {
  final String first_name;
  final String last_name;
  final String email;
  final String type;
  final String phone_no;
  final String country_code;
  final String gender;
  final String date_of_birth;
  final String password;
  final String timezone;

  const SignupregistrationEventTrigger(
    this.first_name,
    this.last_name,
    this.email,
    this.type,
    this.phone_no,
    this.country_code,
    this.gender,
    this.date_of_birth,
    this.password,
    this.timezone,
  );
  @override
  List<Object> get props => [
    first_name,
    last_name,
    email,
    type,
    phone_no,
    country_code,
    gender,
    date_of_birth,
    password,
    timezone,
  ];
}
