part of 'collected-data_bloc.dart';

enum CollectedDataState {
  firstRun, validateCollectedDataDateFields,
  failureFillCollectedDataDateFields,
  requestCollectedDataSuccess, requestCollectedDataError,
  requestCollectedDataInit
}

class CollectedDataManagementState{
  final CollectedDataState collectedDataState;
  final String? message;

  const CollectedDataManagementState._(this.collectedDataState, {this.message});

  const CollectedDataManagementState.onboarding(): this._(CollectedDataState.firstRun);

  const CollectedDataManagementState.requestInit(): this._(CollectedDataState.requestCollectedDataInit);

  const CollectedDataManagementState.validDateFields(): this._(CollectedDataState.validateCollectedDataDateFields);

  CollectedDataManagementState.failureFillDateFields(String? message):
        this._(CollectedDataState.failureFillCollectedDataDateFields, message: message ?? "Please fill required fields");

  CollectedDataManagementState.requestCollectedDataSuccess(String? message):
      this._(CollectedDataState.requestCollectedDataSuccess, message: message ?? "Request Collected data successfully");

  CollectedDataManagementState.requestCollectedDataError(String? message):
      this._(CollectedDataState.requestCollectedDataError, message: message ?? "Request Collected data error");
}