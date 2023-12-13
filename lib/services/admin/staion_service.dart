
import 'package:gaindesat_ddp_client/models/ExceptionMessage.dart';

import '../../models/station.dart';
import '../globals.dart';
import 'generic_service.dart';

class StationService {
  Future<Object> create(Station station) async {
    dynamic response = await GenericService()
        .createItem<Station>(station, allStationsUrl);
    if(response is ExceptionMessage) {
      return response;
    }
    return Station.fromJson(response);
  }

  Future<Station?> update(Station station) async {return null;}

  Future<Object> delete<Station>(String stationUUID) async {
    return await GenericService().delete<Station>(stationUUID, allStationsUrl);
  }

  Future<List<Station>> fetchStations() async {
    dynamic response = await GenericService().fetchAllData(allStationsUrl);
    if(response is ExceptionMessage) {
      return [Station.empty()];
    }
    List<Station> stations = response.map<Station>((json) => Station.fromJson(json)).toList();
    return stations;
  }
}