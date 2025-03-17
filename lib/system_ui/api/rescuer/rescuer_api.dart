import 'dart:convert';
import 'package:http/http.dart' as http;

class RescuerApi {
  // var startURL = "http://10.0.2.2:8000";
  var startURL = "https://buhay-backend-production.up.railway.app";

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
