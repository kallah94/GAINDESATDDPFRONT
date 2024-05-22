part of 'parameter_bloc.dart';

enum ParameterState {
  firstRun, validParameterFields,
  failureFillParameterFields,
  addSuccess, addError,
  updateSuccess, updateError,
  deleteInit, deleteError, deleteSuccess
}

class ParameterManagementState {
  final ParameterState parameterState;
  final String? message;

  const ParameterManagementState._(this.parameterState, {this.message});

  const ParameterManagementState.onboarding(): this._(ParameterState.firstRun);

  const ParameterManagementState.deleteInit(): this._(ParameterState.deleteInit);

  const ParameterManagementState.validParameterFields(): this._(ParameterState.validParameterFields);

  const ParameterManagementState.failureFillParameterFields(String? message)
      : this._(ParameterState.failureFillParameterFields, message: message ?? "Please fill required fields");

  ParameterManagementState.addSuccess(String? message)
      : this._(ParameterState.addSuccess, message: message ?? "Add Success");

  ParameterManagementState.addError(String? message)
      : this._(ParameterState.addError, message: message ?? "Add Error");

  ParameterManagementState.updateSuccess(String? message)
      : this._(ParameterState.updateSuccess, message: message ?? "Update Success");

  ParameterManagementState.updateError(String? message)
      : this._(ParameterState.updateError, message: message ?? "Update Error");

  ParameterManagementState.deleteSuccess(String? message)
      : this._(ParameterState.deleteSuccess, message: message ?? "Delete Success");

  ParameterManagementState.deleteError(String? message)
      : this._(ParameterState.deleteError, message: message ?? "Delete Error");
}
