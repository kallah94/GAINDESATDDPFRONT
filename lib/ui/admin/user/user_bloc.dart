import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/full_user.dart';
import '../../../services/admin/user_services.dart';
import '../../../services/globals.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserManagementState> {
  late SharedPreferences prefs;
  late bool finishedOnBoarding;

  UserBloc(): super(const UserManagementState.onboarding()) {
    on<CheckFirstRunEvent>((event, emit) async {
      prefs = await SharedPreferences.getInstance();
      finishedOnBoarding = prefs.getBool(finishedOnBoardingConst) ?? false;
      if (!finishedOnBoarding) {
        emit(const UserManagementState.onboarding());
      }
    });

    on<ValidateUserFieldsEvent>((event, emit) {
      if (event.key.currentState?.validate() ?? false) {
        event.key.currentState!.save();
        emit(const UserManagementState.validUserFields());
      } else {
        emit(const UserManagementState.failureFillUserFields("fill required fields"));
      }
    });

    on<UserAddEvent>((event, emit) async {
      dynamic result = await UserService().create(event.fullUser);
      if (result != null && result is FullUser) {
        emit(const UserManagementState.addSuccess("Success"));
      } else {
        emit(const UserManagementState.addError("Error"));
      }
    });

    on<UserUpdateEvent>((event, emit) async {
      dynamic result = await UserService().update(event.fullUser);
      if (result != null && result is FullUser) {
        emit(const UserManagementState.updateSuccess("Success"));
      } else {
        emit(const UserManagementState.updateError("Error"));
      }
    });

    on<UserDeleteInitEvent>((event, emit) =>
        emit(const UserManagementState.deleteInit()));

    on<UserDeleteEvent>((event, emit) async {
      dynamic result = await UserService().delete(event.fullUserUUID);
      if (result != null && result is FullUser) {
        emit(const UserManagementState.deleteSuccess("Success"));
      } else {
        emit(const UserManagementState.deleteError("Error"));
      }
    });
  }
}