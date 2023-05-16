part of 'login_bloc.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class ValidLoginFields extends LoginState {}

class LoginFailureState extends LoginState {
  late String errorMessage;

  LoginFailureState({required this.errorMessage});
}