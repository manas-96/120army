part of 'photolist_bloc.dart';

sealed class PhotolistState extends Equatable {
  const PhotolistState();

  @override
  List<Object> get props => [];
}

final class PhotolistInitial extends PhotolistState {}

final class PhotolistLoading extends PhotolistState {}

final class PhotolistLoaded extends PhotolistState {
  final Photoslist model;
  const PhotolistLoaded(this.model);
  @override
  List<Object> get props => [model];
}

final class PhotolistError extends PhotolistState {
  final String error;
  const PhotolistError(this.error);
  @override
  List<Object> get props => [error];
}
