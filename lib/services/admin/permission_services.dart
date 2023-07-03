
import 'package:gaindesat_ddp_client/models/ExceptionMessage.dart';
import 'package:gaindesat_ddp_client/models/permission.dart';
import 'package:gaindesat_ddp_client/services/admin/generic_service.dart';

import '../globals.dart';

class PermissionService {

  Future<dynamic> create(Permission permission) async {
    dynamic response = GenericService()
        .createItem<Permission>(permission, allPermissionsUrl);
    if(response is ExceptionMessage) {
      return response;
    }
    return Permission.fromJson(response);
  }

  Future<Permission?> update(Permission permission) async {return null;}

  Future<Permission?> delete(String permissionUUID) async { return null;}

  Future<List<Permission>> fetchPermissions() async {
    return GenericService()
        .fetchAllData<Permission>(
        Permission.empty(),
        allPermissionsUrl
    );}
}