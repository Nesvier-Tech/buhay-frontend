import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class SystemController {
  SystemController({required this.currentLocation});

  LatLng currentLocation;
  MapboxMap? mapboxMap;
  Offset? markerScreenPosition;

  Future<void> setCurrentLocation(LatLng searchedLocation) async {
    currentLocation = searchedLocation;
    if (mapboxMap != null) {
      flyToLocation(currentLocation);
      markerScreenPosition = await getMarkerScreenPosition(currentLocation);
    }
    GetIt.I<Logger>().d('Current location: $currentLocation');
  }

  void setMap(MapboxMap map) {
    mapboxMap = map;
    GetIt.I<Logger>().d('Map Created');
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

  Future<Offset> getMarkerScreenPosition(LatLng location) async {
    final screenPoint = await mapboxMap!.pixelForCoordinate(Point.fromJson({
      'coordinates': [location.longitude, location.latitude]
    }));
    GetIt.I<Logger>().d('Marker Screen Position: $screenPoint');
    return Offset(screenPoint.x, screenPoint.y);
  }
}
