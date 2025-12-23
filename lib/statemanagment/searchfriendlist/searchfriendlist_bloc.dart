import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../model/suggest_friend_list_model.dart';
import '../../services/main_service.dart';

part 'searchfriendlist_event.dart';
part 'searchfriendlist_state.dart';

class SearchfriendlistBloc
    extends Bloc<SearchfriendlistEvent, SearchfriendlistState> {
  final _service = MainService();

  int currentPage = 1;
  bool isLoadingMore = false;
  List<Suggestdatum> allData = [];

  SearchfriendlistBloc() : super(SearchfriendlistInitial()) {
    on<SearchfriendlistTrigger>(_onSearchFriendListTrigger);
  }

  Future<void> _onSearchFriendListTrigger(
    SearchfriendlistTrigger event,
    Emitter<SearchfriendlistState> emit,
  ) async {
    if (event.page == 1) {
      if (event.aLoading) {
        emit(SearchfriendlistLoading());
      } else {
        emit(SearchfriendlistLoaded(dataList: allData, isLoadingMore: false));
      }
    } else {
      isLoadingMore = true;
      emit(SearchfriendlistLoaded(dataList: allData, isLoadingMore: true));
    }

    try {
      final response = await _service.searchfriendlistService(
        page: event.page,
        search: event.searchText,
      );

      if (event.page == 1) {
        allData = response.data;
      } else {
        allData.addAll(response.data);
      }

      currentPage = event.page;

      emit(SearchfriendlistLoaded(dataList: allData, isLoadingMore: false));
    } catch (e) {
      emit(SearchfriendlistError(e.toString()));
    } finally {
      isLoadingMore = false;
    }
  }
}
