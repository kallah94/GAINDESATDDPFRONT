import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_detail.dart';
import 'package:http/http.dart' as http;

import 'globals.dart';
/// The service responsible for handling authentication requests

class ApiAuth {
  var client = http.Client();
  late final SharedPreferences prefs;
  Future<UserDetails> login(String username, String password) async {
    prefs = await SharedPreferences.getInstance();
    Map data = {
      'username': username,
      'password': password
    };
    var body = json.encode(data);
    var url = Uri.parse(loginUrl);

    http.Response response = await client.post(
      url,
      headers: headers,
      body: body
    );
    Map responseMap = jsonDecode(response.body);
    UserDetails userDetails = UserDetails.fromJson(responseMap);
    String userDetailsString = jsonEncode(UserDetails.fromJson(responseMap));
    prefs.setString(userDetailsKey, userDetailsString);
    return userDetails;
  }

  logout() {
    prefs.remove(userDetailsKey);
  }

  Future<UserDetails> retrieveUserDetails() async {
    late final UserDetails userDetails;
    late final SharedPreferences prefs;

    prefs = await SharedPreferences.getInstance();
    final userDetailsJson = prefs.getString(userDetailsKey) ?? '';
    Map<String, dynamic> map = jsonDecode(userDetailsJson);
    userDetails = UserDetails(
        uuid: map['uuid'],
        username: map['username'],
        email: map['email'],
        roles: map['roles'].cast<String>(),
        accessToken: map['accessToken']);
    return userDetails;
  }
}

