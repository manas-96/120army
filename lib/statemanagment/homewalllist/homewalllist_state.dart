part of 'homewalllist_bloc.dart';

sealed class HomewalllistState extends Equatable {
  const HomewalllistState();

  @override
  List<Object> get props => [];
}

final class HomewalllistInitial extends HomewalllistState {}

final class HomewalllistLoading extends HomewalllistState {}

final class HomewalllistLoaded extends HomewalllistState {
  final List<PostlistDatum> posts;
  final bool hasReachedMax;

  const HomewalllistLoaded({required this.posts, required this.hasReachedMax});

  HomewalllistLoaded copyWith({
    List<PostlistDatum>? posts,
    bool? hasReachedMax,
  }) {
    return HomewalllistLoaded(
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [posts, hasReachedMax]; // Include the full posts list
}

final class HomewalllistError extends HomewalllistState {
  final String error;
  const HomewalllistError(this.error);
  @override
  List<Object> get props => [error];
}
