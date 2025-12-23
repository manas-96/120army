import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/register_model.dart';
import '../../services/main_service.dart';

part 'signupregistration_event.dart';
part 'signupregistration_state.dart';

class SignupregistrationBloc
    extends Bloc<SignupregistrationEvent, SignupregistrationState> {
  final _service = MainService();
  SignupregistrationBloc() : super(SignupregistrationInitial()) {
    on<SignupregistrationEventTrigger>(signupregistrationeventtrigger);
  }

  void signupregistrationeventtrigger(
    SignupregistrationEventTrigger event,
    Emitter<SignupregistrationState> emit,
  ) async {
    emit(SignupregistrationLoading());

    try {
      Registermodel? response = await _service.registerService(
        first_name: event.first_name,
        last_name: event.last_name,
        email: event.email,
        type: event.type,
        phone_no: event.phone_no,
        country_code: event.country_code,
        gender: event.gender,
        date_of_birth: event.date_of_birth,
        password: event.password,
        timezone: event.timezone,
      );
      emit(SignupregistrationLoaded(response!));
    } catch (e) {
      emit(SignupregistrationError(e.toString()));
    }
  }
}
