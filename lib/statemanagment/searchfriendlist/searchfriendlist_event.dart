// searchfriendlist_event.dart
part of 'searchfriendlist_bloc.dart';

abstract class SearchfriendlistEvent extends Equatable {
  const SearchfriendlistEvent();

  @override
  List<Object?> get props => [];
}

class SearchfriendlistTrigger extends SearchfriendlistEvent {
  final int page;
  final bool aLoading;
  final String searchText;

  const SearchfriendlistTrigger({
    this.page = 1,
    this.aLoading = true,
    this.searchText = "",
  });

  @override
  List<Object?> get props => [page, aLoading, searchText];
}
