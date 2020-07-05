import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:tethered/injection/injection.dart';
import 'package:tethered/utils/routes.dart';

void main() {
  configureInit();
  runApp(TetheredApp());
}

class TetheredApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Tethered',
      getPages: Routes.getPages(),
      initialRoute: Routes.getInitialRoute(),
    );
  }
}
