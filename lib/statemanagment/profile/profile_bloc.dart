import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/profile_model.dart';
import '../../services/main_service.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final _service = MainService();

  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileLoadedEvent>(
      (event, emit) => _handleProfileLoad(emit, showLoading: true),
    );
    on<ProfileLoadedEventnonload>(
      (event, emit) => _handleProfileLoad(emit, showLoading: false),
    );
  }

  Future<void> _handleProfileLoad(
    Emitter<ProfileState> emit, {
    required bool showLoading,
  }) async {
    if (showLoading) emit(ProfileLoading());
    try {
      final response = await _service.profileService();
      emit(ProfileLoaded(response!));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
