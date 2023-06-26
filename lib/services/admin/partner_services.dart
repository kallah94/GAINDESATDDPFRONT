import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:gaindesat_ddp_client/models/partner.dart';
import 'package:gaindesat_ddp_client/models/user_detail.dart';
import 'package:gaindesat_ddp_client/services/auth.dart';
import 'package:gaindesat_ddp_client/services/globals.dart';

import 'generic_service.dart';
import 'package:http/http.dart' as http;

class PartnerService {
  var client = http.Client();
  late final UserDetails userDetails;
  late final Map<String, String> headers;

  Future<List<ReducePartner>> fetchPartners() async {
    return GenericService()
        .fetchAllData<ReducePartner>(
        ReducePartner.empty(),
        allPartnersUrl
    );}

  Future<Partner> create(Partner partner) async {
    var url = Uri.parse(allPartnersUrl);
    String body = jsonEncode(partner);
    headers = await ApiAuth().buildHeaders();
    http.Response response = await client.post(
      url,
      headers: headers,
      body: body,
    );
    final responseMap = jsonDecode(response.body);
    if (kDebugMode) {
      print(responseMap);
    }
    Partner newPartner = Partner.fromJson(responseMap);
    return newPartner;
  }

  Future<Object> updatePartner(Partner partner) async {
    String? endPoint = partner.uuid;
    String body = jsonEncode(partner);
    var url = Uri.parse('$allPartnersUrl/$endPoint');
    headers = await ApiAuth().buildHeaders();

    http.Response response = await client.put(
      url,
      body: body,
      headers: headers,
    );
    final responseMap = jsonDecode(response.body);

    return responseMap;
  }
  Future<Object> deletePartner(String partnerUUID) async {
    var url = Uri.parse('$allPartnersUrl/$partnerUUID');
    headers = await ApiAuth().buildHeaders();

    http.Response response = await client.delete(
      url,
      headers: headers
    );
    if (kDebugMode) {
      print(response.body);
    }
    //final responseMap = jsonDecode(response.body);
    return response.body;
  }
}