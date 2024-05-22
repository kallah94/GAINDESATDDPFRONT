part of 'profile_bloc.dart';

enum ProfileState {
  editProfileDataSuccess, editProfileDataError, validProfileState,
  failureFillProfileState, firstRun
}

class ProfileManagementState {
  final ProfileState profileState;
  final String? message;

  const ProfileManagementState._(this.profileState, {this.message});

  const ProfileManagementState.onboarding(): this._(ProfileState.firstRun);

  const ProfileManagementState.validProfileFields(): this._(ProfileState.validProfileState);

  const ProfileManagementState.failureFillFields(String? message):
      this._(ProfileState.failureFillProfileState, message: message ?? "Please fill required fields");

  ProfileManagementState.editProfileSuccess(String? message):
      this._(ProfileState.editProfileDataSuccess, message: message ?? "Edited profile successfully");

  ProfileManagementState.editProfileError(String? message):
      this._(ProfileState.editProfileDataError, message: message ?? "Edited profile error");
}