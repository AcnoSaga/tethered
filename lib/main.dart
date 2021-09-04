import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:tethered/riverpods/global/app_busy_status_provider.dart';
import 'package:tethered/utils/colors.dart';
import 'injection/injection.dart';
import 'riverpods/global/user_provider.dart';
import 'theme/size_config.dart';
import 'utils/routes.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await Firebase.initializeApp();
  configureInit();
  HttpOverrides.global = new MyHttpOverrides();
  if (Platform.isAndroid) {
    try {
      final AppUpdateInfo appUpdateInfo = await InAppUpdate.checkForUpdate();
      if (appUpdateInfo.immediateUpdateAllowed) {
        await InAppUpdate.performImmediateUpdate();
      }
      ;
    } catch (e) {}
  }
  runApp(ProviderScope(child: TetheredApp()));
}

class TetheredApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final isAppBusyNotifier = watch(appBusyStatusProvider.notifier);
    final isAppBusy = watch(appBusyStatusProvider);
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
              child: GlobalLoaderOverlay(
                overlayOpacity: 0.5,
                child: AbsorbPointer(
                  absorbing: isAppBusy,
                  child: AppWidget(
                    initialRoute: snapshot.data,
                    isAppBusyNotifier: isAppBusyNotifier,
                  ),
                ),
              ),
            );
          });
    });
  }
}

class AppWidget extends StatefulWidget {
  final String initialRoute;
  final AppBusyStatusNotifier isAppBusyNotifier;
  const AppWidget({
    Key key,
    this.initialRoute,
    this.isAppBusyNotifier,
  }) : super(key: key);

  @override
  _AppWidgetState createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  void initState() {
    super.initState();
    widget.isAppBusyNotifier.addListener((isAppBusy) {
      if (isAppBusy) {
        context.loaderOverlay.show();
      } else {
        context.loaderOverlay.hide();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Tethered',
      getPages: Routes.getPages(),
      initialRoute: widget.initialRoute,
    );
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
