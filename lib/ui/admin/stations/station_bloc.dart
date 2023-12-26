import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:gaindesat_ddp_client/models/ExceptionMessage.dart';
import 'package:gaindesat_ddp_client/models/full_station.dart';
import 'package:gaindesat_ddp_client/models/station.dart';
import 'package:gaindesat_ddp_client/services/admin/staion_service.dart';
import 'package:gaindesat_ddp_client/services/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'station_event.dart';
part 'station_state.dart';


class StationBloc extends Bloc<StationEvent, StationManagementState> {
  late SharedPreferences prefs;
  late bool finishedOnBoarding;

  StationBloc(): super(const StationManagementState.onboarding()) {
    on<CheckFirstRunEvent>((event, emit) async {
      prefs = await SharedPreferences.getInstance();
      finishedOnBoarding = prefs.getBool(finishedOnBoardingConst) ?? false;
      if (!finishedOnBoarding) {
        emit(const StationManagementState.onboarding());
      }
    });

    on<ValidateStationsFieldsEvent>((event, emit) {
      if (event.key.currentState?.validate() ?? false) {
        event.key.currentState!.save();
        emit(const StationManagementState.validStationFields());
      } else {
        emit(const StationManagementState.failureFillStationFields("Fill required fields"));
      }
    });

    on<StationAddEvent>((event, emit) async {
      dynamic result = await StationService().create(event.station);
      if (kDebugMode) {
        print(result);
      }
      if (result != null) {
        if (result is FullStation) {
          emit(StationManagementState.addSuccess("Station added successfully: ${result.uuid}"));
        } else if (result is ExceptionMessage) {
          emit(StationManagementState.addError(result.message));
        }
      } else {
        emit(StationManagementState.addError("Unknown Error"));
      }
    });

    on<StationUpdateEvent>((event, emit) async {
      dynamic result = await StationService().update(event.station);
      if(result != null && result is Station) {
        emit(StationManagementState.updateSuccess("success"));
      } else {
        emit(StationManagementState.updateError("Error"));
      }
    });

    on<StationsDeleteInitEvent>((event, emit) =>
        emit(const StationManagementState.deleteInit()));

    on<StationDeleteEvent>((event, emit) async {
      dynamic result = await StationService().delete(event.stationUUID);
      if(result != null && result is CustomMessage) {
        emit(StationManagementState.deleteSuccess(result.message));
      } else if(result != null && result is ExceptionMessage) {
        emit(StationManagementState.deleteError(result.message));
      } else {
        emit(StationManagementState.deleteError("Unknown Error"));
      }
    });
  }
}