import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'locationtagfriends_event.dart';
part 'locationtagfriends_state.dart';

class LocationtagfriendsBloc
    extends Bloc<LocationtagfriendsEvent, LocationtagfriendsState> {
  LocationtagfriendsBloc() : super(const LocationtagfriendsLoaded()) {
    on<UpdateUserLocation>((event, emit) {
      final currentState = state;
      if (currentState is LocationtagfriendsLoaded) {
        emit(currentState.copyWith(userLocation: event.location));
      }
    });

    on<UpdateTargetFriends>((event, emit) {
      final currentState = state;
      if (currentState is LocationtagfriendsLoaded) {
        emit(currentState.copyWith(targetFriends: event.friends));
      }
    });

    on<UpdatePrivacy>((event, emit) {
      final currentState = state;
      if (currentState is LocationtagfriendsLoaded) {
        emit(currentState.copyWith(privacy: event.privacy));
      }
    });
  }
}
