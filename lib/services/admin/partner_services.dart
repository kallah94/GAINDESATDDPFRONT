import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:gaindesat_ddp_client/models/partner.dart';
import 'package:gaindesat_ddp_client/models/user_detail.dart';
import 'package:gaindesat_ddp_client/services/auth.dart';
import 'package:gaindesat_ddp_client/services/globals.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PartnerService {
  var client = http.Client();
  late final UserDetails userDetails;
  late final SharedPreferences prefs;

  Future<List<ReducePartner>> fetchPartners() async {
    prefs = await SharedPreferences.getInstance();
    var url = Uri.parse(allPartnersUrl);
    userDetails = await ApiAuth().retrieveUserDetails();
    final String? token = userDetails.accessToken;
    final List<ReducePartner> partners;
    headers.addEntries({"Authorization": 'Bearer $token'}.entries);

    http.Response response = await client.get(
      url,
      headers: headers
    );

    final responseMap = jsonDecode(response.body).cast<Map<String, dynamic>>();
    partners = responseMap.map<ReducePartner>((json) => ReducePartner.fromJson(json)).toList();
    if (kDebugMode) {
      print(headers);
      print(partners);
    }

    return partners;
  }
}