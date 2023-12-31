import 'dart:developer';
import 'dart:ui';
import 'dart:isolate';

import 'package:restaurant_app/data/api/restaurant_services.dart';
import 'package:restaurant_app/data/models/restaurant_model.dart';
import 'package:restaurant_app/main.dart';

import 'notification_helper.dart';

final ReceivePort port = ReceivePort();

class BackgroundService {
  static BackgroundService? _instance;
  static const String _isolateName = 'isolate';
  static SendPort? _uiSendPort;

  BackgroundService._internal() {
    _instance = this;
  }

  factory BackgroundService() => _instance ?? BackgroundService._internal();

  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      _isolateName,
    );
  }

  static Future<void> callback() async {
    log('Alarm fired!');
    log('BackgroundService.callback called at ${DateTime.now()}');

    final NotificationHelper notificationHelper = NotificationHelper();

    // Fetch the list of restaurants
    var restaurantList = await RestaurantServices().getAllRestaurants();

    // Create a SearchResult object
    var result = SearchResult(
      error: false,
      founded: restaurantList.length,
      restaurants: restaurantList,
    );

    // Show the notification
    await notificationHelper.showNotification(
        flutterLocalNotificationsPlugin, result);

    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }
}
