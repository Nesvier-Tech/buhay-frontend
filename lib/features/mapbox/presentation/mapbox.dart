import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../controller/map_controller.dart';

class MapboxMapWidget extends StatelessWidget {
  MapboxMapWidget({super.key, required this.currentLocation})
      : mapController = MapController(
            currentLocation: currentLocation,
            marker: const Icon(Icons.location_on, size: 50.0));

  final MapController mapController;
  final LatLng currentLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapWidget(
        cameraOptions: CameraOptions(
          center: Point.fromJson({
            'coordinates': [
              mapController.currentLocation.longitude,
              mapController.currentLocation.latitude
            ]
          }),
          zoom: 14.0,
          bearing: 0.0,
          pitch: 0.0,
        ),
        onMapCreated: mapController.onMapCreated,
        onCameraChangeListener: mapController.onCameraChangeListener,
      ),
    );
  }
}
