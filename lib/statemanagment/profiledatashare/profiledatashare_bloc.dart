import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/profile_model.dart';

part 'profiledatashare_event.dart';
part 'profiledatashare_state.dart';

class ProfiledatashareBloc
    extends Bloc<ProfiledatashareEvent, ProfiledatashareState> {
  ProfiledatashareBloc() : super(ProfiledatashareInitial()) {
    on<ProfiledatashareEventLoaded>(profiledatashareeventloaded);
  }

  FutureOr<void> profiledatashareeventloaded(
    ProfiledatashareEventLoaded event,
    Emitter<ProfiledatashareState> emit,
  ) {
    emit(ProfiledatashareLoaded(event.model));
  }
}
