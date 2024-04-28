part of 'sensor_bloc.dart';

enum SensorState {
  firstRun, validSensorFields,
  failureFillSensorFields,
  addSuccess, addError,
  updateSuccess, updateError,
  deleteInit, deleteSuccess, deleteError
}

class SensorManagementState {
  final SensorState sensorState;
  final String? message;

  const SensorManagementState._(this.sensorState, {this.message});

  const SensorManagementState.onboarding(): this._(SensorState.firstRun);

  const SensorManagementState.deleteInit(): this._(SensorState.deleteInit);

  const SensorManagementState.validSensorFields(): this._(SensorState.validSensorFields);

  const SensorManagementState.failureFillSensorFields(String? message)
    : this._(SensorState.failureFillSensorFields, message: message ?? "Please fill required fields");

  SensorManagementState.addSuccess(String? message)
    : this._(SensorState.addSuccess, message: message ?? "Add success");

  SensorManagementState.addError(String? message)
      : this._(SensorState.addError, message: message ?? "Add error");

  SensorManagementState.updateSuccess(String? message)
      : this._(SensorState.updateSuccess, message: message ?? "Update success");

  SensorManagementState.updateError(String? message)
      : this._(SensorState.updateError, message: message ?? "Update error");

  SensorManagementState.deleteSuccess(String? message)
      : this._(SensorState.deleteSuccess, message: message ?? "Delete success");

  SensorManagementState.deleteError(String? message)
      : this._(SensorState.deleteError, message: message ?? "Delete error");

}