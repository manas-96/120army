import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/otp_model.dart';
import '../../services/main_service.dart';

part 'confirmationcode_event.dart';
part 'confirmationcode_state.dart';

class ConfirmationcodeBloc
    extends Bloc<ConfirmationcodeEvent, ConfirmationcodeState> {
  final _service = MainService();
  ConfirmationcodeBloc() : super(ConfirmationcodeInitial()) {
    on<ConfirmationcodeEventTrigger>(_confirmationcodeeventtrigger);
  }

  void _confirmationcodeeventtrigger(
    ConfirmationcodeEventTrigger event,
    Emitter<ConfirmationcodeState> emit,
  ) async {
    emit(ConfirmationcodeLoading());
    try {
      Otpmodel? response = await _service.otpService(user_id: event.user_id);
      emit(ConfirmationcodeLoaded(response!));
    } catch (e) {
      emit(ConfirmationcodeError(e.toString()));
    }
  }
}
