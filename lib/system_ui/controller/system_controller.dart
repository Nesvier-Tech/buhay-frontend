import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:uuid/uuid.dart';

class SystemController {
  SystemController({required this.currentLocation});

  LatLng currentLocation;
  MapboxMap? mapboxMap;
  LatLng? startMarkerPosition;
  LatLng? endMarkerPosition;
  String uniqueId = Uuid().v4();
  String startMarkerId = '';
  String endMarkerId = '';

  // Initialization
  void onMapCreated(MapboxMap map) {
    mapboxMap = map;
  }

  // Location Camera Setting
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

  Map<dynamic, dynamic> calculateMidpoint(
      startLatitude, startLongitude, endLatitude, endLongitude) {
    // Calculate the midpoint
    final midpoint = LatLng(
      (startLatitude + endLatitude) / 2,
      (startLongitude + endLongitude) / 2,
    );

    // Calculate the distance between the two markers
    final distance = Distance().as(
      LengthUnit.Kilometer,
      LatLng(startLatitude, startLongitude),
      LatLng(endLatitude, endLongitude),
    );

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

    return {
      'midpoint': midpoint,
      'zoom': zoom,
    };
  }

  void flyOperation(longitude, latitude, zoom) {
    mapboxMap?.flyTo(
      CameraOptions(
        center: Point.fromJson({
          'coordinates': [longitude, latitude]
        }),
        zoom: zoom,
      ),
      MapAnimationOptions(duration: 500),
    );
  }

  // Marker Drawing
  void flyToLocation(LatLng location) {
    if (startMarkerPosition != null &&
        endMarkerPosition != null &&
        startMarkerPosition != endMarkerPosition) {
      final midpointData = calculateMidpoint(
          startMarkerPosition!.latitude,
          startMarkerPosition!.longitude,
          endMarkerPosition!.latitude,
          endMarkerPosition!.longitude);
      final midpoint = midpointData['midpoint'];
      final zoom = midpointData['zoom'];

      flyOperation(midpoint.longitude, midpoint.latitude, zoom);

      // Determine zoom level (approximate based on distance)
      // Fly to the calculated center with determined zoom
    } else {
      currentLocation = location;
      flyOperation(location.longitude, location.latitude, 16.0);
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

  // Route Request
  bool isValidRouteRequest() {
    return startMarkerPosition != null &&
        endMarkerPosition != null &&
        startMarkerPosition != endMarkerPosition;
  }

  // Route Drawing
  Future<void> clearRoute(String layerId) async {
    if (mapboxMap != null) {
      await mapboxMap!.style.removeStyleLayer(layerId);
      await mapboxMap!.style.removeStyleSource(layerId);
    }
  }

  Future<void> onSubmit(Future<Map<String, dynamic>> futureData) async {
    final data = await futureData;
    addPolylineLayer(data);
  }

  void addPolylineLayer(Map<String, dynamic> data) async {
    if (mapboxMap != null) {
      uniqueId = Uuid().v4();

      await mapboxMap!.style.addSource(
        GeoJsonSource(
          id: uniqueId,
          data: jsonEncode(data),
        ),
      );
      await mapboxMap!.style.addLayer(LineLayer(
          id: uniqueId,
          sourceId: uniqueId,
          lineJoin: LineJoin.ROUND,
          lineCap: LineCap.ROUND,
          lineColor: Colors.blue.value,
          lineWidth: 6.0));

      // await clearRoute(uniqueId);
    }
  }

  void addCircleAnnotation(LatLng position, String id, Color color) async {
    if (mapboxMap != null) {
      await mapboxMap!.style.addSource(
        GeoJsonSource(
          id: id,
          data: jsonEncode({
            'type': 'Feature',
            'geometry': {
              'type': 'Point',
              'coordinates': [position.longitude, position.latitude],
            },
          }),
        ),
      );

      await mapboxMap!.style.addLayer(CircleLayer(
        id: id,
        sourceId: id,
        circleRadius: 8.0,
        circleColor: color.value,
      ));
    }
  }

  Future<void> removeCircleAnnotation(String id) async {
    if (mapboxMap != null) {
      await mapboxMap!.style.removeStyleLayer(id);
      await mapboxMap!.style.removeStyleSource(id);
    }
  }

  // Method to generate unique IDs for markers
  void generateMarkerIds() {
    startMarkerId = Uuid().v4();
    endMarkerId = Uuid().v4();
  }
}
