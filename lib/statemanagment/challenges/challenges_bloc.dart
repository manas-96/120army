import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/challenges_model.dart';
import '../../services/main_service.dart';

part 'challenges_event.dart';
part 'challenges_state.dart';

class ChallengesBloc extends Bloc<ChallengesEvent, ChallengesState> {
  final _service = MainService();
  ChallengesBloc() : super(ChallengesInitial()) {
    on<ChallengesTrigger>(challengestrigger);
  }

  FutureOr<void> challengestrigger(
    ChallengesTrigger event,
    Emitter<ChallengesState> emit,
  ) async {
    emit(ChallengesLoading());
    try {
      Challengesmodel? response = await _service.challengesService(
        userId: event.userId,
      );
      emit(ChallengesLoaded(response!));
    } catch (e) {
      emit(ChallengesError(e.toString()));
    }
  }
}
