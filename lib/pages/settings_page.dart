import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/common/app_color.dart';
import 'package:restaurant_app/common/app_fonts.dart';
import 'package:restaurant_app/data/provider/preferences_provider.dart';
import 'package:restaurant_app/data/provider/sceduling_provider.dart';
import 'package:restaurant_app/data/provider/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColor.secondary,
        centerTitle: true,
        elevation: 0,
        title: Text(
          "Settings",
          style: whiteTextstyle,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _buildList(context),
    );
  }
}

Widget _buildList(BuildContext context) {
  final themeProvider = Provider.of<ThemeProvider>(context);
  final preferenceProvider = Provider.of<PreferencesProvider>(context);

  ///Theme toggle
  return ListView(
    children: [
      Material(
        child: ListTile(
          title: themeProvider.darkTheme
              ? const Text('Dark Theme')
              : const Text('Light Theme'),
          trailing: Switch.adaptive(
            value: themeProvider.darkTheme,
            onChanged: (value) {
              themeProvider.toggleTheme(); // Mengubah tema saat switch diubah
            },
          ),
        ),
      ),
      Material(
        child: ListTile(
          title: const Text('Scheduling News'),
          trailing: Consumer<SchedulingProvider>(
            builder: (context, scheduled, _) {
              return Switch.adaptive(
                value: preferenceProvider.isDailyNewsActive,
                onChanged: (value) {
                  scheduled.scheduledNews(value);
                  preferenceProvider.enableDailyNews(value);
                },
              );
            },
          ),
        ),
      ),
    ],
  );
}
