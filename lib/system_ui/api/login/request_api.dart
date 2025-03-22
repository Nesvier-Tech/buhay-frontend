import 'package:http/http.dart' as http;
import 'dart:convert';

class RequestApi {
  // Switch localhost:8000 to 10.0.2.2:8000 because of android emulator
  var startURL = "http://10.0.2.2:8000";
  // var startURL = "https://buhay-backend-production.up.railway.app";

  Future<Map<String, dynamic>> getCoordinateNames(
      List<Map<String, dynamic>> body) async {
    final url = "$startURL/convert_coordinates";

    final response = await http.post(
      Uri.parse(url),
      body: body,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      return {};
    }
  }
}
