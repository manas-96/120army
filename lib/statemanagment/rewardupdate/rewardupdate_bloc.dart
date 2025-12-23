import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/rewardupdate_model.dart';
import '../../services/main_service.dart';

part 'rewardupdate_event.dart';
part 'rewardupdate_state.dart';

class RewardupdateBloc extends Bloc<RewardupdateEvent, RewardupdateState> {
  final _service = MainService();
  RewardupdateBloc() : super(RewardupdateInitial()) {
    on<RewardupdateEventTrigger>(rewardupdateeventtrigger);
  }

  FutureOr<void> rewardupdateeventtrigger(
    RewardupdateEventTrigger event,
    Emitter<RewardupdateState> emit,
  ) async {
    emit(RewardupdateLoading());
    try {
      Rewardupdate? response = await _service.rewardupdateService(
        event.rewardid,
        event.taskid,
      );
      emit(RewardupdateLoaded(response!));
    } catch (e) {
      emit(RewardupdateError(e.toString()));
    }
  }
}
