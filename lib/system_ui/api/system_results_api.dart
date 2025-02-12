import 'dart:convert';
import 'package:http/http.dart' as http;

class MapResultsAPI {
  Future<Map<String, dynamic>> getPing() async {
    // To update the URL to the remote server
    final url = 'http://10.0.2.2:8000/ping';
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
    // To update the URL to the remote server
    final url = 'http://10.0.2.2:8000/test';

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
