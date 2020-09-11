import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:tethered/cubits/auth_blocs/login_bloc/login_bloc.dart';
import 'package:tethered/injection/injection.dart';
import 'package:tethered/screens/components/gap.dart';
import 'package:tethered/screens/components/input_form_field.dart';
import 'package:tethered/screens/components/passive_text_button.dart';
import 'package:tethered/screens/components/proceed_button.dart';
import 'package:tethered/screens/components/validators/text_validators.dart';
import 'package:tethered/theme/size_config.dart';
import 'package:tethered/utils/colors.dart';
import 'package:tethered/utils/text_styles.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      create: (context) => locator<LoginBloc>(),
      child: Builder(builder: (context) {
        return BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              Get.offAllNamed('/home');
            }
          },
          child: Scaffold(
            backgroundColor: TetheredColors.primaryDark,
            resizeToAvoidBottomInset: true,
            body: BlocConsumer<LoginBloc, LoginState>(
              listener: (context, state) {
                if (state is LoginSuccess) {
                  Get.offAllNamed('/home');
                }
              },
              builder: (context, state) {
                if (state is LoginLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return _mainScreen(context);
              },
            ),
          ),
        );
      }),
    );
  }

  Widget _mainScreen(BuildContext context) {
    return Form(
      key: _formKey,
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: sx * 5,
              vertical: sy * 10,
            ),
            child: SingleChildScrollView(
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Gap(height: 15),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Login',
                      style: TetheredTextStyles.authHeading,
                    ),
                  ),
                  Gap(height: 4),
                  InputFormField(
                    hintText: 'Email',
                    controller: emailController,
                    validator: TextValidators.email,
                  ),
                  Gap(height: 2),
                  InputFormField(
                    hintText: 'Password',
                    isObscure: true,
                    controller: passwordController,
                    validator: TextValidators.password,
                  ),
                  Gap(height: 3),
                  ProceedButton(
                    text: 'Login',
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        BlocProvider.of<LoginBloc>(context).add(Login(
                          email: emailController.text,
                          password: passwordController.text,
                        ));
                        _clearFields();
                      }
                    },
                  ),
                  Gap(height: 3),
                  PassiveTextButton(
                    text: 'Forgot Password?',
                    onPressed: () => Get.toNamed('/forgot-password'),
                  ),
                  Gap(height: 15),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: PassiveTextButton(
                      text: 'Sign Up',
                      onPressed: () => Get.toNamed('/signup'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _clearFields() {
    emailController.clear();
    passwordController.clear();
  }
}
