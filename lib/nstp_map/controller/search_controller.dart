import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../api/search_data.dart';

class SearchController {
  final SearchData _searchData;
  final TextEditingController textController = TextEditingController();
  String get text => textController.text;

  SearchController(String accessToken) : _searchData = SearchData(accessToken);

  Future<LatLng?> searchPlace(String query) async {
    return await _searchData.searchPlace(query);
  }
}
