import 'package:buhay/system_ui/models.dart';
import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';

import '../rescuer/map_results_controller.dart';

class LocationData {
  final String id;
  LatLng location;

  LocationData({required this.id, required this.location});
}

class MapManualSearchController {
  final MapResultsController mapResultsController;
  List<Map<String, dynamic>> response = [];
  final int personID;

  MapManualSearchController(this.personID)
      : mapResultsController = MapResultsController();

  LatLng? startMarkerPosition;
  List<LocationData> locationDataList = [];
  int maxLocations = 5;
  int currentLocationCount = 0;

  // Route Request
  bool isValidManualSearchRequest() {
    if (startMarkerPosition == null) {
      return false;
    }

    if (locationDataList.isEmpty) {
      return false;
    }

    for (var data in locationDataList) {
      if (data.location == LatLng(0, 0)) {
        return false;
      }

      if (data.location == startMarkerPosition) {
        return false;
      }
    }

    for (var i = 0; i < locationDataList.length; i++) {
      for (var j = i + 1; j < locationDataList.length; j++) {
        if (locationDataList[i].location == locationDataList[j].location) {
          return false;
        }
      }
    }

    return true;
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

  Future<RouteRequest> manualSearchDataParsing() async {
    List<List<double>> locationCoordinatesList = [];

    for (var locationData in locationDataList) {
      locationCoordinatesList.add(
        [locationData.location.longitude, locationData.location.latitude],
      );
    }

    RouteRequest body = RouteRequest(
        startCoordinates: {
          "coordinates": [
            startMarkerPosition!.longitude,
            startMarkerPosition!.latitude
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

  Future<ConvertCoordinates> convertCoordinatesParsing() async {
    List<List<double>> locationCoordinatesList = [];

    for (var locationData in locationDataList) {
      locationCoordinatesList.add(
        [locationData.location.longitude, locationData.location.latitude],
      );
    }

    locationCoordinatesList.add(
      [startMarkerPosition!.longitude, startMarkerPosition!.latitude],
    );

    ConvertCoordinates body = ConvertCoordinates(
      coordinates: locationCoordinatesList
          .map((coords) => {
                'coordinates': [coords[0], coords[1]]
              })
          .toList()
          .cast<Map<String, List<double>>>(),
    );

    return body;
  }

  Future<AddRequest> addRequestParsing() async {
    List<List<double>> locationCoordinatesList = [];

    for (var locationData in locationDataList) {
      locationCoordinatesList.add(
        [locationData.location.longitude, locationData.location.latitude],
      );
    }

    locationCoordinatesList.add(
      [startMarkerPosition!.longitude, startMarkerPosition!.latitude],
    );

    AddRequest body = AddRequest(
      personID: personID,
      coordinates: locationCoordinatesList
          .map((coords) => {
                'coordinates': [coords[0], coords[1]]
              })
          .toList()
          .cast<Map<String, List<double>>>(),
    );

    return body;
  }

  Future<SaveRoute> saveRouteParsing(int requestId) async {
    RouteRequest points = await manualSearchDataParsing();
    SaveRoute body = SaveRoute(requestId: requestId, points: points);

    return body;
  }
}
