import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MarkerController {
  MarkerController({required this.currentLocation});

  LatLng currentLocation;
  MapboxMap? mapboxMap;
  LatLng? markerPosition;

  Future<Offset?> getMarkerScreenPosition(currentLocation) async {
    if (mapboxMap != null && markerPosition != null) {
      final screenPoint = await mapboxMap!.pixelForCoordinate(Point.fromJson({
        'coordinates': [markerPosition!.longitude, markerPosition!.latitude]
      }));
      return Offset(screenPoint.x, screenPoint.y);
    }
    return null;
  }
}
