import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import '../../../services/authetication_service.dart';

part 'login_event.dart';
part 'login_state.dart';

@injectable
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthenticationService authenticationService;
  LoginBloc(this.authenticationService) : super(LoginInitial());

  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is Login) {
      yield LoginLoading();
      final isUserLoggedInOrError = await authenticationService
          .loginWithEmailAndPassword(event.email, event.password);
      if (isUserLoggedInOrError is String) {
        Get.snackbar(
          'Login failed',
          isUserLoggedInOrError,
          colorText: Colors.white,
        );
        yield LoginFailure();
      } else {
        if (isUserLoggedInOrError as bool) {
          if (!authenticationService.isUserVerified()) {
            print('Unverified');
            await authenticationService.sendEmailForVerificationToCurrentUser();
            Get.snackbar(
              'User not verified',
              'We have sent you a verification link on your email for verification.',
              instantInit: false,
              duration: Duration(seconds: 4),
              colorText: Colors.white,
            );
            await authenticationService.signOutUser();
            yield LoginInitial();
          } else {
            yield LoginSuccess();
          }
        } else {
          Get.snackbar('Login failed', 'The user could not be logged in');
          yield LoginFailure();
        }
      }
    } else if (event is SendEmailToResetPassword) {
      final didSendEmail =
          await authenticationService.sendPasswordResetEmail(event.email) ??
              false;
      if (didSendEmail) {
        Get.snackbar(
          'Email Sent',
          'Reset password email has been sent to ${event.email}',
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Failed to send email',
          'Reset password email could not be sent to ${event.email}\nPlease try again later',
          colorText: Colors.white,
        );
      }
    }
  }
}
