import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../api/search_api.dart';

class MapSearchController {
  final MapSearchApi _mapSearchApi;
  final TextEditingController textController = TextEditingController();
  String get text => textController.text;
  ValueNotifier<List<String>> suggestions = ValueNotifier([]);

  MapSearchController(String mapboxAccessToken, String googleToken)
      : _mapSearchApi = MapSearchApi(mapboxAccessToken, googleToken);

  Future<LatLng?> searchPlace(String query) async {
    return await _mapSearchApi.searchExactArea(query);
  }

  void getSuggestions(String query) async {
    if (query.isEmpty) {
      suggestions.value = [];
      return;
    }

    final results = await _mapSearchApi.getMapboxSuggestions(query);
    suggestions.value = results;
  }
}
