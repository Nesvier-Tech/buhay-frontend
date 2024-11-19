import 'package:buhay/env/env.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:latlong2/latlong.dart';

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
  Offset? markerScreenPosition;

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
              MapWidget(
                cameraOptions: CameraOptions(
                  center: Point.fromJson({
                    'coordinates': [
                      systemController.currentLocation.longitude,
                      systemController.currentLocation.latitude
                    ]
                  }),
                  zoom: 14.0,
                  bearing: 0.0,
                  pitch: 0.0,
                ),
                onMapCreated: systemController.onMapCreated,
                onCameraChangeListener: _onCameraChangeListener,
              ),
              if (markerScreenPosition != null)
                Positioned(
                  left: markerScreenPosition!.dx - 20,
                  top: markerScreenPosition!.dy - 40,
                  child: StartMapMarker(),
                ),
              Column(
                children: <Widget>[
                  MapSearchWidget(
                      message: 'Choose starting location',
                      mapboxAccessToken: mapboxAccessToken,
                      googleToken: googleToken,
                      onSearch: _searchPlace),
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

  void _onCameraChangeListener(CameraChangedEventData eventData) {
    _updateMarkerPosition();
  }

  void _searchPlace(LatLng location) {
    systemController.setCurrentLocation(location);
    setState(() {});
    _updateMarkerPosition();
  }

  void _updateMarkerPosition() async {
    final screenPosition = await systemController.getMarkerScreenPosition();
    setState(() {
      markerScreenPosition = screenPosition;
    });
  }
}
