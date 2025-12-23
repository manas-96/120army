import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/profileupdate_model.dart';
import '../../services/main_service.dart';

part 'profileupdate_event.dart';
part 'profileupdate_state.dart';

class ProfileupdateBloc extends Bloc<ProfileupdateEvent, ProfileupdateState> {
  final _service = MainService();
  ProfileupdateBloc() : super(ProfileupdateInitial()) {
    on<SubmitProfileUpdateevent>(submitprofileupdateevent);
  }

  FutureOr<void> submitprofileupdateevent(
    SubmitProfileUpdateevent event,
    Emitter<ProfileupdateState> emit,
  ) async {
    emit(ProfileUpdateLoading());

    try {
      Profileupdatemodel? response = await _service.profileupdateService(
        formnum: event.formnum,
        first_name: event.firstName,
        last_name: event.lastName,
        bio: event.bio,
        phone_no: event.phoneNo,
        email: event.email,
        gender: event.gender,
        date_of_birth: event.dateOfBirth,
        language: event.language,
        places_lived: event.placesLived,
        image: event.image,
      );
      emit(ProfileUpdateSuccess(response!));
    } catch (e) {
      emit(ProfileUpdateFailure(e.toString()));
    }
  }
}
