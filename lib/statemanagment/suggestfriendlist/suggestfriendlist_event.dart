part of 'suggestfriendlist_bloc.dart';

abstract class SuggestfriendlistEvent extends Equatable {
  const SuggestfriendlistEvent();

  @override
  List<Object?> get props => [];
}

class SuggestfriendlistTrigger extends SuggestfriendlistEvent {
  final bool showLoading;

  const SuggestfriendlistTrigger({this.showLoading = true});

  @override
  List<Object?> get props => [showLoading];
}

class SuggestfriendlistLoadMore extends SuggestfriendlistEvent {}
