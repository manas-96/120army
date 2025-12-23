part of 'otherprofile_bloc.dart';

sealed class OtherprofileEvent extends Equatable {
  const OtherprofileEvent();

  @override
  List<Object?> get props => [];
}

final class OtherprofileTrigger extends OtherprofileEvent {
  final String? userId;

  const OtherprofileTrigger({this.userId});

  @override
  List<Object?> get props => [userId];
}
