part of 'locationtagfriends_bloc.dart';

sealed class LocationtagfriendsEvent extends Equatable {
  const LocationtagfriendsEvent();

  @override
  List<Object?> get props => [];
}

final class UpdateUserLocation extends LocationtagfriendsEvent {
  final String location;
  const UpdateUserLocation(this.location);

  @override
  List<Object?> get props => [location];
}

// 🔹 Changed from List<String> → List<Map<String, String>>
final class UpdateTargetFriends extends LocationtagfriendsEvent {
  final List<Map<String, String>> friends;
  const UpdateTargetFriends(this.friends);

  @override
  List<Object?> get props => [friends];
}

final class UpdatePrivacy extends LocationtagfriendsEvent {
  final String privacy;
  const UpdatePrivacy(this.privacy);

  @override
  List<Object?> get props => [privacy];
}
