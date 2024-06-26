import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:gaindesat_ddp_client/models/ExceptionMessage.dart';
import 'package:gaindesat_ddp_client/services/admin/partner_services.dart';
import 'package:gaindesat_ddp_client/services/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/partner.dart';
part 'partner_event.dart';
part 'partner_state.dart';

class PartnerBloc extends Bloc<PartnerEvent, PartnerManagementState> {
  late SharedPreferences prefs;
  late bool finishedOnBoarding;

  PartnerBloc() : super(const PartnerManagementState.onboarding()) {
    on<CheckFirstRunEvent>((event, emit) async {
      prefs = await SharedPreferences.getInstance();
      finishedOnBoarding = prefs.getBool(finishedOnBoardingConst) ?? false;
      if (!finishedOnBoarding) {
        emit(const PartnerManagementState.onboarding());
      }
    });

    on<ValidatePartnerFieldsEvent>((event, emit) {
      if (event.key.currentState?.validate() ?? false) {
        event.key.currentState!.save();
        emit(const PartnerManagementState.validPartnerFields());
      } else {
        emit(const PartnerManagementState.failureFillPartnerFields("fill required fields"));
      }
    });

    on<PartnerAddEvent>((event, emit) async {
      dynamic result = await PartnerService().create(event.partner);
      if (result != null && result is Partner) {
        emit(PartnerManagementState.addSuccess("Partner add successfully: ${result.uuid}"));
      } else if (result != null && result is ExceptionMessage){
        emit(PartnerManagementState.addError(result.message));
      } else {
        emit(PartnerManagementState.addError("Unknown Error"));
      }
    });

    on<PartnerUpdateEvent>((event, emit) async {
      dynamic result = await PartnerService().update(event.partner);
      if (result != null && result is Partner) {
        emit(PartnerManagementState.updateSuccess("Success"));
      } else {
        emit(PartnerManagementState.updateError("Error"));
      }
    });

    on<PartnerDeleteInitEvent>((event, emit) =>
      emit(const PartnerManagementState.deleteInit()));

    on<PartnerDeleteEvent>((event, emit) async {
      dynamic result = await PartnerService().delete(event.partnerUUID);
      if (result != null && result is CustomMessage) {
        emit(PartnerManagementState.deleteSuccess(result.message));
      } else if (result != null && result is ExceptionMessage){
        emit(PartnerManagementState.deleteError(result.message));
      } else {
        emit(PartnerManagementState.deleteError("Unknown Error"));
      }
    });
  }
}