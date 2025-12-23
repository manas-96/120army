import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/rewards_level_model.dart';
import '../../services/main_service.dart';

part 'rewardslevel_event.dart';
part 'rewardslevel_state.dart';

class RewardslevelBloc extends Bloc<RewardslevelEvent, RewardslevelState> {
  final _service = MainService();
  RewardslevelBloc() : super(RewardslevelInitial()) {
    on<RewardslevelEventTrigger>(rewardsleveleventtrigger);
  }

  FutureOr<void> rewardsleveleventtrigger(
    RewardslevelEventTrigger event,
    Emitter<RewardslevelState> emit,
  ) async {
    emit(RewardslevelLoading());
    try {
      Rewardlevelmodel? response = await _service.rewardlevelService(
        userId: event.userId,
      );
      emit(RewardslevelLoaded(response!));
    } catch (e) {
      emit(RewardslevelError(e.toString()));
    }
  }
}
