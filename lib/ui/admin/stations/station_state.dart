part of 'station_bloc.dart';

enum StationState {
  firstRun, validStationFields,
  failureFillStationFields,
  addSuccess, addError,
  updateSuccess, updateError,
  deleteInit, deleteSuccess, deleteError
}

class StationManagementState {
  final StationState stationState;
  final String? message;

  const StationManagementState._(this.stationState, {this.message});

  const StationManagementState.onboarding(): this._(StationState.firstRun);

  const StationManagementState.deleteInit(): this._(StationState.deleteInit);

  const StationManagementState.validStationFields(): this._(StationState.validStationFields);

  const StationManagementState.failureFillStationFields(String? message):
      this._(StationState.failureFillStationFields, message: message ?? "Please fill required fields");

  StationManagementState.addSuccess(String? message):
      this._(StationState.addSuccess, message: message ?? "Add a station successfully");

  StationManagementState.addError(String? message):
      this._(StationState.addError, message: message ?? "Error occur");

  StationManagementState.updateSuccess(String? message):
      this._(StationState.updateSuccess, message: message ?? "Update done");

  StationManagementState.updateError(String? message)
  : this._(StationState.updateError, message: message ?? "Update Error");

  StationManagementState.deleteSuccess(String? message):
      this._(StationState.deleteSuccess, message: message ?? "Delete success");

  StationManagementState.deleteError(String? message)
  : this._(StationState.deleteError, message: message ?? "delete error");

}