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

  Future<Object> create(Partner partner) async {
    var url = Uri.parse(allPartnersUrl);
    String body = jsonEncode(partner);
    headers = await ApiAuth().buildHeaders();
    http.Response response = await client.post(
      url,
      headers: headers,
      body: body,
    );
    final responseMap = jsonDecode(response.body);
    return responseMap;
  }

  Future<Object> deletePartner(ReducePartner partner) async {
    String? endPoint = partner.uuid;
    var url = Uri.parse('$allPartnersUrl/$endPoint');
    headers = await ApiAuth().buildHeaders();

    http.Response response = await client.delete(
      url,
      headers: headers
    );
    final responseMap = jsonDecode(response.body);
    return responseMap;
  }
}