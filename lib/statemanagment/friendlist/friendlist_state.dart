part of 'friendlist_bloc.dart';

sealed class FriendlistState extends Equatable {
  const FriendlistState();

  @override
  List<Object> get props => [];
}

final class FriendlistInitial extends FriendlistState {}

final class FriendlistLoading extends FriendlistState {}

final class FriendlistLoaded extends FriendlistState {
  final Suggestfriendlistmodel model;
  const FriendlistLoaded(this.model);
  @override
  List<Object> get props => [model];
}

final class FriendlistError extends FriendlistState {
  final String error;
  const FriendlistError(this.error);
  @override
  List<Object> get props => [error];
}
