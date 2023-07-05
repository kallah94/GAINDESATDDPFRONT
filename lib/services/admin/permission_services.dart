
import 'package:flutter/foundation.dart';
import 'package:gaindesat_ddp_client/models/ExceptionMessage.dart';
import 'package:gaindesat_ddp_client/models/permission.dart';
import 'package:gaindesat_ddp_client/services/admin/generic_service.dart';

import '../globals.dart';

class PermissionService {

  Future<Object> create(Permission permission) async {
    dynamic response = await GenericService()
        .createItem<Permission>(permission, allPermissionsUrl);
    if(response is ExceptionMessage) {
      return response;
    }
    return ReducePermission.fromJson(response);
  }

  Future<Permission?> update(Permission permission) async {return null;}

  Future<Object> delete<Permission>(String permissionUUID) async {
    return await GenericService().delete<Permission>(permissionUUID, allPermissionsUrl);
  }

  Future<List<Permission>> fetchPermissions() async {
    return GenericService()
        .fetchAllData<Permission>(
        Permission.empty(),
        allPermissionsUrl
    );}
}