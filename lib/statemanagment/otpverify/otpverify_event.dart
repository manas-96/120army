part of 'otpverify_bloc.dart';

sealed class OtpverifyEvent extends Equatable {
  const OtpverifyEvent();

  @override
  List<Object> get props => [];
}

final class OtpverifyEventTrigger extends OtpverifyEvent {
  final String otp;
  final String user_id;
  final String type;
  const OtpverifyEventTrigger(this.otp, this.user_id, this.type);

  @override
  List<Object> get props => [otp, user_id, type];
}
