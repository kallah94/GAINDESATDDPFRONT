import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:gaindesat_ddp_client/services/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/ExceptionMessage.dart';
import '../../../models/sensor.dart';
import '../../../services/admin/sensor_service.dart';

part 'sensor_event.dart';
part 'sensor_state.dart';

class SensorBloc extends Bloc<SensorEvent, SensorManagementState> {
  late SharedPreferences prefs;
  late bool finishedOnBoarding;

  SensorBloc(): super(const SensorManagementState.onboarding()) {
    on<CheckFirstRunEvent>((event, emit) async {
      prefs = await SharedPreferences.getInstance();
      finishedOnBoarding = prefs.getBool(finishedOnBoardingConst) ?? false;
      if (!finishedOnBoarding) {
        emit(const SensorManagementState.onboarding());
      }
    });

    on<ValidateSensorFieldsEvent>((event, emit) {
      if (event.key.currentState?.validate() ?? false) {
        event.key.currentState!.save();
        emit(const SensorManagementState.validSensorFields());
      } else {
        emit(const SensorManagementState.failureFillSensorFields("fill required fields"));
      }
    });

    on<SensorAddEvent>((event, emit) async {
      dynamic result = await SensorService().create(event.sensor);
      if (result != null && result is Sensor) {
        emit(SensorManagementState.addSuccess("Sensor added successfully: ${result.uuid}"));
      } else if (result != null && result is ExceptionMessage){
        emit(SensorManagementState.addError(result.message));
      } else {
        emit(SensorManagementState.addError("Unknown Error"));
      }
    });

    on<SensorDeleteInitEvent>((event, emit) async {
      emit(const SensorManagementState.deleteInit());
    });

    on<SensorUpdateEvent>((event, emit) async {
      dynamic result = await SensorService().update(event.sensor);
      if (result != null && result is Sensor) {
        emit(SensorManagementState.updateSuccess("Success"));
      } else {
        emit(SensorManagementState.deleteError("Error"));
      }
    });

    on<SensorDeleteEvent>((event, emit) async {
      dynamic result = await SensorService().delete(event.sensorUUID);
      if( result != null && result is CustomMessage) {
        emit(SensorManagementState.deleteSuccess(result.message));
      } else if (result != null && result is ExceptionMessage) {
        emit(SensorManagementState.deleteError(result.message));
      } else {
        emit(SensorManagementState.deleteError("Unknown Error"));
      }
    });
  }
}