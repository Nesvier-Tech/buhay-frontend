import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:latlong2/latlong.dart';

class SearchData {
  final String accessToken;

  SearchData(this.accessToken);

  Future<LatLng?> searchPlace(String query) async {
    final url =
        'https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json?access_token=$accessToken&country=PH&fuzzyMatch=true&types=place,locality,neighborhood,address,poi&bbox=120.9903521,14.589369,121.1337681,14.7764137';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['features'].isNotEmpty) {
        final feature = data['features'][0];
        final coordinates = feature['center'];
        return LatLng(coordinates[1], coordinates[0]);
      }
    }
    return null;
  }
}
