import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../shared_pref.dart';

part 'profillecoverchange_event.dart';
part 'profillecoverchange_state.dart';

class ProfillecoverchangeBloc
    extends Bloc<ProfillecoverchangeEvent, ProfillecoverchangeState> {
  ProfillecoverchangeBloc() : super(ProfillecoverchangeInitial()) {
    on<LoadProfileCoverEvent>(_onLoadProfileCover);
    on<UpdateProfilePicEvent>(_onUpdateProfilePic);
    on<UpdateCoverPicEvent>(_onUpdateCoverPic);
  }

  Future<void> _onLoadProfileCover(
    LoadProfileCoverEvent event,
    Emitter<ProfillecoverchangeState> emit,
  ) async {
    final profilePic = SharedPrefUtils.getCachedStr("profilepic");
    final coverPic = SharedPrefUtils.getCachedStr("coverpic");

    emit(ProfileCoverLoaded(profilePic: profilePic, coverPic: coverPic));
  }

  Future<void> _onUpdateProfilePic(
    UpdateProfilePicEvent event,
    Emitter<ProfillecoverchangeState> emit,
  ) async {
    await SharedPrefUtils.saveStr("profilepic", event.profilePic);

    if (state is ProfileCoverLoaded) {
      emit(
        (state as ProfileCoverLoaded).copyWith(profilePic: event.profilePic),
      );
    } else {
      emit(ProfileCoverLoaded(profilePic: event.profilePic));
    }
  }

  Future<void> _onUpdateCoverPic(
    UpdateCoverPicEvent event,
    Emitter<ProfillecoverchangeState> emit,
  ) async {
    await SharedPrefUtils.saveStr("coverpic", event.coverPic);

    if (state is ProfileCoverLoaded) {
      emit((state as ProfileCoverLoaded).copyWith(coverPic: event.coverPic));
    } else {
      emit(ProfileCoverLoaded(coverPic: event.coverPic));
    }
  }
}
