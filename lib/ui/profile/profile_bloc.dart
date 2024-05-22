import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:gaindesat_ddp_client/models/user.dart';
import 'package:gaindesat_ddp_client/services/common/profile_service.dart';
import 'package:gaindesat_ddp_client/services/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileManagementState> {
  late SharedPreferences prefs;
  late bool finishedOnBoarding;

  ProfileBloc(): super(const ProfileManagementState.onboarding()) {
    on<CheckFirstRunEvent>((event, emit) async {
      prefs = await SharedPreferences.getInstance();
      finishedOnBoarding = prefs.getBool(finishedOnBoardingConst) ?? false;
      if (!finishedOnBoarding) {
        emit(const ProfileManagementState.onboarding());
      }
    });
    on<ValidateProfileFieldsEvent>((event, emit) {
      if (event.key.currentState?.validate() ?? false) {
        event.key.currentState!.save();
        emit(const ProfileManagementState.validProfileFields());
      } else {
        emit(const ProfileManagementState.failureFillFields("Fill required fields"));
      }
    });
    on<ProfileEditEvent>((event, emit) async {
      dynamic result = await ProfileService().update(event.user);
    });
  }
}