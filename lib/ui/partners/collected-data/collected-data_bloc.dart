import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:gaindesat_ddp_client/services/admin/mission_data_services.dart';
import 'package:gaindesat_ddp_client/services/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'collected-data_event.dart';
part 'collected-data_state.dart';

class CollectedDataBloc extends Bloc<CollectedDataEvent, CollectedDataManagementState> {
  late SharedPreferences prefs;
  late bool finishedOnBoarding;

  CollectedDataBloc(): super(const CollectedDataManagementState.onboarding()) {
    on<CheckFirstRunEvent>((event, emit) async {
      prefs = await SharedPreferences.getInstance();
      finishedOnBoarding = prefs.getBool(finishedOnBoardingConst) ?? false;
      if (!finishedOnBoarding) {
        emit(const CollectedDataManagementState.onboarding());
      }
    });

    on<ValidateCollectedDataDatesFieldsEvent>((event, emit) {
      if (event.key.currentState?.validate() ?? false) {
        emit(const CollectedDataManagementState.validDateFields());
      } else {
        emit(CollectedDataManagementState.failureFillDateFields("fill required fields"));
      }
    });

    on<CollectedDataRequestInitEvent>((event, emit) => emit(const CollectedDataManagementState.requestInit()));

    on<CollectedDataRequestEvent>((event, emit) async {
      dynamic result = await MissionDataService().requestMissionData(event.startDate, event.endDate);
      emit(CollectedDataManagementState.requestCollectedDataSuccess("Data requested successfully"));
    });
  }
}