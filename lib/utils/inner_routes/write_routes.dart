import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:tethered/screens/home/home_page/demo_page.dart';

class WriteRoutes {
  static const String detail = '/detail';
}

final writeRouteBuilder = {
  WriteRoutes.detail: (args) => GetPageRoute(page: () => Scaffold()),
};

final writeInitialRoute = (args) => GetPageRoute(
      page: () => DemoPage(),
    );
