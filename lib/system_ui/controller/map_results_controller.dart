import '../api/system_results_api.dart';
import 'package:latlong2/latlong.dart';
import '../models.dart';

class MapResultsController {
  MapResultsController() : mapResultsApi = MapResultsAPI();

  final MapResultsAPI mapResultsApi;

  // New public list to store the route results
  List<Map<String, dynamic>> routes = [];

  Future<List<Map<String, dynamic>>> getRoute(RouteRequest body) async {
    routes = await mapResultsApi.getRoutes(body);
    return routes;
  }

  Future<List<Map<String, dynamic>>> testRoutes() async {
    routes = await mapResultsApi.testRoutes();
    return routes;
  }

  Future<Map<String, dynamic>> getPing() async {
    return await mapResultsApi.getPing();
  }

  Future<Map<String, dynamic>> getCheckCoordinatesIfWithinBounds(
      LatLng point) async {
    return await mapResultsApi.getcheckCoordinatesIfWithinBounds(point);
  }
}
