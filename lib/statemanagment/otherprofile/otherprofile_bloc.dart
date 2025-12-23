import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/other_profile_model.dart';
import '../../services/main_service.dart';

part 'otherprofile_event.dart';
part 'otherprofile_state.dart';

class OtherprofileBloc extends Bloc<OtherprofileEvent, OtherprofileState> {
  final _service = MainService();

  OtherprofileBloc() : super(OtherprofileInitial()) {
    on<OtherprofileTrigger>(_otherprofileTrigger);
  }

  FutureOr<void> _otherprofileTrigger(
    OtherprofileTrigger event,
    Emitter<OtherprofileState> emit,
  ) async {
    emit(OtherprofileLoading());
    try {
      final response = await _service.otherprofileService(userId: event.userId);

      if (response != null) {
        emit(OtherprofileLoaded(response));
      } else {
        emit(const OtherprofileError("No data received"));
      }
    } catch (e) {
      emit(OtherprofileError(e.toString()));
    }
  }
}
