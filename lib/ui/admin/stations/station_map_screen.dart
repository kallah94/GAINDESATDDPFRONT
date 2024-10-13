import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../services/helper.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }
  void _loadMarkers() {
    // Add markers dynamically, you can load from a database or any other source
    _markers.add(
      Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(43.636584, 3.842965),
        builder: (ctx) => GestureDetector(
          onTap: () {
          },
          child:  Tooltip(
            message: 'CSUM',
            child: Icon(Icons.share_location_sharp, color: Colors.teal.shade900, size: 40),
          ),
        ),
      ),
    );
    _markers.add(
      Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(14.74545, -17.20809),
        builder: (ctx) => GestureDetector(
          onTap: () {
            // Handle tap if needed
            if (kDebugMode) {
              print("test");
            }
          },
          child: Tooltip(
            message: 'Centre de Contrôle SENSAT',
            child: Icon(Icons.share_location_rounded, color: Colors.teal.shade900, size: 40),
          ),
        ),
      ),
    );
    _markers.add(
      Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(16.243337, -15.801953),
        builder: (ctx) => GestureDetector(
          onTap: () {
            // Handle tap if needed
            if (kDebugMode) {
              print("test");
            }
          },
          child: Tooltip(
            message: 'Saniente: SE-200\n Niveau d\'eau',
            child: Column(
              children: [
                Icon(Icons.location_on, color: Colors.red.shade900, size: 40),
                const Icon(Icons.circle, color: Colors.red, size: 13)
              ],
            )
          ),
        ),
      )
    );
    _markers.add(
      Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(13.695721, -15.679178),
        builder: (ctx) => GestureDetector(
          onTap: () {
            // Handle tap if needed
            if (kDebugMode) {
              print("test");
            }
          },
          child: Tooltip(
            message: 'Baobolong: SE-200\n Niveau d\'eau',
            child: Column(
              children: [
                Icon(Icons.location_on, color: Colors.red.shade900, size: 40),
                const Icon(Icons.circle, color: Colors.green, size: 13)
              ],
            )
          ),
        ),
      ),
    );
    _markers.add(
      Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(12.589462, -16.262593),
        builder: (ctx) => GestureDetector(
          onTap: () {
            // Handle tap if needed
          },
          child: Tooltip(
            message: 'Ziguinchor: SE-200\n Niveau d\'eau',
            child: Column(
              children: [
                Icon(Icons.location_on, color: Colors.red.shade900, size: 40),
                const Icon(Icons.circle, color: Colors.red, size: 13)
              ],
            )
          ),
        ),
      ),
    );
    _markers.add(
      Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(16.185717, -15.901662),
        builder: (ctx) => GestureDetector(
          onTap: () {
            // Handle tap if needed
          },
          child: Tooltip(
            message: 'Ngnith: WS601\n * Temperature\n * Humidité\n * Direction du vent\n * Vitesse du vent\n * Précipitation',
            child: Column(
              children: [
                Icon(Icons.location_on, color: Colors.green.shade900, size: 40),
                const Icon(Icons.circle, color: Colors.red, size: 13)
              ],
            )
          ),
        ),
      ),
    );
    _markers.add(
      Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(12.886832, -13.960733),
        builder: (ctx) => GestureDetector(
          onTap: () {
            // Handle tap if needed
          },
          child: Tooltip(
            message: 'Niandouba: WS601\n * Temperature\n * Humidité\n * Direction du vent\n * Vitesse du vent\n * Précipitation',
            child: Column(
              children: [
                Icon(Icons.location_on, color: Colors.green.shade900, size: 40),
                const Icon(Icons.circle, color: Colors.red, size: 13)
              ],
            )
          ),
        ),
      ),
    );
    _markers.add(
      Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(13.618914, -16.281726),
        builder: (ctx) => GestureDetector(
          onTap: () {
            // Handle tap if needed
          },
          child: Tooltip(
            message: 'Djikoye: WS601\n * Temperature\n * Humidité\n * Direction du vent\n * Vitesse du vent\n * Précipitation',
            child: Column(
              children: [
                Icon(Icons.location_on, color: Colors.green.shade900, size: 40),
                const Icon(Icons.circle, color: Colors.green, size: 13)
              ],
            )
               ),
        ),
      ),
    );
    _markers.add(
      Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(16.464593, -15.693019),
        builder: (ctx) => GestureDetector(
          onTap: () {
            // Handle tap if needed
          },
          child: Tooltip(
            message: 'RichardToll: PLS-C',
            child: Column(
              children: [
                Icon(Icons.location_on, color: Colors.amber.shade900, size: 40),
                const Icon(Icons.circle, color: Colors.green, size: 13)
              ],
            )
          ),
        ),
      ),
    );
    _markers.add(
      Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(13.691568, -13.176045),
        builder: (ctx) => GestureDetector(
          onTap: () {
            // Handle tap if needed
          },
          child: Tooltip(
            message: 'Nieriko-Goumbayel: PLS-C',
              child: Column(
                children: [
                  Icon(Icons.location_on, color: Colors.amber.shade900, size: 40),
                  const Icon(Icons.circle, color: Colors.green, size: 13)
                ],
              )
             ),
        ),
      ),
    );
    _markers.add(
      Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(12.837451, -15.986699),
        builder: (ctx) => GestureDetector(
          onTap: () {
            // Handle tap if needed
          },
          child: Tooltip(
            message: 'Marsassoum: PLS-C',
            child: Column(
              children: [
                Icon(Icons.location_on, color: Colors.amber.shade900, size: 40),
                const Icon(Icons.circle, color: Colors.red, size: 13)
              ],
            )
           ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            ),
          ],
        ),
        backgroundColor: Colors.teal.shade900,
        iconTheme: IconThemeData(
            color: isDarkMode(context)
                ? Colors.tealAccent
                : Colors.tealAccent
        ),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: LatLng(14.4974, -14.4524),
          zoom: 8.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: _markers,
          ),
        ],
      ),
    );
  }
}
