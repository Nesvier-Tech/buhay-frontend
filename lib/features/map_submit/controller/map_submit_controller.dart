import 'package:get_it/get_it.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';

import '../api/map_submit_api.dart';

class MapSubmitController {
  MapSubmitController() : mapSubmitApi = MapSubmitApi();

  final MapSubmitApi mapSubmitApi;

  Future<List> getRoute(
      LatLng? startMarkerPosition, LatLng? endMarkerPosition) async {
    final test = await mapSubmitApi.getRouteCoordinates(
        startMarkerPosition!, endMarkerPosition!);
    GetIt.I<Logger>().d('Route: $test');
    return test;
  }
}
