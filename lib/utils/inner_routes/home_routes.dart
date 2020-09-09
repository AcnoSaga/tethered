import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:tethered/screens/home/home_page/home_page.dart';

class HomeRoutes {
  static const String detail = '/detail';
}

final homeRouteBuilder = {
  HomeRoutes.detail: GetPageRoute(page: () => Scaffold()),
};

final homeInitialRoute = GetPageRoute(
  page: () => HomePage(),
);
