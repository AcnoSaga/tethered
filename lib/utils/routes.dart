import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:tethered/screens/auth/login/login_screen.dart';
import 'package:tethered/screens/auth/signup/signup_screen.dart';
import 'package:tethered/screens/home/home_page.dart';
import 'package:tethered/screens/welcome_screen.dart';

class Routes {
  static List<GetPage> getPages() {
    return [
      GetPage(
        name: '/',
        page: () => WelcomeScreen(),
      ),
      GetPage(
        name: '/login',
        page: () => LoginScreen(),
        transition: Transition.fadeIn,
      ),
      GetPage(
        name: '/signup',
        page: () => SignupScreen(),
        curve: Curves.easeInCubic,
      ),
      GetPage(
        name: '/home',
        page: () => HomePage(),
      ),
    ];
  }

  static String getInitialRoute() {
    return '/';
  }
}
