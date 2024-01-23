import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:gaindesat_ddp_client/models/ExceptionMessage.dart';
import 'package:gaindesat_ddp_client/models/mission_data.dart';
import 'package:gaindesat_ddp_client/models/user_detail.dart';
import 'package:gaindesat_ddp_client/services/admin/generic_service.dart';
import 'package:gaindesat_ddp_client/services/auth.dart';
import 'package:gaindesat_ddp_client/services/globals.dart';
import 'package:http/http.dart' as http;

class MissionDataService {
  Future<List<MissionData>> fetchMissionData() async {
    dynamic response = await GenericService().fetchAllData(allMissionData);
    if (response is ExceptionMessage) {
      return [];
    }
    List<MissionData> missionData = response.map<MissionData>((json) => MissionData.fromJson(json)).toList();
    return missionData;
  }

  Future<dynamic> requestMissionData(String? startDate, String? endDate) async {
    var client = http.Client();
    if (kDebugMode) {
      print("start date from service: $startDate");
      print("end date from service: $endDate");
    }
    final UserDetails userDetails = await ApiAuth().retrieveUserDetails();
    var url = Uri.parse(requestMissionDataUrl);
    Map body = {
      "startDate": startDate,
      "endDate": endDate,
      "token": userDetails.accessToken
    };
    try {
      http.Response response = await client.post(
        url,
        body: body
      ).timeout(const Duration(seconds: 50));
      var status = response.statusCode;
      if (status == 200) {
        return CustomMessage(statusCode: status, message: "data saved successfully");;
      }
    } on Error catch(error) {
      return ExceptionMessage(statusCode: 500, message: "Error occur during requesting mission data: $error");
    }
  }
}