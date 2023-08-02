part of 'user_bloc.dart';

enum UserState {
  firstRun, validUserFields,
  failureFillUserFields,
  addSuccess, addError,
  updateSuccess, updateError,
  deleteInit, deleteError, deleteSuccess
}

class UserManagementState {
  final UserState userState;
  final String? message;

  const UserManagementState._(this.userState, {this.message});

  const UserManagementState.onboarding(): this._(UserState.firstRun);

  const UserManagementState.deleteInit(): this._(UserState.deleteInit);

  const UserManagementState.validUserFields(): this._(UserState.validUserFields);

  const UserManagementState.failureFillUserFields(String? message)
      : this._(UserState.failureFillUserFields, message: message ?? "Please fill required fields");

 UserManagementState.addSuccess(String? message)
      : this._(UserState.addSuccess, message: message ?? "Add Success");

 UserManagementState.addError(String? message)
      : this._(UserState.addError, message: message ?? "Add Error");

  const UserManagementState.updateSuccess(String? message)
      : this._(UserState.updateSuccess, message: message ?? "Update Success");

  const UserManagementState.updateError(String? message)
      : this._(UserState.updateError, message: message ?? "Update Error");

  UserManagementState.deleteSuccess(String? message)
      : this._(UserState.deleteSuccess, message: message ?? "Delete Success");

  UserManagementState.deleteError(String? message)
      : this._(UserState.deleteError, message: message ?? "Delete Error");
}