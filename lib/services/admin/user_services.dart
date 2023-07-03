import 'package:gaindesat_ddp_client/models/ExceptionMessage.dart';
import 'package:gaindesat_ddp_client/services/admin/generic_service.dart';
import 'package:gaindesat_ddp_client/services/globals.dart';

import '../../models/full_user.dart';

class UserService {

  Future<List<FullUser>> fetchUsers() async {
    return GenericService()
        .fetchAllData<FullUser>(
        FullUser.empty(),
        allUsersUrl
    );}

  Future<Object> create(FullUser fullUser) async {
    dynamic response = await GenericService()
        .createItem<FullUser>(fullUser, allUsersUrl);
    if (response is ExceptionMessage) {
      return response;
    }
    return FullUser.fromJson(response);
  }

  Future<FullUser?> update(FullUser fullUser) async { return null;}

  Future<Object> delete(String fullUserUUID) async {
    return await GenericService().delete<FullUser>(fullUserUUID, allUsersUrl);
  }


}