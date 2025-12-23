part of 'searchfriendlist_bloc.dart';

sealed class SearchfriendlistState extends Equatable {
  const SearchfriendlistState();

  @override
  List<Object> get props => [];
}

final class SearchfriendlistInitial extends SearchfriendlistState {}

final class SearchfriendlistLoading extends SearchfriendlistState {}

final class SearchfriendlistLoaded extends SearchfriendlistState {
  final List<Suggestdatum> dataList;
  final bool isLoadingMore;

  const SearchfriendlistLoaded({
    required this.dataList,
    this.isLoadingMore = false,
  });

  @override
  List<Object> get props => [dataList, isLoadingMore];
}

final class SearchfriendlistError extends SearchfriendlistState {
  final String error;
  const SearchfriendlistError(this.error);

  @override
  List<Object> get props => [error];
}
