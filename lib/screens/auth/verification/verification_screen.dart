import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import '../../../theme/size_config.dart';
import '../../../utils/colors.dart';
import '../../../utils/text_styles.dart';
import '../../components/gap.dart';
import '../../components/passive_text_button.dart';

class VerificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TetheredColors.primaryDark,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: sx * 5,
              vertical: sy * 60,
            ),
            child: Column(
              children: [
                Text(
                  'Verify Your Account',
                  style: TetheredTextStyles.authHeading,
                ),
                Gap(height: 3),
                Text('Please check your email.\nLogin after verification.',
                    style: TetheredTextStyles.authSubHeading),
                Gap(height: 25),
                PassiveTextButton(
                  text: 'Back',
                  onPressed: Get.back,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
