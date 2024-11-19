import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../controller/map_controller.dart';

class MapboxMapWidget extends StatefulWidget {
  const MapboxMapWidget(
      {super.key,
      required this.currentLocation,
      required this.setMap,
      required this.updateUI});

  final Function(MapboxMap) setMap;
  final LatLng currentLocation;
  final Function(void) updateUI;

  @override
  State<MapboxMapWidget> createState() => _MapboxMapWidgetState();
}

class _MapboxMapWidgetState extends State<MapboxMapWidget> {
  late final MapController mapController;
  late LatLng currentLocation;
  Offset? markerScreenPosition;

  @override
  void initState() {
    super.initState();
    currentLocation = widget.currentLocation;
    mapController = MapController(
      currentLocation: currentLocation,
      // marker: const Icon(Icons.location_on),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapWidget(
        cameraOptions: CameraOptions(
          center: Point.fromJson({
            'coordinates': [
              mapController.currentLocation.longitude,
              mapController.currentLocation.latitude
            ]
          }),
          zoom: 14.0,
          bearing: 0.0,
          pitch: 0.0,
        ),
        onMapCreated: (MapboxMap map) {
          mapController.onMapCreated(map);
          widget.setMap(map);
        },
        onCameraChangeListener: widget.updateUI,
      ),
    );
  }
}
