class SensorParameters {
  Map<String, List<String>> sensorParameters = <String, List<String>>{
    "SE200": [
      "salinity", "wingDirection"
    ],
    "WS601": [
      "tds", "wingSpeed"
    ],
    "PLS-C": [
      "waterHeig"
    ]
  };

   getParameters() {
    return sensorParameters;
  }
}