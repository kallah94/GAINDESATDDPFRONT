import 'package:gaindesat_ddp_client/services/admin/generic_service.dart';
import 'package:gaindesat_ddp_client/services/globals.dart';

import '../../models/full_user.dart';

class UserService {
  Future<FullUser?> create() async { return null;}

  Future<List<FullUser>> fetchUsers() async {
    return GenericService()
        .fetchAllData<FullUser>(
        FullUser.empty(),
        allUsersUrl
    );}
}