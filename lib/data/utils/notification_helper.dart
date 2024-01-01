import 'dart:developer' as developer;
import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant_app/common/app_routes.dart';
import 'package:restaurant_app/data/api/restaurant_services.dart';
import 'package:restaurant_app/data/models/restaurant_model.dart';
import 'package:rxdart/subjects.dart';
import 'package:http/http.dart' as http;

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  static NotificationHelper? _instance;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      if (payload != null) {
        developer.log('notification payload: $payload');
      }
      selectNotificationSubject.add(payload ?? 'empty payload');
    });
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      SearchResult result) async {
    var channelId = "1";
    var channelName = "taunur";
    var channelDescription = "daily restaurant channel";

    /// get restaurant List
    var restaurantList =
        await RestaurantServices(http.Client()).getAllRestaurants();

    /// get random breed item from list
    var randomIndex = Random().nextInt(restaurantList.length);
    var selectedRestaurant = restaurantList[randomIndex];

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      styleInformation: const DefaultStyleInformation(true, true),
    );

    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    var titleNotification = "<b>Recomended restaurant</b>";
    var titleRestaurant = selectedRestaurant.name;

    await flutterLocalNotificationsPlugin.show(
      1,
      titleNotification,
      titleRestaurant,
      platformChannelSpecifics,
      payload: selectedRestaurant.id,
    );
  }

  void configureSelectNotificationSubject(String route) {
    selectNotificationSubject.stream.listen(
      (String payload) async {
        developer.log('Navigating to route: $route');
        Navigation.intent(route, arguments: payload);
      },
    );
  }
}
