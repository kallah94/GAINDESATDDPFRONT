import 'package:gaindesat_ddp_client/services/admin/generic_service.dart';
import 'package:gaindesat_ddp_client/services/globals.dart';

import '../../models/full_user.dart';

class UserService {
  Future<FullUser?> create(FullUser fullUser) async { return null;}

  Future<FullUser?> update(FullUser fullUser) async { return null;}

  Future<FullUser?> delete(String? fullUserUUID) async { return null;}

  Future<List<FullUser>> fetchUsers() async {
    return GenericService()
        .fetchAllData<FullUser>(
        FullUser.empty(),
        allUsersUrl
    );}
}