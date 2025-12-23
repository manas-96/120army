part of 'suggestfriendlist_bloc.dart';

sealed class SuggestfriendlistState extends Equatable {
  const SuggestfriendlistState();
  @override
  List<Object> get props => [];
}

final class SuggestfriendlistInitial extends SuggestfriendlistState {}

final class SuggestfriendlistLoading extends SuggestfriendlistState {}

final class SuggestfriendlistLoaded extends SuggestfriendlistState {
  final Suggestfriendlistmodel model;
  const SuggestfriendlistLoaded(this.model);

  @override
  List<Object> get props => [model];
}

final class SuggestfriendlistError extends SuggestfriendlistState {
  final String error;
  const SuggestfriendlistError(this.error);

  @override
  List<Object> get props => [error];
}
