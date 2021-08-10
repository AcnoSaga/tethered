import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/colors.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer(Duration(seconds: 2), () {
      Get.offAllNamed('/login');
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: TetheredColors.primaryDark,
      child: Center(
        child: Image.asset('assets/images/TetheredLogo.png'),
      ),
    ));
  }
}
