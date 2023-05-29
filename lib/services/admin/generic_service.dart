import 'dart:convert';

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