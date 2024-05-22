import 'package:gaindesat_ddp_client/models/ExceptionMessage.dart';
import 'package:gaindesat_ddp_client/models/parameter.dart';
import 'package:gaindesat_ddp_client/services/globals.dart';

import 'generic_service.dart';

class ParameterService {
  Future<List<Parameter>> fetchParameters() async {
    dynamic response = await GenericService().fetchAllData(allParametersUrl);
    if (response is ExceptionMessage) {
      return [Parameter.empty()];
    }
    List<Parameter> parameters = response.map<Parameter>((json) => Parameter.fromJson(json)).toList();
    return parameters;
  }

  Future<Object> create(Parameter parameter) async {
    dynamic response = await GenericService()
        .createItem<Parameter>(parameter, allParametersUrl);
    if(response is ExceptionMessage) {
      return response;
    }
    return Parameter.fromJson(response);
  }

  Future<Object?> update(Parameter parameter) async {
    dynamic response = await GenericService()
        .updateItem<Parameter>(parameter, allParametersUrl, parameter.uuid!);
    if (response is ExceptionMessage) {
      return response;
    }
    return Parameter.fromJson(response);
  }

  Future<Object> delete(String parameterUUID) async {
    return await GenericService().delete<Parameter>(parameterUUID, allParametersUrl);
  }

}
