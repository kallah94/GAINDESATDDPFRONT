import 'package:gaindesat_ddp_client/models/partner.dart';
import 'package:gaindesat_ddp_client/services/globals.dart';

import 'generic_service.dart';

class PartnerService {
  Future<List<ReducePartner>> fetchPartners() async {
    return GenericService()
        .fetchAllData<ReducePartner>(
        ReducePartner.empty(),
        allPartnersUrl
    );}
}