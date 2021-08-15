import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import '../../../services/authetication_service.dart';

part 'signup_event.dart';
part 'signup_state.dart';

@injectable
class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthenticationService authenticationService;
  SignupBloc(this.authenticationService) : super(SignupInitial());

  @override
  Stream<SignupState> mapEventToState(
    SignupEvent event,
  ) async* {
    if (event is Signup) {
      yield SignupLoading();
      final isUserSignedUpOrError =
          await authenticationService.signUpWithEmailAndPassword(
              event.email, event.password, event.name, event.username);
      if (isUserSignedUpOrError is String) {
        Get.snackbar(
          'Signup failed',
          isUserSignedUpOrError,
          colorText: Colors.white,
        );
        yield SignupFailure();
      } else {
        if (isUserSignedUpOrError as bool) {
          await authenticationService.sendEmailForVerificationToCurrentUser();
          await authenticationService.signOutUser();
          yield SignupSuccess();
        } else {
          Get.snackbar('Login failed', 'The user could not be logged in');
          yield SignupFailure();
        }
      }
    }
  }
}
