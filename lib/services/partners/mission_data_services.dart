
import 'package:gaindesat_ddp_client/models/user_detail.dart';
import 'package:gaindesat_ddp_client/services/admin/generic_service.dart';
import 'package:gaindesat_ddp_client/services/auth.dart';
import 'package:gaindesat_ddp_client/services/globals.dart';

import '../../models/ExceptionMessage.dart';
import '../../models/mission_data.dart';

class PartnerMissionDataService {
  late final UserDetails userDetails;
  Future<List<MissionData>> fetchMissionData() async {
    userDetails = await ApiAuth().retrieveUserDetails();
    final String? partnerUUID = userDetails.partnerUuid;
    dynamic response = await GenericService().fetchAllData('$allPartnerMissionDataUrl/$partnerUUID');
    if (response is ExceptionMessage) {
      return [];
    }
    List<MissionData> missionData = response.map<MissionData>((json) => MissionData.fromJson(json)).toList();
    return missionData;
  }
}