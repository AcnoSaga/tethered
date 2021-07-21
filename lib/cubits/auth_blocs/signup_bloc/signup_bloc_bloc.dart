import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'signup_bloc_event.dart';
part 'signup_bloc_state.dart';

class SignupBlocBloc extends Bloc<SignupBlocEvent, SignupBlocState> {
  SignupBlocBloc() : super(SignupBlocInitial());

  @override
  Stream<SignupBlocState> mapEventToState(
    SignupBlocEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
