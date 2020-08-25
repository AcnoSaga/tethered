part of 'signup_bloc.dart';

@immutable
abstract class SignupEvent {}

class Signup extends SignupEvent {
  final String name;
  final String username;
  final String email;
  final String password;

  Signup({
    @required this.name,
    @required this.username,
    @required this.email,
    @required this.password,
  });
}
