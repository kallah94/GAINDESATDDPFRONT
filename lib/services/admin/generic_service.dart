import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:gaindesat_ddp_client/models/ExceptionMessage.dart';
import 'package:gaindesat_ddp_client/models/category_model.dart';
import 'package:gaindesat_ddp_client/models/full_user.dart';
import 'package:gaindesat_ddp_client/models/partner.dart';
import 'package:gaindesat_ddp_client/models/permission.dart';
import 'package:gaindesat_ddp_client/models/user_detail.dart';
import 'package:http/http.dart' as http;

import '../../models/user.dart';
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
      Map responseMap = jsonDecode(response.body).cast<Map<String, dynamic>>();
      var status = response.statusCode;
      if (status == 200) {
        T entity = entityBuilder<T>(responseMap);
        return entity;
      } else {
        Map errorMap = jsonDecode(response.body);
        ExceptionMessage exceptionMessage = ExceptionMessage(statusCode: status, message: errorMap["message"]);
        return exceptionMessage;
      }
    }
    on SocketException {
      ExceptionMessage exceptionMessage = ExceptionMessage(statusCode: 503, message: "Connection Error");
      return exceptionMessage;
    }
    on TimeoutException catch(e) {
      return ExceptionMessage(statusCode: 599, message: e.message);
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

  entityBuilder<T>(dynamic entity) {
    switch(entity.runtimeType) {
      case ReduceCategory:
        return entity.map<ReduceCategory>((json) => ReduceCategory.fromJson(json));

      case CategoryModel:
        return entity.map<CategoryModel>((json) => CategoryModel.fromJson(json));

      case ReducePartner:
        return entity.map<ReducePartner>((json) => ReducePartner.fromJson(json));

      case Partner:
        return entity.map<Partner>((json) => Partner.fromJson(json));

      case FullUser:
        return entity.map<FullUser>((json) => FullUser.fromJson(json));

      case User:
        return entity.map<User>((json) => User.fromJson(json));

      case Permission:
        return entity.map<Permission>((json) => Permission.fromJson(json));

      default:
        return null;
    }
  }
}