// import 'dart:convert';

// import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
// import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:uuid/uuid.dart';
// import 'package:flutter/material.dart';

class LocationData {
  final String id;
  LatLng location;

  LocationData({required this.id, required this.location});
}

class MapManualSearchController {
  MapManualSearchController();

  LatLng? startMarkerPosition;
  List<LocationData> locationDataList = [];
  int maxLocations = 5;
  int currentLocationCount = 0;

  // Route Request
  bool isValidManualSearchRequest() {
    return startMarkerPosition != null &&
        locationDataList.length <= 5 &&
        locationDataList.isNotEmpty;
  }

  void addLocation(LatLng location) {
    locationDataList.add(
      LocationData(
        id: const Uuid().v4(), // Generate a unique ID for each location
        location: location,
      ),
    );
    currentLocationCount++;
  }

  void removeLocationById(String id) {
    locationDataList.removeWhere((locationData) => locationData.id == id);
    currentLocationCount--;
  }

  void updateLocation(String id, LatLng newLocation) {
    for (var locationData in locationDataList) {
      if (locationData.id == id) {
        locationData.location = newLocation;
        break;
      }
    }
  }

  // Future<void> onSubmit(Future<Map<String, dynamic>> futureData) async {
  //   final data = await futureData;
  //   addPolylineLayer(data);
  // }
}
