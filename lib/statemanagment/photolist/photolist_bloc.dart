import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/photoslist_model.dart';
import '../../services/main_service.dart';

part 'photolist_event.dart';
part 'photolist_state.dart';

class PhotolistBloc extends Bloc<PhotolistEvent, PhotolistState> {
  final _service = MainService();

  PhotolistBloc() : super(PhotolistInitial()) {
    on<PhotolistTrigger>(_photolistTrigger);
  }

  FutureOr<void> _photolistTrigger(
    PhotolistTrigger event,
    Emitter<PhotolistState> emit,
  ) async {
    emit(PhotolistLoading());
    try {
      final response = await _service.photoslistService(userId: event.userId);

      if (response != null) {
        emit(PhotolistLoaded(response));
      } else {
        emit(const PhotolistError("No data received"));
      }
    } catch (e) {
      emit(PhotolistError(e.toString()));
    }
  }
}
