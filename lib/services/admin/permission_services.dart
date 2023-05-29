
import 'package:gaindesat_ddp_client/models/permission.dart';
import 'package:gaindesat_ddp_client/services/admin/generic_service.dart';

import '../globals.dart';

class PermissionService {

  Future<List<Permission>> fetchPermissions() async {
    return GenericService()
        .fetchAllData<Permission>(
        Permission.empty(),
        allPermissionsUrl
    );}
}