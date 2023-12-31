import 'package:flutter/material.dart';
import 'package:restaurant_app/common/app_color.dart';
import 'package:restaurant_app/common/app_routes.dart';
import 'package:restaurant_app/data/utils/notification_helper.dart';
import 'package:restaurant_app/pages/bookmarks_page.dart';
import 'package:restaurant_app/pages/home_page.dart';
import 'package:restaurant_app/pages/search_page.dart';
import 'package:restaurant_app/pages/settings_page.dart';

class Navbar extends StatefulWidget {
  const Navbar({Key? key}) : super(key: key);

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _bottomNavIndex = 0;

  final NotificationHelper _notificationHelper = NotificationHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _listWidget[_bottomNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Theme.of(context).unselectedWidgetColor,
        selectedItemColor: AppColor.primary,
        currentIndex: _bottomNavIndex,
        items: _bottomNavBarItems,
        onTap: (selected) {
          setState(() {
            _bottomNavIndex = selected;
          });
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _notificationHelper.configureSelectNotificationSubject(AppRoute.details);
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }
}

List<BottomNavigationBarItem> _bottomNavBarItems = [
  const BottomNavigationBarItem(
    icon: Icon(Icons.home),
    label: "Home",
  ),
  const BottomNavigationBarItem(
    icon: Icon(Icons.search),
    label: "Search",
  ),
  const BottomNavigationBarItem(
    icon: Icon(Icons.bookmark),
    label: "Bookmarks",
  ),
  const BottomNavigationBarItem(
    icon: Icon(Icons.settings),
    label: "Setting",
  ),
];

final List<Widget> _listWidget = [
  const HomePage(),
  const SearchPage(),
  const BookmarksPage(),
  const SettingsPage(),
];
