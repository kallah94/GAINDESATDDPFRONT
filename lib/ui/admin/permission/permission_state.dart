part of 'permission_bloc.dart';

enum PermissionState {
  firstRun, validPermissionFields,
  failureFillPermissionFields,
  addSuccess, addError,
  updateSuccess, updateError,
  deleteInit, deleteError, deleteSuccess
}

class PermissionManagementState {
  final PermissionState permissionState;
  final String? message;

  const PermissionManagementState._(this.permissionState, {this.message});

  const PermissionManagementState.onboarding(): this._(PermissionState.firstRun);

  const PermissionManagementState.deleteInit(): this._(PermissionState.deleteInit);

  const PermissionManagementState.validPartnerFields(): this._(PermissionState.validPermissionFields);

  const PermissionManagementState.failureFillPartnerFields(String? message)
      : this._(PermissionState.failureFillPermissionFields, message: message ?? "Please fill required fields");

  PermissionManagementState.addSuccess(String? message)
      : this._(PermissionState.addSuccess, message: message ?? "Add Success");

  PermissionManagementState.addError(String? message)
      : this._(PermissionState.addError, message: message ?? "Add Error");

  const PermissionManagementState.updateSuccess(String? message)
      : this._(PermissionState.updateSuccess, message: message ?? "Update Success");

  const PermissionManagementState.updateError(String? message)
      : this._(PermissionState.updateError, message: message ?? "Update Error");

  PermissionManagementState.deleteSuccess(String? message)
      : this._(PermissionState.deleteSuccess, message: message ?? "Delete Success");

  PermissionManagementState.deleteError(String? message)
      : this._(PermissionState.deleteError, message: message ?? "Delete Error");
}