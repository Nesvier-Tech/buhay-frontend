import '../api/system_results_api.dart';

class MapResultsController {
  MapResultsController() : mapResultsApi = MapResultsAPI();

  final MapResultsAPI mapResultsApi;

  // New public list to store the route results
  List<Map<String, dynamic>> routes = [];

  Future<List<Map<String, dynamic>>> getRoute() async {
    // TODO: Implement with the API request body
    routes = await mapResultsApi.getRoutes();
    return routes;
  }
}
