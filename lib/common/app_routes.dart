import 'package:flutter/material.dart';

class AppRoute {
  static const splash = '/';
  static const navbar = '/navbar';
  static const home = '/home';
  static const search = '/search';
  static const details = '/details';
  static const bookmarks = '/bookmarks';
}

class Navigation {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static void intent(String routeName, {Object? arguments}) {
    navigatorKey.currentState?.pushNamed(routeName, arguments: arguments);
  }

  static void back() {
    navigatorKey.currentState?.pop();
  }
}
