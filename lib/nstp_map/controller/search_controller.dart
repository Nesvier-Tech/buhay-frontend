import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../api/search_data.dart';

class SearchController {
  final SearchData _searchData;
  final TextEditingController textController = TextEditingController();
  String get text => textController.text;
  ValueNotifier<List<String>> suggestions = ValueNotifier([]);

  SearchController(String accessToken, String googleToken)
      : _searchData = SearchData(accessToken, googleToken);

  Future<LatLng?> searchPlace(String query) async {
    return await _searchData.searchPlace(query);
  }

  void fetchSuggestions(String query) async {
    if (query.isEmpty) {
      suggestions.value = [];
      return;
    }

    final results = await _searchData.fetchFromMapbox(query);
    suggestions.value = results;
  }
}
