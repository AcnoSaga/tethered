import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tethered/utils/colors.dart';
import 'injection/injection.dart';
import 'riverpods/global/user_provider.dart';
import 'theme/size_config.dart';
import 'utils/routes.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await Firebase.initializeApp();
  configureInit();
  HttpOverrides.global = new MyHttpOverrides();
  runApp(ProviderScope(child: TetheredApp()));
}

class TetheredApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: TetheredColors.primaryDark,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    return LayoutBuilder(builder: (context, constraints) {
      SizeConfig.init(constraints, Orientation.portrait);
      FirebaseAuth.instance.authStateChanges().listen((user) async {
        final userStateNotifier = watch(userProvider.notifier);
        if (user == null) {
          userStateNotifier.reset();
          return;
        }
        userStateNotifier.getUserData(user.uid);
      });
      return FutureBuilder(
          future: Routes.getInitialRoute(),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null) {
              return Container();
            }
            return GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
                SystemChannels.textInput.invokeMethod('TextInput.hide');
              },
              child: GetMaterialApp(
                title: 'Tethered',
                getPages: Routes.getPages(),
                initialRoute: snapshot.data,
              ),
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
