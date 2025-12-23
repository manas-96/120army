part of 'otherprofile_bloc.dart';

sealed class OtherprofileState extends Equatable {
  const OtherprofileState();

  @override
  List<Object> get props => [];
}

final class OtherprofileInitial extends OtherprofileState {}

final class OtherprofileLoading extends OtherprofileState {}

final class OtherprofileLoaded extends OtherprofileState {
  final Otherprofilemodel model;
  const OtherprofileLoaded(this.model);
  @override
  List<Object> get props => [model];
}

final class OtherprofileError extends OtherprofileState {
  final String error;
  const OtherprofileError(this.error);
  @override
  List<Object> get props => [error];
}
