import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
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
        emit(const PartnerManagementState.addSuccess("Success"));
      } else {
        emit(const PartnerManagementState.addError("Error"));
      }
    });

    on<PartnerUpdateEvent>((event, emit) async {
      dynamic result = await PartnerService().updatePartner(event.partner);
      if (result != null && result is Partner) {
        emit(const PartnerManagementState.updateSuccess("Success"));
      } else {
        emit(const PartnerManagementState.updateError("Error"));
      }
    });

    on<PartnerDeleteInitEvent>((event, emit) =>
      emit(const PartnerManagementState.deleteInit()));

    on<PartnerDeleteEvent>((event, emit) async {
      dynamic result = await PartnerService().deletePartner(event.partnerUUID);
      if (result != null && result is Partner) {
        emit(const PartnerManagementState.deleteSuccess("Success"));
      } else {
        emit(const PartnerManagementState.deleteError("Error"));
      }
    });
  }
}