part of 'photolist_bloc.dart';

sealed class PhotolistEvent extends Equatable {
  const PhotolistEvent();

  @override
  List<Object?> get props => [];
}

final class PhotolistTrigger extends PhotolistEvent {
  final String? userId;

  const PhotolistTrigger({this.userId});

  @override
  List<Object?> get props => [userId];
}
