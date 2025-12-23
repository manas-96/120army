import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/suggest_friend_list_model.dart';
import '../../services/main_service.dart';

part 'friendrequestlist_event.dart';
part 'friendrequestlist_state.dart';

// friendrequestlist_bloc.dart

class FriendrequestlistBloc
    extends Bloc<FriendrequestlistEvent, FriendrequestlistState> {
  final _service = MainService();

  FriendrequestlistBloc() : super(FriendrequestlistInitial()) {
    on<FriendrequestlistTrigger>(friendrequestlisttrigger);
  }

  FutureOr<void> friendrequestlisttrigger(
    FriendrequestlistTrigger event,
    Emitter<FriendrequestlistState> emit,
  ) async {
    if (event.showLoading) {
      emit(FriendrequestlistLoading());
    }

    try {
      final response = await _service.friendrequestlistService();
      emit(FriendrequestlistLoaded(response));
    } catch (e) {
      emit(FriendrequestlistError(e.toString()));
    }
  }
}
