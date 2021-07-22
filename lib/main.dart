import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:tethered/injection/injection.dart';
import 'package:tethered/theme/size_config.dart';
import 'package:tethered/utils/routes.dart';
import 'riverpod/home_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  configureInit();
  HttpOverrides.global = new MyHttpOverrides();
  runApp(ProviderScope(child: Riverpod_Home())); //changed the Homepage
}

class TetheredApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    return LayoutBuilder(builder: (context, constraints) {
      SizeConfig.init(constraints, Orientation.portrait);
      return FutureBuilder(
          future: Routes.getInitialRoute(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null) {
              return Container();
            }
            return GetMaterialApp(
              title: 'Tethered',
              getPages: Routes.getPages(),
              initialRoute: snapshot.data,
            );
          });
    });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
