import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class MapSubmitApi {
  Future<Map<String, dynamic>> getRouteCoordinates(
      LatLng start, LatLng end) async {
    // final url =
    // 'http://49.13.218.27:8080/directions?start=${start.longitude},${start.latitude}&end=${end.longitude},${end.latitude}';

    // To update the URL to the remote server
    final url = 'http://10.0.2.2:8000/directions';
    // final url = 'https://buhay-backend-production.up.railway.app/directions';

    final body = json.encode({
      'start': '${start.longitude},${start.latitude}',
      'end': '${end.longitude},${end.latitude}'
    });

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final route = data['geojson'];
      return route;
    } else {
      return {};
    }
  }
}
