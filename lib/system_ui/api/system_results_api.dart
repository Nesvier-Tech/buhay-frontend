import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../models.dart';

class MapResultsAPI {
  var startURL = "http://10.0.2.2:8000";

  Future<Map<String, dynamic>> getcheckCoordinatesIfWithinBounds(
      LatLng point) async {
    final url = '$startURL/checkCoordinates';

    final body = json.encode({
      'coordinates': [point.longitude, point.latitude],
    });

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {};
    }
  }

  Future<Map<String, dynamic>> getPing() async {
    final url = '$startURL/ping';
    final response = await http.get(
      Uri.parse(url),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {};
    }
  }

  Future<List<Map<String, dynamic>>> getRoutes(RouteRequest body) async {
    final url = '$startURL/tsp';

    final requestBody = json.encode({
      'start': body.start,
      'other_points': body.otherPoints,
    });

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: requestBody,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> routes = data;

      // TODO: Implement the logic to parse the response
      return List<Map<String, dynamic>>.from(routes);
    } else {
      return [{}];
    }
  }

  Future<List<Map<String, dynamic>>> testRoutes() async {
    // FOR DELETION SINCE THIS IS JUST A DUMMY ENDPOINT
    final url = '$startURL/test';

    final response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> routes = data['routes'];

      return List<Map<String, dynamic>>.from(routes);
    } else {
      return [{}];
    }
  }
}
