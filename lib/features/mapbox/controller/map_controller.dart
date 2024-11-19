import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
// import 'package:get_it/get_it.dart';
// import 'package:logger/logger.dart';
// import 'marker_controller.dart';

class MapController {
  MapController({required this.currentLocation}); //, required this.marker})
  // : markerController = MarkerController(currentLocation: currentLocation);

  // final MarkerController markerController;
  LatLng currentLocation;
  // final Widget marker;
  late MapboxMap mapboxMap;
  LatLng? markerPosition;

  void onMapCreated(MapboxMap map) {
    mapboxMap = map;
    // GetIt.I<Logger>().d('Map Created Controller: $mapboxMap.toString()');
  }

  // void onCameraChangeListener(CameraChangedEventData eventData) {
  //   _updateMarkerPosition(currentLocation);
  // }

  // void updateUI() {
  //   _updateMarkerPosition(currentLocation);
  // }

  // void _updateMarkerPosition(LatLng newLocation) async {
  //   final screenPosition =
  //       markerController.getMarkerScreenPosition(newLocation);
  //   print(screenPosition);
  // }

  void flyToLocation(LatLng newLocation) {
    mapboxMap.flyTo(
      CameraOptions(
        center: Point.fromJson({
          'coordinates': [newLocation.longitude, newLocation.latitude]
        }),
        zoom: 15.0, // Adjust zoom level as needed
      ),
      MapAnimationOptions(duration: 1000), // Animation duration
    );
  }

  Future<Offset?> getMarkerScreenPosition() async {
    if (markerPosition != null) {
      final screenPoint = await mapboxMap.pixelForCoordinate(Point.fromJson({
        'coordinates': [markerPosition!.longitude, markerPosition!.latitude]
      }));
      return Offset(screenPoint.x, screenPoint.y);
    }
    return null;
  }
}
