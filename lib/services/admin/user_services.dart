
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:gaindesat_ddp_client/models/user_detail.dart';
import 'package:gaindesat_ddp_client/services/auth.dart';
import 'package:gaindesat_ddp_client/services/globals.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/full_user.dart';

class UserService {
  var client = http.Client();
  late final UserDetails userDetails;
  late final SharedPreferences prefs;

  Future<UserDetails?> create() async { return null;}

  Future<List<FullUser>> fetchUsers() async {
    prefs = await SharedPreferences.getInstance();
    var url = Uri.parse(allUsersUrl);
    userDetails = await ApiAuth().retrieveUserDetails();
    final String? token = userDetails.accessToken;
    final List<FullUser> fullUsers;
    headers.addEntries({'Authorization': 'Bearer $token'}.entries);
    http.Response response = await client.get(
      url,
      headers: headers
    );
    final responseMap = jsonDecode(response.body).cast<Map<String, dynamic>>();
    fullUsers = responseMap.map<FullUser>((json) => FullUser.fromJson(json)).toList();
    if (kDebugMode) {
      print(headers);
      print(fullUsers);
    }
    return fullUsers;
  }

}