part of 'authentication_bloc.dart';

enum AuthState {firstRun, authenticated, unauthenticated, isAdmin}

class AuthenticationState {
  final AuthState authState;
  final UserDetails? userDetails;
  final String? message;

  const AuthenticationState._(this.authState, {this.userDetails, this.message});

  const AuthenticationState.authenticated(UserDetails userDetails)
      : this._(AuthState.authenticated, userDetails: userDetails);

  const AuthenticationState.unauthenticated({String? message})
      : this._(AuthState.unauthenticated, message: message ?? 'Unauthenticated');

  const AuthenticationState.onboarding(): this._(AuthState.firstRun);

  const AuthenticationState.authenticatedAdmin(UserDetails userDetails)
      : this._(AuthState.isAdmin, userDetails: userDetails);
}