import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/weeklypc_model.dart';
import '../../services/main_service.dart';

part 'weeklypc_event.dart';
part 'weeklypc_state.dart';

class WeeklypcBloc extends Bloc<WeeklypcEvent, WeeklypcState> {
  final _service = MainService();
  WeeklypcBloc() : super(WeeklypcInitial()) {
    on<WeeklypcTrigger>(weeklypctrigger);
  }

  FutureOr<void> weeklypctrigger(
    WeeklypcTrigger event,
    Emitter<WeeklypcState> emit,
  ) async {
    emit(WeeklypcLoading());
    try {
      Weeklypcmodel? response = await _service.weeklypcService();
      emit(WeeklypcLoaded(response!));
    } catch (e) {
      emit(WeeklypcError(e.toString()));
    }
  }
}
