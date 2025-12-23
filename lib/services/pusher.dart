import 'dart:async';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class PusherService {
  static final PusherService instance = PusherService._internal();
  PusherService._internal();

  factory PusherService() => instance;

  final PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

  // Global stream for all raw events
  final StreamController<PusherEvent> eventStreamController =
      StreamController<PusherEvent>.broadcast();
  Stream<PusherEvent> get events => eventStreamController.stream;

  // New stream specifically for notification count integer
  final StreamController<int> _notificationCountController =
      StreamController<int>.broadcast();
  Stream<int> get notificationCountStream =>
      _notificationCountController.stream;

  Future<void> initPusher({required userId}) async {
    try {
      await pusher.init(
        apiKey: "66cf9090a6cb939636ce",
        cluster: "ap2",
        onConnectionStateChange: onConnectionStateChange,
        onError: onError,
        onSubscriptionSucceeded: onSubscriptionSucceeded,
        onEvent: onEvent,
      );

      await pusher.connect();
      print("Pusher connected!");

      String channelName = 'notify-user-$userId'; // user-specific channel

      await pusher.subscribe(channelName: channelName);
      print("Subscribed to $channelName");
    } catch (e) {
      print("Pusher exception: $e");
    }
  }

  void onConnectionStateChange(String previousState, String currentState) {
    print("Pusher state: $previousState → $currentState");
  }

  void onError(String message, int? code, dynamic exception) {
    print("ERROR: $message | Code: $code | Exception: $exception");
  }

  void onSubscriptionSucceeded(String channelName, dynamic data) {
    print("Subscribed to: $channelName");
  }

  void onEvent(PusherEvent event) {
    print("Event Received: ${event.eventName} | ${event.data}");

    // Push event globally to app
    eventStreamController.add(event);

    // যদি notification-count-update ইভেন্ট হয়, count বের করে stream পাঠানো
    if (event.eventName == "notification-count") {
      try {
        final countRaw = event.data["count"];
        final count = int.tryParse(countRaw.toString()) ?? 0;
        _notificationCountController.add(count);
      } catch (e) {
        print("Error parsing count from event: $e");
      }
    }
  }

  void dispose() {
    eventStreamController.close();
    _notificationCountController.close();
    pusher.disconnect();
  }
}
