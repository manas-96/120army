import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/reward_tasklist_model.dart';
import '../../services/main_service.dart';

part 'rewardlist_event.dart';
part 'rewardlist_state.dart';

class RewardlistBloc extends Bloc<RewardlistEvent, RewardlistState> {
  final _service = MainService();
  RewardlistBloc() : super(RewardlistInitial()) {
    on<RewardlistEventLoaded>(rewardlisteventloaded);
  }

  FutureOr<void> rewardlisteventloaded(
    RewardlistEventLoaded event,
    Emitter<RewardlistState> emit,
  ) async {
    emit(RewardlistLoading());
    try {
      Rewardtasklist? response = await _service.rewardlistService();
      emit(RewardlistLoaded(response!));
    } catch (e) {
      emit(RewardlistError(e.toString()));
    }
  }
}
