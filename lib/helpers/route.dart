import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:template/views/screens/auth/splash.dart';

class AppRoutes {
  static String splash = "/splash";
  static String app = "/app";

  static Map<String, Widget> routeWidgets = {};

  static List<GetPage> pages = [
    GetPage(
      name: splash,
      page: () => Splash(),
    ),
    GetPage(
      name: app,
      page: () => Container(),
    )
    ];
}
