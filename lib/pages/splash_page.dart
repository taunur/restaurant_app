import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restaurant_app/common/app_assets.dart';
import 'package:restaurant_app/common/app_color.dart';
import 'package:restaurant_app/common/app_fonts.dart';
import 'package:restaurant_app/common/app_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    /// time auto navigator
    Timer(
      const Duration(seconds: 3),
      () {
        Navigator.pushReplacementNamed(context, AppRoute.navbar);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColor.primary,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 300,
                  width: 300,
                  margin: EdgeInsets.only(bottom: screenHeight * 0.01),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AppAsset.logow),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: screenHeight * 0.1),
                  child: Text(
                    'RestoApp',
                    style: whiteTextstyle.copyWith(
                      fontSize: 32,
                      fontWeight: medium,
                      letterSpacing: 7,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
