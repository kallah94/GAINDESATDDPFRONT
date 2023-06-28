import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:gaindesat_ddp_client/services/admin/permission_services.dart';
import 'package:gaindesat_ddp_client/services/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/permission.dart';

part 'permission_event.dart';
part 'permission_state.dart';

class PermissionBloc extends Bloc<PermissionEvent, PermissionManagementState> {
  late SharedPreferences prefs;
  late bool finishedOnBoarding;

  PermissionBloc() : super(const PermissionManagementState.onboarding()) {
    on<CheckFirstRunEvent>((event, emit) async {
      prefs = await SharedPreferences.getInstance();
      finishedOnBoarding = prefs.getBool(finishedOnBoardingConst) ?? false;
      if (!finishedOnBoarding) {
        emit(const PermissionManagementState.onboarding());
      }
    });

    on<ValidatePermissionFieldsEvent>((event, emit) {
      if (event.key.currentState?.validate() ?? false) {
        event.key.currentState!.save();
        emit(const PermissionManagementState.validPartnerFields());
      } else {
        emit( const PermissionManagementState.failureFillPartnerFields("fill required fields"));
      }
    });

    on<PermissionAddEvent>((event, emit) async {
      dynamic result = PermissionService().create(event.permission);
      if (result !=null && result is Permission) {
        emit(const PermissionManagementState.addSuccess("Success"));
      } else {
        emit(const PermissionManagementState.addError("Error"));
      }
    });

    on<PermissionUpdateEvent>((event, emit) async {
      dynamic result = PermissionService().update(event.permission);
      if(result != null && result is Permission) {
        emit(const PermissionManagementState.addSuccess("Success"));
      } else {
        emit(const PermissionManagementState.updateError("Error"));
      }
    });

    on<PermissionDeleteInitEvent>((event, emit) => emit(const PermissionManagementState.deleteInit()));

    on<PermissionDeleteEvent>((event, emit) async {
      dynamic result = PermissionService().delete(event.permissionUUID);
      if(result != null && result is Permission) {
        emit(const PermissionManagementState.deleteSuccess("Success"));
      } else {
        emit(const PermissionManagementState.deleteError("Error"));
      }
    });
  }
}