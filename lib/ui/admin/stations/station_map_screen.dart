import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../services/helper.dart';

class StationPosition extends StatefulWidget {
  const StationPosition({super.key});

  @override
  State createState() => _StationPositionState();
}

class _StationPositionState extends State<StationPosition> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(-33.86, 151.20);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Localisation stations de collectes",
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Stations de Collectes',
                style: TextStyle(
                  color: Colors.white
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
          backgroundColor: Colors.teal,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: isDarkMode(context)
                ? Colors.tealAccent
                : Colors.tealAccent
          ),
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0
          ),
          markers: {
            const Marker(
              markerId: MarkerId("Senegal"),
              position: LatLng(14, 15),
              infoWindow: InfoWindow(
                title: "Senegal",
                snippet: "Afrique"
              )
            )
          },
        ),
      ),
    );
  }
}