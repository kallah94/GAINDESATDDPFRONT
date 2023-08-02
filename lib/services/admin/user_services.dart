import 'package:flutter/foundation.dart';
import 'package:gaindesat_ddp_client/models/ExceptionMessage.dart';
import 'package:gaindesat_ddp_client/services/admin/generic_service.dart';
import 'package:gaindesat_ddp_client/services/globals.dart';

import '../../models/full_user.dart';
import '../../models/user.dart';

class UserService {

  Future<List<FullUser>> fetchUsers() async {
    dynamic response = await GenericService().fetchAllData(allUsersUrl);
    if (response is ExceptionMessage) {
      return [FullUser.empty()];
    }
    List<FullUser> fullUsers = response.map<FullUser>((json) => FullUser.fromJson(json)).toList();
    return fullUsers;
  }

  Future<Object> create(User user) async {
    dynamic response = await GenericService()
        .createItem<User>(user, allUsersUrl);
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