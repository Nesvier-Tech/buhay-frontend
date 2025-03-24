import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginApi {
  // Switch localhost:8000 to 10.0.2.2:8000 because of android emulator
  var startURL = "http://10.0.2.2:8000";
  // var startURL = "https://buhay-backend-production.up.railway.app";

  Future<Map<String, dynamic>> getPing() async {
    print('API: Ping');
    final url = '$startURL/ping';
    final response = await http.get(
      Uri.parse(url),
    );
    print('response received');
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return {};
    }
  }

  Future<Map<String, dynamic>> getUser(Map<String, dynamic> credentials) async {
    final url = "$startURL/login";

    final body = json.encode({
      'username': credentials['username'],
      'password': credentials['password'],
    });

    // Temporary
    // return data;

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
      // return route;
    } else {
      return {};
    }
  }
}
