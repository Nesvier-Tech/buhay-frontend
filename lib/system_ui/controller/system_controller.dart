import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class SystemController {
  SystemController({required this.currentLocation});

  LatLng currentLocation;
  MapboxMap? mapboxMap;
  LatLng? markerPosition;

  void onMapCreated(MapboxMap map) {
    mapboxMap = map;
  }

  Future<void> setCurrentLocation(LatLng searchedLocation) async {
    final newLatLng = searchedLocation;
    if (mapboxMap != null) {
      flyToLocation(newLatLng);
      markerPosition = newLatLng;
      currentLocation = newLatLng;
    }
  }

  void flyToLocation(LatLng location) {
    currentLocation = location;
    mapboxMap?.flyTo(
      CameraOptions(
        center: Point.fromJson({
          'coordinates': [location.longitude, location.latitude]
        }),
        zoom: 15.0,
      ),
      MapAnimationOptions(duration: 500),
    );
  }

  Future<Offset?> getMarkerScreenPosition() async {
    if (mapboxMap != null && markerPosition != null) {
      final screenPoint = await mapboxMap!.pixelForCoordinate(Point.fromJson({
        'coordinates': [markerPosition!.longitude, markerPosition!.latitude]
      }));
      return Offset(screenPoint.x, screenPoint.y);
    }
    return null;
  }
}
