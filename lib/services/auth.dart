import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_detail.dart';
import 'package:http/http.dart' as http;

import 'globals.dart';
/// The service responsible for handling authentication requests

class ApiAuth {
  var client = http.Client();
  late final SharedPreferences prefs;
  Future<Object> login(String username, String password) async {
    prefs = await SharedPreferences.getInstance();
    Map data = {
      'username': username,
      'password': password
    };
    var body = json.encode(data);
    var url = Uri.parse(loginUrl);

    try {
      http.Response response = await client.post(
          url,
          headers: headers,
          body: body
      ).timeout(const Duration(seconds: 45));
      Map responseMap = jsonDecode(response.body);
      var status = response.statusCode;
      if (status == 200) {
        UserDetails userDetails = UserDetails.fromJson(responseMap);
        String userDetailsString = jsonEncode(UserDetails.fromJson(responseMap));
        prefs.setString(userDetailsKey, userDetailsString);
        return userDetails;
      } else {
        return responseMap["message"];
      }
    }
    on SocketException {
      return "Connection errors";
    }
    on TimeoutException catch (e) {
      return "Connection timeOut";
    }
    on Error catch(e) {
      return "Unknown error occur";
    }
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
        partnerUuid: map["partnerUuid"],
        roles: map['roles'].cast<String>(),
        accessToken: map['accessToken']);
    return userDetails;
  }

  Future<Map<String, String>> buildHeaders() async {
    late final UserDetails userDetails;
    userDetails = await retrieveUserDetails();
    final String? token = userDetails.accessToken;
    headers.addEntries({"Authorization": 'Bearer $token'}.entries);
    return headers;
  }
}

