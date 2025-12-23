import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/suggest_friend_list_model.dart';
import '../../services/main_service.dart';

part 'friendlist_event.dart';
part 'friendlist_state.dart';

class FriendlistBloc extends Bloc<FriendlistEvent, FriendlistState> {
  final _service = MainService();
  FriendlistBloc() : super(FriendlistInitial()) {
    on<FriendlistTrigger>(friendlisttrigger);
  }

  FutureOr<void> friendlisttrigger(
    FriendlistTrigger event,
    Emitter<FriendlistState> emit,
  ) async {
    emit(FriendlistLoading());

    try {
      final response = await _service.friendlistService();
      emit(FriendlistLoaded(response));
    } catch (e) {
      emit(FriendlistError(e.toString()));
    }
  }
}
