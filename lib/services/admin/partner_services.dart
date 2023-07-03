import 'dart:convert';
import 'package:gaindesat_ddp_client/models/ExceptionMessage.dart';
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
    dynamic response = await GenericService()
        .createItem<Partner>(partner, allPartnersUrl);
    if(response is ExceptionMessage) {
      return response;
    }
    return Partner.fromJson(response);
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

  Future<Object> delete<Partner>(String partnerUUID) async {
    return await GenericService().delete<Partner>(partnerUUID, allPartnersUrl);
  }

}