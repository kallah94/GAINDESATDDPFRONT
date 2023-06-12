
import 'package:bloc/bloc.dart';
import 'package:gaindesat_ddp_client/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user_detail.dart';
import '../../services/globals.dart';

part 'authentication_event.dart';

part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  UserDetails? userDetails;
  late SharedPreferences prefs;
  late bool finishedOnBoarding;

  AuthenticationBloc({this.userDetails})
      : super(const AuthenticationState.unauthenticated()) {
    on<CheckFirstRunEvent>((event, emit) async {
      prefs = await SharedPreferences.getInstance();
      finishedOnBoarding = prefs.getBool(finishedOnBoardingConst) ?? false;
      if (!finishedOnBoarding) {
        emit(const AuthenticationState.onboarding());
      } else {
        userDetails = prefs.getString(userDetailsKey) as UserDetails?;
        if (userDetails == null) {
          emit(const AuthenticationState.unauthenticated());
        } else if (userDetails?.roles?.contains('ROLE_ADMIN') == true) {
          emit(AuthenticationState.authenticatedAdmin(userDetails!));
        } else {
          emit(AuthenticationState.authenticated(userDetails!));
        }
      }
    });
    on<FinishedOnBoardingEvent>((event, emit) async {
      await prefs.setBool(finishedOnBoardingConst, true);
      emit(const AuthenticationState.unauthenticated());
    });
    on<LoginWithUsernameAndPasswordEvent>((event, emit) async {
      dynamic result = await ApiAuth().login(event.username, event.password);
      if (result != null && result is UserDetails) {
        userDetails = result;
        if (userDetails?.roles?.contains('ROLE_ADMIN') == true) {
          emit(AuthenticationState.authenticatedAdmin(userDetails!));
        } else {
          emit(AuthenticationState.authenticated(userDetails!));
        }
      } else if (result !=null && result is String) {
        emit(AuthenticationState.unauthenticated(message: result));
      } else {
        emit(const AuthenticationState.unauthenticated(
          message: 'Login failed, Please try again!'
        ));
      }
    });
    on<LogoutEvent>((event, emit) {
      userDetails = null;
      emit(const AuthenticationState.unauthenticated());
    });
  }
}