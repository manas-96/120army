part of 'commentlist_bloc.dart';

abstract class CommentlistEvent extends Equatable {
  const CommentlistEvent();

  @override
  List<Object?> get props => [];
}

class CommentlistTrigger extends CommentlistEvent {
  final String postid;
  final bool showLoading; // 🔹 new

  const CommentlistTrigger({required this.postid, this.showLoading = true});

  @override
  List<Object?> get props => [postid, showLoading];
}
