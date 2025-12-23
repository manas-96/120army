import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/listpost_model.dart';
import '../../services/main_service.dart';

part 'homewalllist_event.dart';
part 'homewalllist_state.dart';

class HomewalllistBloc extends Bloc<HomewalllistEvent, HomewalllistState> {
  final _service = MainService();

  int page = 1;
  bool isLoading = false; // prevent multiple calls
  int total = 0; // store total from API

  HomewalllistBloc() : super(HomewalllistInitial()) {
    on<HomewalllistFetch>(_onFetch);
    on<HomewalllistLoadMore>(_onLoadMore);
    on<HomewalllistDelete>(_onDelete);
  }

  Future<void> _onFetch(
    HomewalllistFetch event,
    Emitter<HomewalllistState> emit,
  ) async {
    if (event.showLoader) {
      emit(HomewalllistLoading());
    }
    try {
      page = 1; // reset
      final response = await _service.postListService(page: page);
      total = response.total; // store total count from API
      final posts = response.data;

      // ✅ Always emit new state, even if showLoader is false
      emit(
        HomewalllistLoaded(
          posts: List<PostlistDatum>.from(posts), // create new list object
          hasReachedMax: posts.length >= total,
        ),
      );
    } catch (e) {
      emit(HomewalllistError(e.toString()));
    }
  }

  Future<void> _onLoadMore(
    HomewalllistLoadMore event,
    Emitter<HomewalllistState> emit,
  ) async {
    if (isLoading) return; // prevent double fire
    if (state is! HomewalllistLoaded) return;

    final currentState = state as HomewalllistLoaded;
    if (currentState.hasReachedMax) return;

    try {
      isLoading = true;
      page++; // ✅ increment page here only

      final response = await _service.postListService(page: page);
      final newPosts = response.data;

      final allPosts = currentState.posts + newPosts;

      emit(
        HomewalllistLoaded(
          posts: allPosts,
          hasReachedMax: allPosts.length >= total, // ✅ compare with total
        ),
      );
    } catch (e) {
      emit(HomewalllistError(e.toString()));
    } finally {
      isLoading = false;
    }
  }

  Future<void> _onDelete(
    HomewalllistDelete event,
    Emitter<HomewalllistState> emit,
  ) async {
    if (state is HomewalllistLoaded) {
      final currentState = state as HomewalllistLoaded;

      final updatedPosts = List<PostlistDatum>.from(currentState.posts)
        ..removeWhere((p) => p.id == event.postId);

      // emit new state with updated list
      emit(
        currentState.copyWith(
          posts: updatedPosts,
          hasReachedMax: updatedPosts.length >= total,
        ),
      );

      // call API in background (don’t block UI)
      try {
        await _service.deletepostService(id: event.postId);
      } catch (e) {
        // optional: rollback or show error toast
        print("Delete failed: $e");
      }
    }
  }
}
