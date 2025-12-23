part of 'homewalllist_bloc.dart';

sealed class HomewalllistEvent extends Equatable {
  const HomewalllistEvent();

  @override
  List<Object> get props => [];
}

/// First time load
/// First time load
final class HomewalllistFetch extends HomewalllistEvent {
  final int page;
  final bool showLoader;

  const HomewalllistFetch(this.page, {this.showLoader = true});

  @override
  List<Object> get props => [page, showLoader];
}

/// Load more (pagination)
final class HomewalllistLoadMore extends HomewalllistEvent {
  final int page;
  const HomewalllistLoadMore(this.page);

  @override
  List<Object> get props => [page];
}

/// Delete a post
final class HomewalllistDelete extends HomewalllistEvent {
  final String postId;
  const HomewalllistDelete(this.postId);

  @override
  List<Object> get props => [postId];
}
