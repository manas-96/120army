import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/commentlist_model.dart';
import '../../services/main_service.dart';

part 'commentlist_event.dart';
part 'commentlist_state.dart';

class CommentlistBloc extends Bloc<CommentlistEvent, CommentlistState> {
  final _service = MainService();
  CommentlistBloc() : super(CommentlistInitial()) {
    on<CommentlistTrigger>(_commentlisttrigger);
  }

  FutureOr<void> _commentlisttrigger(
    CommentlistTrigger event,
    Emitter<CommentlistState> emit,
  ) async {
    if (event.showLoading) {
      emit(CommentlistLoading()); // 🔹 only when true
    }

    try {
      final response = await _service.commentListService(postid: event.postid);
      emit(CommentlistLoaded(response));
    } catch (e) {
      emit(CommentlistError(e.toString()));
    }
  }
}
