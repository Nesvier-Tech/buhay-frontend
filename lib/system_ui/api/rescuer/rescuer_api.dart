import 'dart:convert';
import 'package:http/http.dart' as http;

class RescuerApi {
  var startURL = "http://10.0.2.2:8000";
  // var startURL = "https://buhay-backend-production.up.railway.app";

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

  Future<List<Map<String, dynamic>>> getRouteInfoApi(String routeInfoId) async {
    final url = '$startURL/get_route_info';

    final requestBody = json.encode({
      'route_info_id': routeInfoId,
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
      final List<dynamic> routes = data['routes'];

      return List<Map<String, dynamic>>.from(routes);
    } else {
      return [{}];
    }
  }

  Future<void> updateRescuedApi(String requestId) async {
    final url = '$startURL/update_rescued';

    final requestBody = json.encode({
      'request_id': requestId,
    });

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: requestBody,
    );

    if (response.statusCode == 200) {
      return;
    } else {
      return;
    }
  }
}
