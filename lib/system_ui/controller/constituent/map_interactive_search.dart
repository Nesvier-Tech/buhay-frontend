import '../../models.dart';
import 'package:latlong2/latlong.dart';
// import 'package:uuid/uuid.dart';

import '../rescuer/map_results_controller.dart';

class LocationData {
  final String id;
  LatLng location;

  LocationData({required this.id, required this.location});
}

class MapInteractiveSearchController {
  final MapResultsController mapResultsController;
  List<Map<String, dynamic>> response = [];
  final int personID;

  MapInteractiveSearchController(this.personID)
      : mapResultsController = MapResultsController();

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

  Future<RouteRequest> interactiveSearchDataParsing() async {
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

  Future<ConvertCoordinates> convertCoordinatesParsing() async {
    List<List<double>> locationCoordinatesList = [];

    for (var locationData in locationDataList) {
      locationCoordinatesList.add(
        [locationData.longitude, locationData.latitude],
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
        [locationData.longitude, locationData.latitude],
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
    RouteRequest points = await interactiveSearchDataParsing();
    SaveRoute body = SaveRoute(requestId: requestId, points: points);

    return body;
  }
}
