part of 'partner_bloc.dart';

abstract class PartnerState {}

class PartnerFormInitial extends PartnerState {}

class ValidPartnerFields extends PartnerState {}

class PartnerFailureState extends PartnerState {
  late String errorMessage;

  PartnerFailureState({required this.errorMessage});
}

class PartnerAddOrUpdateFailureState extends PartnerState {
  late String errorMessage;

  PartnerAddOrUpdateFailureState({required this.errorMessage});
}

class PartnerAddOrUpdateSuccessState extends PartnerState {
  late String successMessage;

  PartnerAddOrUpdateSuccessState({required this.successMessage});
}