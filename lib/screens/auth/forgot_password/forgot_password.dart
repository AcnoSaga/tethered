import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/route_manager.dart';
import 'package:tethered/cubits/auth_blocs/login_bloc/login_bloc.dart';
import 'package:tethered/screens/components/gap.dart';
import 'package:tethered/screens/components/input_form_field.dart';
import 'package:tethered/screens/components/passive_text_button.dart';
import 'package:tethered/screens/components/proceed_button.dart';
import 'package:tethered/screens/components/validators/text_validators.dart';
import 'package:tethered/theme/size_config.dart';
import 'package:tethered/utils/colors.dart';
import 'package:tethered/utils/text_styles.dart';

class ForgotPassword extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TetheredColors.primaryDark,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: sx * 5,
                vertical: sy * 60,
              ),
              child: Column(
                children: [
                  Text(
                    'Forgot Password',
                    style: TetheredTextStyles.authHeading,
                  ),
                  Gap(height: 3),
                  InputFormField(
                    hintText: 'Email',
                    validator: TextValidators.email,
                    controller: controller,
                  ),
                  Gap(height: 5),
                  ProceedButton(
                    text: 'Confirm',
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        BlocProvider.of<LoginBloc>(context).add(
                          SendEmailToResetPassword(email: controller.text),
                        );
                        controller.clear();
                        Get.back();
                      }
                    },
                  ),
                  Gap(height: 20),
                  PassiveTextButton(
                    text: 'Back',
                    onPressed: Get.back,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
