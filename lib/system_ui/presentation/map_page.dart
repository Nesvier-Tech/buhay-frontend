import 'package:buhay/env/env.dart';
import 'package:flutter/material.dart';
// import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:latlong2/latlong.dart';
import '../../features/mapbox/presentation/mapbox.dart';
import '../../features/map_search/presentation/search.dart';
// import '../../features/map_markers/presentation/start_map_marker.dart';
// import '../../features/map_markers/presentation/end_map_marker.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  String mapboxAccessToken = "";
  String googleToken = "";

  @override
  void initState() {
    super.initState();
    mapboxAccessToken = Env.mapboxPublicAccessToken1;
    googleToken = Env.googleMapsApiKey1;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Stack(
            children: <Widget>[
              MapboxMapWidget(
                currentLocation: LatLng(14.6539, 121.0685),
              ),
              // const StartMapMarker(),
              // const EndMapMarker(),
              Column(
                children: <Widget>[
                  MapSearchWidget(
                    message: 'Choose starting location',
                    mapboxAccessToken: mapboxAccessToken,
                    googleToken: googleToken,
                  ),
                  MapSearchWidget(
                    message: 'Choose destination',
                    mapboxAccessToken: mapboxAccessToken,
                    googleToken: googleToken,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
