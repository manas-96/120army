import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/otp__verify_model.dart';
import '../../services/main_service.dart';

part 'otpverify_event.dart';
part 'otpverify_state.dart';

class OtpverifyBloc extends Bloc<OtpverifyEvent, OtpverifyState> {
  final _service = MainService();
  OtpverifyBloc() : super(OtpverifyInitial()) {
    on<OtpverifyEventTrigger>(otpverifyeventtrigger);
  }
  void otpverifyeventtrigger(
    OtpverifyEventTrigger event,
    Emitter<OtpverifyState> emit,
  ) async {
    emit(OtpverifyLoading());

    try {
      Otpverifymodel? response = await _service.otpverifyService(
        otp: event.otp,
        user_id: event.user_id,
        type: event.type,
      );
      emit(OtpverifyLoaded(response!));
    } catch (e) {
      emit(OtpverifyError(e.toString()));
    }
  }
}
