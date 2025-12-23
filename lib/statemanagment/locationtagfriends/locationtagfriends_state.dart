part of 'locationtagfriends_bloc.dart';

sealed class LocationtagfriendsState extends Equatable {
  const LocationtagfriendsState();

  @override
  List<Object?> get props => [];
}

final class LocationtagfriendsInitial extends LocationtagfriendsState {}

final class LocationtagfriendsLoaded extends LocationtagfriendsState {
  final String? userLocation;
  // 🔹 Changed from List<String> → List<Map<String, String>>
  final List<Map<String, String>> targetFriends;
  final String privacy;

  const LocationtagfriendsLoaded({
    this.userLocation,
    this.targetFriends = const [],
    this.privacy = "Public",
  });

  LocationtagfriendsLoaded copyWith({
    String? userLocation,
    List<Map<String, String>>? targetFriends,
    String? privacy,
  }) {
    return LocationtagfriendsLoaded(
      userLocation: userLocation ?? this.userLocation,
      targetFriends: targetFriends ?? this.targetFriends,
      privacy: privacy ?? this.privacy,
    );
  }

  @override
  List<Object?> get props => [userLocation, targetFriends, privacy];
}
