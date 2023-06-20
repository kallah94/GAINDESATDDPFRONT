import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:gaindesat_ddp_client/services/admin/partner_services.dart';

import '../../../models/partner.dart';

part 'partner_event.dart';
part 'partner_state.dart';

class PartnerBloc extends Bloc<PartnerEvent, PartnerState> {

  PartnerBloc(): super(PartnerFormInitial()) {
    on<ValidatePartnerFieldsEvent>((event, emit) {
      if (event.key.currentState?.validate() ?? false) {
        event.key.currentState!.save();
        emit(ValidPartnerFields());
      } else {
        emit(PartnerFailureState(errorMessage: "Please fill required fields!"));
      }
    });

    on<PartnerAddOrUpdateEvent>((event, emit) async {
      dynamic result = await PartnerService().create(event.partner);
      if (result != null && result is Partner) {

      } else {

      }
    });
  }
}