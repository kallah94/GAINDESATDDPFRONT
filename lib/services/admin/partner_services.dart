import 'package:gaindesat_ddp_client/models/ExceptionMessage.dart';
import 'package:gaindesat_ddp_client/models/partner.dart';
import 'package:gaindesat_ddp_client/services/globals.dart';

import 'generic_service.dart';

class PartnerService {
  Future<List<ReducePartner>> fetchPartners() async {
    dynamic response = await GenericService().fetchAllData(allPartnersUrl);
    if (response is ExceptionMessage) {
      return [ReducePartner.empty()];
    }
    List<ReducePartner> reducePartners = response.map<ReducePartner>((json) => ReducePartner.fromJson(json)).toList();
    return reducePartners;
  }

  Future<Object> create(Partner partner) async {
    dynamic response = await GenericService()
        .createItem<Partner>(partner, allPartnersUrl);
    if(response is ExceptionMessage) {
      return response;
    }
    return Partner.fromJson(response);
  }

  Future<Object?> update(Partner partner) async {
    dynamic response = await GenericService()
        .updateItem<Partner>(partner, allPartnersUrl, partner.uuid!);
    if (response is ExceptionMessage) {
      return response;
    }
    return Partner.fromJson(response);
  }

  Future<Object> delete(String partnerUUID) async {
    return await GenericService().delete<Partner>(partnerUUID, allPartnersUrl);
  }

}