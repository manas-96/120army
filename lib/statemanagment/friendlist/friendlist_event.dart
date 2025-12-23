part of 'friendlist_bloc.dart';

sealed class FriendlistEvent extends Equatable {
  const FriendlistEvent();

  @override
  List<Object> get props => [];
}

final class FriendlistTrigger extends FriendlistEvent {}
