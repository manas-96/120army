import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../model/suggest_friend_list_model.dart';
import '../../services/main_service.dart';

part 'suggestfriendlist_event.dart';
part 'suggestfriendlist_state.dart';

class SuggestfriendlistBloc
    extends Bloc<SuggestfriendlistEvent, SuggestfriendlistState> {
  final _service = MainService();

  int _currentPage = 1;
  bool _hasReachedMax = false;
  bool _isLoadingMore = false;
  List<Suggestdatum> _allData = [];

  SuggestfriendlistBloc() : super(SuggestfriendlistInitial()) {
    on<SuggestfriendlistTrigger>(_onFirstLoad);
    on<SuggestfriendlistLoadMore>(_onLoadMore);
  }

  Future<void> _onFirstLoad(
    SuggestfriendlistTrigger event,
    Emitter<SuggestfriendlistState> emit,
  ) async {
    if (event.showLoading) {
      emit(SuggestfriendlistLoading());
    }

    try {
      _currentPage = 1;
      _hasReachedMax = false;
      _allData.clear();

      final response = await _service.suggestfriendlistService(
        page: _currentPage,
      );

      _allData = response.data;
      _hasReachedMax = _allData.length >= response.total;

      emit(
        SuggestfriendlistLoaded(
          Suggestfriendlistmodel(
            data: _allData,
            total: response.total,
            status: response.status,
            msg: response.msg,
          ),
        ),
      );
    } catch (e) {
      emit(SuggestfriendlistError(e.toString()));
    }
  }

  Future<void> _onLoadMore(
    SuggestfriendlistLoadMore event,
    Emitter<SuggestfriendlistState> emit,
  ) async {
    if (_hasReachedMax || _isLoadingMore) return;

    _isLoadingMore = true;

    try {
      _currentPage++;
      final response = await _service.suggestfriendlistService(
        page: _currentPage,
      );
      final newData = response.data;

      if (newData.isEmpty) {
        _hasReachedMax = true;
        return;
      }

      _allData.addAll(newData);
      _hasReachedMax = _allData.length >= response.total;

      emit(
        SuggestfriendlistLoaded(
          Suggestfriendlistmodel(
            data: _allData,
            total: response.total,
            status: response.status,
            msg: response.msg,
          ),
        ),
      );
    } catch (e) {
      // Optional: handle error gracefully
    } finally {
      _isLoadingMore = false;
    }
  }
}
