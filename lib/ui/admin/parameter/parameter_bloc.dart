import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:gaindesat_ddp_client/models/ExceptionMessage.dart';
import 'package:gaindesat_ddp_client/services/admin/parameter_services.dart';
import 'package:gaindesat_ddp_client/services/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/parameter.dart';
part 'parameter_event.dart';
part 'parameter_state.dart';

class ParameterBloc extends Bloc<ParameterEvent, ParameterManagementState> {
  late SharedPreferences prefs;
  late bool finishedOnBoarding;

  ParameterBloc() : super(const ParameterManagementState.onboarding()) {
    on<CheckFirstRunEvent>((event, emit) async {
      prefs = await SharedPreferences.getInstance();
      finishedOnBoarding = prefs.getBool(finishedOnBoardingConst) ?? false;
      if (!finishedOnBoarding) {
        emit(const ParameterManagementState.onboarding());
      }
    });

    on<ValidateParameterFieldsEvent>((event, emit) {
      if (event.key.currentState?.validate() ?? false) {
        event.key.currentState!.save();
        emit(const ParameterManagementState.validParameterFields());
      } else {
        emit(const ParameterManagementState.failureFillParameterFields("Fill required fields"));
      }
    });

    on<ParameterAddEvent>((event, emit) async {
      dynamic result = await ParameterService().create(event.parameter);
      if (result != null && result is Parameter) {
        emit(ParameterManagementState.addSuccess("Parameter added successfully: ${result.uuid}"));
      } else if (result != null && result is ExceptionMessage){
        emit(ParameterManagementState.addError(result.message));
      } else {
        emit(ParameterManagementState.addError("Unknown Error"));
      }
    });

    on<ParameterUpdateEvent>((event, emit) async {
      dynamic result = await ParameterService().update(event.parameter);
      if (result != null && result is Parameter) {
        emit(ParameterManagementState.updateSuccess("Success"));
      } else {
        emit(ParameterManagementState.updateError("Error"));
      }
    });

    on<ParameterDeleteInitEvent>((event, emit) =>
        emit(const ParameterManagementState.deleteInit()));

    on<ParameterDeleteEvent>((event, emit) async {
      dynamic result = await ParameterService().delete(event.parameterUUID);
      if (result != null && result is CustomMessage) {
        emit(ParameterManagementState.deleteSuccess(result.message));
      } else if (result != null && result is ExceptionMessage){
        emit(ParameterManagementState.deleteError(result.message));
      } else {
        emit(ParameterManagementState.deleteError("Unknown Error"));
      }
    });
  }
}
