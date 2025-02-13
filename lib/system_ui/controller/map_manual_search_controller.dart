import 'package:latlong2/latlong.dart';
import 'package:uuid/uuid.dart';

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

  // Future<void> onSubmit(Future<Map<String, dynamic>> futureData) async {}
}
