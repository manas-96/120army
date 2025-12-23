import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(SignupState()) {
    on<UpdateName>(updatename);
    on<UpdateGender>(updategender);
    on<UpdateDob>(updateDob);
    on<UpdateType>(updateType);
  }

  void updatename(UpdateName event, Emitter<SignupState> emit) {
    emit(state.copyWith(firstName: event.firstname, lastName: event.lastname));
  }

  void updategender(UpdateGender event, Emitter<SignupState> emit) {
    emit(state.copyWith(gender: event.gender));
  }

  void updateDob(UpdateDob event, Emitter<SignupState> emit) {
    emit(state.copyWith(dob: event.dateofbirth));
  }

  void updateType(UpdateType event, Emitter<SignupState> emit) {
    emit(state.copyWith(type: event.type));
  }
}
