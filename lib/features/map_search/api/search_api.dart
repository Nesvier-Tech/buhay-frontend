import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class MapSearchApi {
  MapSearchApi(this.mapboxAccessToken, this.googleToken);

  final String mapboxAccessToken;
  final String googleToken;

  Future<LatLng?> searchExactArea(String query) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$query&bounds=14.589369,120.9903521|14.7764137,121.1337681&key=$googleToken';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['results'].isNotEmpty) {
        final feature = data['results'][0];
        final coordinates = feature['geometry']['location'];
        return LatLng(coordinates["lat"], coordinates["lng"]);
      }
    }
    return null;
  }

  Future<List<String>> getMapboxSuggestions(String query) async {
    final url =
        'https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json?access_token=$mapboxAccessToken&autocomplete=true&country=PH&fuzzyMatch=true&types=place,locality,neighborhood,address,poi&bbox=120.9903521,14.589369,121.1337681,14.7764137';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final features = data['features'];
      return features.map<String>((feature) {
        final placeName = feature['place_name'];
        return placeName is String ? placeName : '';
      }).toList();
    } else {
      return [];
    }
  }
}
