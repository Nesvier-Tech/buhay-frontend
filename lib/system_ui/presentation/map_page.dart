import 'package:buhay/env/env.dart';
import 'package:flutter/material.dart';
// import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:latlong2/latlong.dart';
import '../../features/mapbox/presentation/mapbox.dart';
import '../../features/map_search/presentation/search.dart';
import '../controller/system_controller.dart';
import '../../features/map_markers/presentation/start_map_marker.dart';
// import '../../features/map_markers/presentation/end_map_marker.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  String mapboxAccessToken = "";
  String googleToken = "";
  late SystemController systemController;

  @override
  void initState() {
    super.initState();
    mapboxAccessToken = Env.mapboxPublicAccessToken1;
    googleToken = Env.googleMapsApiKey1;

    systemController =
        SystemController(currentLocation: const LatLng(14.6539, 121.0685));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Stack(
            children: <Widget>[
              MapboxMapWidget(
                currentLocation: systemController.currentLocation,
                setMap: systemController.setMap,
              ),

              if (systemController.markerScreenPosition != null)
                Positioned(
                  left: systemController.markerScreenPosition!.dx - 20,
                  top: systemController.markerScreenPosition!.dy - 40,
                  child: StartMapMarker(),
                ),
              // const StartMapMarker(),
              // const EndMapMarker(),
              Column(
                children: <Widget>[
                  MapSearchWidget(
                      message: 'Choose starting location',
                      mapboxAccessToken: mapboxAccessToken,
                      googleToken: googleToken,
                      onSearch: systemController.setCurrentLocation),
                  //     MapSearchWidget(
                  //       message: 'Choose destination',
                  //       mapboxAccessToken: mapboxAccessToken,
                  //       googleToken: googleToken,
                  //  onSearch: systemController.setCurrentLocation),
                  //     ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
