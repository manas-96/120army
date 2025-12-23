// friendrequestlist_event.dart

part of 'friendrequestlist_bloc.dart';

sealed class FriendrequestlistEvent extends Equatable {
  const FriendrequestlistEvent();

  @override
  List<Object> get props => [];
}

final class FriendrequestlistTrigger extends FriendrequestlistEvent {
  final bool showLoading;

  const FriendrequestlistTrigger({this.showLoading = true});

  @override
  List<Object> get props => [showLoading];
}
