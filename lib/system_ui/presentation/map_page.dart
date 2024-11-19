import '../../env/env.dart';
import '../../features/mapbox/presentation/mapbox.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:latlong2/latlong.dart';

import '../../features/map_search/presentation/search.dart';
import '../controller/system_controller.dart';
import '../../features/map_markers/presentation/start_map_marker.dart';
import '../../features/map_markers/presentation/end_map_marker.dart';
import '../../features/map_submit/presentation/map_submit.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  String mapboxAccessToken = "";
  String googleToken = "";
  late SystemController systemController;
  Offset? startMarkerScreenPosition;
  Offset? endMarkerScreenPosition;

  @override
  void initState() {
    LatLng defaultLocation = const LatLng(14.6539, 121.0685);
    super.initState();
    mapboxAccessToken = Env.mapboxPublicAccessToken1;
    googleToken = Env.googleMapsApiKey1;

    systemController = SystemController(currentLocation: defaultLocation);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Stack(
            children: <Widget>[
              MapboxMapWidget(
                  systemController: systemController,
                  onCameraChangeListener: _onCameraChangeListener),
              if (startMarkerScreenPosition != null)
                Positioned(
                  left: startMarkerScreenPosition!.dx - 20,
                  top: startMarkerScreenPosition!.dy - 40,
                  child: StartMapMarker(),
                ),
              if (endMarkerScreenPosition != null)
                Positioned(
                  left: endMarkerScreenPosition!.dx - 20,
                  top: endMarkerScreenPosition!.dy - 40,
                  child: EndMapMarker(),
                ),
              Column(
                children: <Widget>[
                  MapSearchWidget(
                    message: 'Choose starting location',
                    mapboxAccessToken: mapboxAccessToken,
                    googleToken: googleToken,
                    onSearch: _searchPlace,
                    boxType: true,
                  ),
                  MapSearchWidget(
                    message: 'Choose destination',
                    mapboxAccessToken: mapboxAccessToken,
                    googleToken: googleToken,
                    onSearch: _searchPlace,
                    boxType: false,
                  ),
                  Spacer(),
                  if (systemController.isValidRouteRequest())
                    Padding(
                      padding: const EdgeInsets.only(bottom: 100.0),
                      child:
                          MapSubmitWidget(systemController: systemController),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onCameraChangeListener(CameraChangedEventData eventData) {
    _updateMarkerPosition();
  }

  void _searchPlace(LatLng location, bool isStartMarker) {
    systemController.setCurrentLocation(location, isStartMarker);
    setState(() {});
    _updateMarkerPosition();
  }

  void _updateMarkerPosition() async {
    final startScreenPosition =
        await systemController.getMarkerScreenPosition(true);
    final endScreenPosition =
        await systemController.getMarkerScreenPosition(false);
    setState(() {
      startMarkerScreenPosition = startScreenPosition;
      endMarkerScreenPosition = endScreenPosition;
    });
  }
}
