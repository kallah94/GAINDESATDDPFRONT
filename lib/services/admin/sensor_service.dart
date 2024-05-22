

import 'package:flutter/foundation.dart';
import 'package:gaindesat_ddp_client/models/ExceptionMessage.dart';
import 'package:gaindesat_ddp_client/services/admin/generic_service.dart';
import 'package:gaindesat_ddp_client/services/globals.dart';

import '../../models/sensor.dart';

class SensorService {
  Future<List<Sensor>> fetchSensors() async {
    dynamic response = await GenericService().fetchAllData(allSensors);
    if (response is ExceptionMessage) {
      return [Sensor.empty()];
    }
    List<Sensor> sensors = response.map<Sensor>((json) => Sensor.fromJson(json)).toList();
    return sensors;
  }

  Future<Object> create(Sensor sensor) async {
    if (kDebugMode) {
      print(sensor);
    }
    dynamic response = await GenericService()
        .createItem<Sensor>(sensor, allSensors);
    if(response is ExceptionMessage) {
      return response;
    }
    return Sensor.fromJson(response);
  }

  Future<Object> update(Sensor sensor) async {
    dynamic response = await GenericService()
        .updateItem<Sensor>(sensor, allSensors, sensor.uuid!);
    if (response is ExceptionMessage) {
      return response;
    }
    return Sensor.fromJson(response);
  }

  Future<Object> delete(String sensorUUID) async {
    return await GenericService().delete<Sensor>(sensorUUID, allSensors);
  }
}