part of 'partner_bloc.dart';

enum PartnerState {
  firstRun, validPartnerFields,
  failureFillPartnerFields,
  addSuccess, addError,
  updateSuccess, updateError,
  deleteInit, deleteError, deleteSuccess
}


class PartnerManagementState {
  final PartnerState partnerState;
  final String? message;

  const PartnerManagementState._(this.partnerState, {this.message});

  const PartnerManagementState.onboarding(): this._(PartnerState.firstRun);

  const PartnerManagementState.deleteInit(): this._(PartnerState.deleteInit);

  const PartnerManagementState.validPartnerFields(): this._(PartnerState.validPartnerFields);

  const PartnerManagementState.failureFillPartnerFields(String? message)
      : this._(PartnerState.failureFillPartnerFields, message: message ?? "Please fill required fields");

  PartnerManagementState.addSuccess(String? message)
      : this._(PartnerState.addSuccess, message: message ?? "Add Success");

  PartnerManagementState.addError(String? message)
      : this._(PartnerState.addError, message: message ?? "Add Error");

  const PartnerManagementState.updateSuccess(String? message)
      : this._(PartnerState.updateSuccess, message: message ?? "Update Success");

  const PartnerManagementState.updateError(String? message)
      : this._(PartnerState.updateError, message: message ?? "Update Error");

  PartnerManagementState.deleteSuccess(String? message)
  : this._(PartnerState.deleteSuccess, message: message ?? "Delete Success");

  PartnerManagementState.deleteError(String? message)
      : this._(PartnerState.deleteError, message: message ?? "Delete Error");
}