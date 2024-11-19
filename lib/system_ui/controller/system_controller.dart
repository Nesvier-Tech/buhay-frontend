import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class SystemController {
  SystemController({required this.currentLocation});

  LatLng currentLocation;
  MapboxMap? mapboxMap;
  LatLng? startMarkerPosition;
  LatLng? endMarkerPosition;

  void onMapCreated(MapboxMap map) {
    mapboxMap = map;
  }

  Future<void> setCurrentLocation(
      LatLng searchedLocation, bool isStartMarker) async {
    final newLatLng = searchedLocation;
    if (mapboxMap != null && isStartMarker) {
      startMarkerPosition = newLatLng;
      flyToLocation(newLatLng);
    } else if (mapboxMap != null && !isStartMarker) {
      endMarkerPosition = newLatLng;
      flyToLocation(newLatLng);
    }
    currentLocation = newLatLng;
  }

  void flyToLocation(LatLng location) {
    if (startMarkerPosition != null &&
        endMarkerPosition != null &&
        startMarkerPosition != endMarkerPosition) {
      // Calculate the midpoint
      final midpoint = LatLng(
        (startMarkerPosition!.latitude + endMarkerPosition!.latitude) / 2,
        (startMarkerPosition!.longitude + endMarkerPosition!.longitude) / 2,
      );

      // Calculate the distance between the two markers
      final distance = Distance().as(
        LengthUnit.Kilometer,
        startMarkerPosition!,
        endMarkerPosition!,
      );

      // Determine zoom level (approximate based on distance)
      double zoom;
      if (distance >= 5) {
        zoom = 11;
      } else if (distance >= 2) {
        zoom = 13;
      } else if (distance >= 1) {
        zoom = 14;
      } else {
        zoom = 16;
      }

      // Fly to the calculated center with determined zoom
      mapboxMap?.flyTo(
        CameraOptions(
          center: Point.fromJson({
            'coordinates': [midpoint.longitude, midpoint.latitude]
          }),
          zoom: zoom,
        ),
        MapAnimationOptions(duration: 500),
      );
    } else {
      currentLocation = location;
      mapboxMap?.flyTo(
        CameraOptions(
          center: Point.fromJson({
            'coordinates': [location.longitude, location.latitude]
          }),
          zoom: 16.0,
        ),
        MapAnimationOptions(duration: 500),
      );
    }
  }

  Future<Offset?> getMarkerScreenPosition(bool isStartMarker) async {
    if (isStartMarker && mapboxMap != null && startMarkerPosition != null) {
      final screenPoint = await mapboxMap!.pixelForCoordinate(Point.fromJson({
        'coordinates': [
          startMarkerPosition!.longitude,
          startMarkerPosition!.latitude
        ]
      }));
      return Offset(screenPoint.x, screenPoint.y);
    }

    if (!isStartMarker && mapboxMap != null && endMarkerPosition != null) {
      final screenPoint = await mapboxMap!.pixelForCoordinate(Point.fromJson({
        'coordinates': [
          endMarkerPosition!.longitude,
          endMarkerPosition!.latitude
        ]
      }));
      return Offset(screenPoint.x, screenPoint.y);
    }

    return null;
  }
}
