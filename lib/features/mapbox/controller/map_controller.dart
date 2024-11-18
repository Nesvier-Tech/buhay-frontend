import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'marker_controller.dart';

class MapController {
  MapController({required this.currentLocation, required this.marker})
      : markerController = MarkerController(currentLocation: currentLocation);

  final MarkerController markerController;
  LatLng currentLocation;
  final Widget marker;
  late MapboxMap mapboxMap;

  void onMapCreated(MapboxMap map) {
    mapboxMap = map;
  }

  void onCameraChangeListener(CameraChangedEventData eventData) {
    _updateMarkerPosition(currentLocation);
  }

  void updateUI() {
    _updateMarkerPosition(currentLocation);
  }

  void _updateMarkerPosition(LatLng newLocation) async {
    final screenPosition =
        markerController.getMarkerScreenPosition(newLocation);
    print(screenPosition);
  }
}
