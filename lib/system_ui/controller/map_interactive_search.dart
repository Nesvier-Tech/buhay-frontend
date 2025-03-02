import '../models.dart';
import 'package:latlong2/latlong.dart';
// import 'package:uuid/uuid.dart';

import 'map_results_controller.dart';

class LocationData {
  final String id;
  LatLng location;

  LocationData({required this.id, required this.location});
}

class MapManualSearchController {
  final MapResultsController mapResultsController;
  List<Map<String, dynamic>> response = [];

  MapManualSearchController() : mapResultsController = MapResultsController();

  LatLng? startMarkerPosition;
  List<LatLng> locationDataList = [];
  int maxLocations = 5;
  int currentLocationCount = 0;

  void addStartLocation(LatLng location) {
    startMarkerPosition = location;
  }

  void addLocation(LatLng location) {
    locationDataList.add(location);
    currentLocationCount++;
  }

  void removeLocationByLatLng(LatLng coords) {
    if (coords == startMarkerPosition) {
      startMarkerPosition = null;
    }
    locationDataList.removeWhere((locationData) => locationData == coords);
    currentLocationCount--;
  }

  Future<RouteRequest> manualSearchDataParsing() async {
    List<List<double>> locationCoordinatesList = [];

    for (var locationData in locationDataList) {
      locationCoordinatesList.add(
        [locationData.longitude, locationData.latitude],
      );
    }

    RouteRequest body = RouteRequest(
        startCoordinates: {
          "coordinates": [
            startMarkerPosition!.longitude,
            startMarkerPosition!.latitude,
          ]
        },
        otherPointsCoordinates: locationCoordinatesList
            .map((coords) => {
                  'coordinates': [coords[0], coords[1]]
                })
            .toList()
            .cast<Map<String, List<double>>>());

    return body;
  }
}
