part of 'friendrequestlist_bloc.dart';

sealed class FriendrequestlistState extends Equatable {
  const FriendrequestlistState();

  @override
  List<Object> get props => [];
}

final class FriendrequestlistInitial extends FriendrequestlistState {}

final class FriendrequestlistLoading extends FriendrequestlistState {}

final class FriendrequestlistLoaded extends FriendrequestlistState {
  final Suggestfriendlistmodel model;
  const FriendrequestlistLoaded(this.model);
  @override
  List<Object> get props => [model];
}

final class FriendrequestlistError extends FriendrequestlistState {
  final String error;
  const FriendrequestlistError(this.error);
  @override
  List<Object> get props => [error];
}
