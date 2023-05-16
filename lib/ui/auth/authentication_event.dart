part of 'authentication_bloc.dart';

abstract class AuthenticationEvent {}

class LoginWithUsernameAndPasswordEvent extends AuthenticationEvent {
  String username;
  String password;

  LoginWithUsernameAndPasswordEvent({
    required this.username,
    required this.password
  });
}

class LogoutEvent extends AuthenticationEvent {
  LogoutEvent();
}

class FinishedOnBoardingEvent extends AuthenticationEvent {}

class CheckFirstRunEvent extends AuthenticationEvent {}