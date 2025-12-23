part of 'commentlist_bloc.dart';

sealed class CommentlistState extends Equatable {
  const CommentlistState();

  @override
  List<Object> get props => [];
}

final class CommentlistInitial extends CommentlistState {}

final class CommentlistLoading extends CommentlistState {}

final class CommentlistLoaded extends CommentlistState {
  final Commentlistmodel model;
  const CommentlistLoaded(this.model);
  @override
  List<Object> get props => [model];
}

final class CommentlistError extends CommentlistState {
  final String error;
  const CommentlistError(this.error);
  @override
  List<Object> get props => [error];
}
