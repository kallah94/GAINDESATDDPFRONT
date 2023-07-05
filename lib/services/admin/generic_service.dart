import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:gaindesat_ddp_client/models/ExceptionMessage.dart';
import 'package:gaindesat_ddp_client/models/category_model.dart';
import 'package:gaindesat_ddp_client/models/full_user.dart';
import 'package:gaindesat_ddp_client/models/partner.dart';
import 'package:gaindesat_ddp_client/models/permission.dart';
import 'package:gaindesat_ddp_client/models/user_detail.dart';
import 'package:http/http.dart' as http;
import '../auth.dart';
import '../globals.dart';

class GenericService {
  var client = http.Client();
  late final UserDetails userDetails;
 Future<dynamic> createItem<T>(T item, final String path) async {
    var url = Uri.parse(path);
    String body = jsonEncode(item);
    headers = await ApiAuth().buildHeaders();
    try {
      http.Response response = await client.post(
        url,
        headers: headers,
        body: body
      ).timeout(const Duration(seconds: 45));
      var status = response.statusCode;
      if (status == 201) {
        Map responseMap = jsonDecode(response.body);
        return responseMap;
      } else {
        ExceptionMessage exceptionMessage = ExceptionMessage(statusCode: status, message: "Error occur item not added");
        return exceptionMessage;
      }
    }
    on SocketException {
      ExceptionMessage exceptionMessage = ExceptionMessage(statusCode: 503, message: "Connection Error");
      return exceptionMessage;
    }
    on TimeoutException catch(e) {
      return ExceptionMessage(statusCode: 599, message: e.message);
    } catch (_, exception) {
      return ExceptionMessage(statusCode: 500, message: exception.toString());
   }
  }

  Future<dynamic> delete<T>(final String itemUUID, final String path) async {
    var url = Uri.parse('$path/$itemUUID');
    headers = await ApiAuth().buildHeaders();
    try {
      http.Response response = await client.delete(
        url,
        headers: headers
      ).timeout(const Duration(seconds: 60));
      var status = response.statusCode;
      if(status == 200) {
        Map responseMap = jsonDecode(response.body);
        return CustomMessage.fromJson(responseMap);
      } else {
        Map responseMap = jsonDecode(response.body);
        if (kDebugMode) {
          print(responseMap);
        }
        return ExceptionMessage.fromJson(responseMap);
      }
    }
    on SocketException {
      ExceptionMessage exceptionMessage = ExceptionMessage(statusCode: 503, message: "Connection Error");
      return exceptionMessage;
    }
    on TimeoutException catch(e) {
      return ExceptionMessage(statusCode: 599, message: e.message);
    } catch (_, exception) {
      return ExceptionMessage(statusCode: 500, message: exception.toString());
    }
  }

  Future<List<T>> fetchAllData<T>(T object, final String path) async {
    var url = Uri.parse(path);
    userDetails = await ApiAuth().retrieveUserDetails();
    final String? token = userDetails.accessToken;
    headers.addEntries({"Authorization": 'Bearer $token'}.entries);
    final List<T> allData;

    http.Response response = await client.get(
        url,
        headers: headers
    );

    final responseMap = jsonDecode(response.body).cast<Map<String, dynamic>>();

    switch (object.runtimeType) {
      case ReduceCategory:
        allData = responseMap.map<ReduceCategory>((json) => ReduceCategory.fromJson(json)).toList();
        return allData;

      case ReducePartner:
        allData = responseMap.map<ReducePartner>((json) => ReducePartner.fromJson(json)).toList();
        return allData;

      case FullUser:
        allData = responseMap.map<FullUser>((json) => FullUser.fromJson(json)).toList();
        return allData;

      case Permission:
        allData = responseMap.map<Permission>((json) => Permission.fromJson(json)).toList();
        return allData;

      default:
        throw "Unable to determinate class";
    }
  }
}