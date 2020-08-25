import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:tethered/cubits/auth_blocs/signup_bloc/signup_bloc.dart';
import 'package:tethered/injection/injection.dart';
import 'package:tethered/screens/components/gap.dart';
import 'package:tethered/screens/components/input_form_field.dart';
import 'package:tethered/screens/components/passive_text_button.dart';
import 'package:tethered/screens/components/proceed_button.dart';
import 'package:tethered/screens/components/validators/text_validators.dart';
import 'package:tethered/theme/size_config.dart';
import 'package:tethered/utils/colors.dart';
import 'package:tethered/utils/text_styles.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final PageController pageController = PageController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignupBloc>(
      create: (context) => locator<SignupBloc>(),
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: TetheredColors.primaryDark,
          body: BlocConsumer<SignupBloc, SignupState>(
            listener: (context, state) {
              if (state is SignupSuccess) {
                Get.offAllNamed('/home');
              }
            },
            builder: (context, state) {
              if (state is SignupLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return _mainScreen(context);
            },
          ),
        );
      }),
    );
  }

  Widget _mainScreen(BuildContext context) {
    return Form(
      key: _formKey,
      child: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  top: sy * 55,
                ),
                child: Column(
                  // mainAxisSize: MainAxisSize.max,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: sx * 4,
                        ),
                        child: Text(
                          'Sign Up',
                          style: TetheredTextStyles.authHeading,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: LimitedBox(
                        maxHeight: sy * 200,
                        child: PageView(
                          allowImplicitScrolling: false,
                          pageSnapping: true,
                          scrollDirection: Axis.horizontal,
                          physics: NeverScrollableScrollPhysics(),
                          controller: pageController,
                          children: [
                            _detailsColumn(),
                            _passwordColumn(context),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: sy * 5,
                left: sx * 2,
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: Get.back,
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: TetheredColors.passiveText,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailsColumn() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: sx * 5,
      ),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          Gap(height: 2),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Enter Details',
              style: TetheredTextStyles.authSubHeading,
            ),
          ),
          Gap(height: 2),
          InputFormField(
            hintText: 'Name',
            controller: nameController,
            validator: TextValidators.name,
          ),
          Gap(height: 2),
          InputFormField(
            hintText: 'Username',
            controller: usernameController,
            validator: TextValidators.name,
          ),
          Gap(height: 2),
          InputFormField(
            hintText: 'Email',
            controller: emailController,
            validator: TextValidators.email,
          ),
          Gap(height: 3),
          ProceedButton(
            text: 'Next',
            onPressed: () async {
              final nameInvalidation = TextValidators.name(nameController.text);
              final usernameInvalidation =
                  TextValidators.name(usernameController.text);
              final emailInvalidation =
                  TextValidators.email(emailController.text);
              if (nameInvalidation != null ||
                  emailInvalidation != null ||
                  usernameInvalidation != null) {
                _formKey.currentState.validate();
              } else {
                await pageController.animateToPage(
                  1,
                  duration: Duration(milliseconds: 1500),
                  curve: Curves.easeInOutBack,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _passwordColumn(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: sx * 5,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Gap(height: 2),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Create a password',
              style: TetheredTextStyles.authSubHeading,
            ),
          ),
          Gap(height: 2),
          InputFormField(
            hintText: 'Password',
            controller: passwordController,
            validator: TextValidators.password,
            isObscure: true,
          ),
          Gap(height: 2),
          InputFormField(
              hintText: 'Confirm Password',
              controller: confirmPasswordController,
              isObscure: true,
              validator: (passwordToBeConfirmed) {
                if (passwordToBeConfirmed != passwordController.text) {
                  return 'Passwords do not match';
                }
                return TextValidators.password(passwordToBeConfirmed);
              }),
          Gap(height: 3),
          ProceedButton(
            text: 'Sign Up',
            onPressed: () {
              if (_formKey.currentState.validate()) {
                BlocProvider.of<SignupBloc>(context).add(Signup(
                  name: nameController.text,
                  username: usernameController.text,
                  email: emailController.text,
                  password: passwordController.text,
                ));
                _clearFields();
              }
            },
          ),
          Gap(height: 3),
          PassiveTextButton(
            text: 'Back',
            onPressed: () async {
              await pageController.animateToPage(
                0,
                duration: Duration(milliseconds: 1500),
                curve: Curves.easeInOutBack,
              );
            },
          ),
        ],
      ),
    );
  }

  void _clearFields() {
    nameController.clear();
    usernameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }
}
