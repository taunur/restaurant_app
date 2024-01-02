import 'dart:io';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/app_routes.dart';
import 'package:restaurant_app/data/api/connection_services.dart';
import 'package:restaurant_app/data/api/restaurant_services.dart';
import 'package:restaurant_app/data/db/db_resto_helper.dart';
import 'package:restaurant_app/data/provider/db_resto_provider.dart';
import 'package:restaurant_app/data/provider/details_provider.dart';
import 'package:restaurant_app/data/provider/preferences_provider.dart';
import 'package:restaurant_app/data/provider/restaurant_provider.dart';
import 'package:restaurant_app/data/provider/sceduling_provider.dart';
import 'package:restaurant_app/data/provider/theme_provider.dart';
import 'package:restaurant_app/data/utils/app_constants.dart';
import 'package:restaurant_app/data/utils/background_service.dart';
import 'package:restaurant_app/data/utils/notification_helper.dart';
import 'package:restaurant_app/data/utils/preferences_helper.dart';
import 'package:restaurant_app/pages/bookmarks_page.dart';
import 'package:restaurant_app/pages/home_page.dart';
import 'package:restaurant_app/pages/navbar.dart';
import 'package:restaurant_app/pages/search_page.dart';
import 'package:restaurant_app/pages/splash_page.dart';
import 'package:restaurant_app/theme/dark_theme.dart';
import 'package:restaurant_app/theme/light_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'pages/details_page.dart';
import 'package:http/http.dart' as http;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestPermission();

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  RestaurantServices restaurantServices = RestaurantServices(http.Client());
  ConnectionServices connectionServices = ConnectionServices();

  final NotificationHelper notificationHelper = NotificationHelper();
  final BackgroundService service = BackgroundService();

  service.initializeIsolate();

  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(
            sharedPreferences: sharedPreferences,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => RestaurantProvider(
            restaurantServices: restaurantServices,
            connectionServices: connectionServices,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => DetailRestoProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PreferencesProvider(
            preferencesHelper: PreferencesHelper(
              sharedPreferences: Future.value(sharedPreferences),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => SchedulingProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DatabaseRestoProvider(
            databaseHelper: DatabaseRestoHelper(),
            connectionServices: connectionServices,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: Provider.of<ThemeProvider>(context).darkTheme
            ? darkTheme
            : lightTheme,
        routes: {
          AppRoute.splash: (context) => const SplashPage(),
          AppRoute.navbar: (context) => const Navbar(),
          AppRoute.home: (context) => const HomePage(),
          AppRoute.search: (context) => const SearchPage(),
          AppRoute.details: (context) => const DetailsPage(),
          AppRoute.bookmarks: (context) => const BookmarksPage(),
        },
        navigatorKey: Navigation.navigatorKey,
        initialRoute: AppRoute.home,
        builder: (context, child) {
          return StreamBuilder<ConnectivityResult>(
            stream: Connectivity().onConnectivityChanged,
            builder: (context, snapshot) {
              final connectivityResult = snapshot.data;
              if (connectivityResult == ConnectivityResult.none) {
                /// No internet connection
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No internet connection'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                });
              }
              return child!;
            },
          );
        });
  }
}
