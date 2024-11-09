import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../api/database.dart';
import '../api/search_data.dart';

class NSTPMapController {
  final String mapboxAccessToken;
  late final SearchData searchData;
  late final DatabaseData databaseData;
  final Databases database = GetIt.I<Databases>();
  Client client = GetIt.I<Client>();
  MapboxMap? mapboxMap;
  LatLng currentLocation;
  LatLng? markerPosition;
  bool showSidebar = false;
  final String googleToken;

  NSTPMapController({
    required this.mapboxAccessToken,
    required this.currentLocation,
    required this.googleToken,
  }) {
    searchData = SearchData(mapboxAccessToken, googleToken);
    databaseData = DatabaseData(client, database);
  }

  void onMapCreated(MapboxMap map) {
    mapboxMap = map;
  }

  Future<void> searchPlace(String query) async {
    final newLatLng = await searchData.searchPlace(query);
    if (newLatLng != null && mapboxMap != null) {
      _flyToLocation(newLatLng);
      _updateMarkerAndSidebar(newLatLng);
    }
  }

  bool handleMapTap(MapContentGestureContext mapContext) {
    final point = mapContext.point;
    final tappedPoint = LatLng(
        point.coordinates[1]!.toDouble(), point.coordinates[0]!.toDouble());

    _updateMarkerAndSidebar(tappedPoint);
    return true;
  }

  void _flyToLocation(LatLng location) {
    currentLocation = location;
    mapboxMap?.flyTo(
      CameraOptions(
        center: Point.fromJson({
          'coordinates': [location.longitude, location.latitude]
        }),
        zoom: 15.0,
      ),
      MapAnimationOptions(duration: 1000),
    );
  }

  void _updateMarkerAndSidebar(LatLng location) {
    markerPosition = location;
    currentLocation = location;
    showSidebar = true;
  }

  Future<Offset?> getMarkerScreenPosition() async {
    if (mapboxMap != null && markerPosition != null) {
      final screenPoint = await mapboxMap!.pixelForCoordinate(Point.fromJson({
        'coordinates': [markerPosition!.longitude, markerPosition!.latitude]
      }));
      return Offset(screenPoint.x, screenPoint.y);
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getFloodData() async {
    return databaseData.fetchFloodData();
  }

  Future<List<Map<String, dynamic>>> getEvacSitesData() async {
    return databaseData.fetchEvacuationSitesData();
  }
}
