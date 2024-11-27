import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class MapSubmitApi {
  Future<Map<String, dynamic>> getRouteCoordinates(
      LatLng start, LatLng end) async {
    // TODO: update the URL to match server
    final url =
        'http://10.0.2.2:8000/directions?start=${start.longitude},${start.latitude}&end=${end.longitude},${end.latitude}';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final route = data['geojson'];
      return route;
    } else {
      return {};
    }
  }
}