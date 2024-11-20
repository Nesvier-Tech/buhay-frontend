import 'package:latlong2/latlong.dart';

import '../api/map_submit_api.dart';

class MapSubmitController {
  MapSubmitController() : mapSubmitApi = MapSubmitApi();

  final MapSubmitApi mapSubmitApi;

  Future<Map<String, dynamic>> getRoute(
      LatLng? startMarkerPosition, LatLng? endMarkerPosition) async {
    return await mapSubmitApi.getRouteCoordinates(
        startMarkerPosition!, endMarkerPosition!);
  }
}
