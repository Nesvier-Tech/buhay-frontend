import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

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

  Future<List<Map<String, dynamic>>> getRoutes() async {
    final url = '$startURL/test';

    // final body = json.encode({
    //   'start': '${start.longitude},${start.latitude}',
    //   'end': '${end.longitude},${end.latitude}'
    // });

    // final response = await http.post(
    //   Uri.parse(url),
    //   headers: {
    //     'Content-Type': 'application/json',
    //   },
    //   body: body,
    // );

    final response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> routes = data['routes'];

      // Cast the List<dynamic> to List<Map<String, dynamic>>
      return List<Map<String, dynamic>>.from(routes);
    } else {
      return [{}];
    }
  }
}
