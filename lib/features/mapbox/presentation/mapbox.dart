import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../../system_ui/controller/system_controller.dart';

class MapboxMapWidget extends StatefulWidget {
  const MapboxMapWidget({
    super.key,
    required this.systemController,
    required this.onCameraChangeListener,
  });

  final Function(CameraChangedEventData) onCameraChangeListener;
  final SystemController systemController;

  @override
  State<MapboxMapWidget> createState() => _MapboxMapWidgetState();
}

class _MapboxMapWidgetState extends State<MapboxMapWidget> {
  late LatLng currentLocation;
  Offset? markerScreenPosition;

  @override
  void initState() {
    super.initState();
    currentLocation = widget.systemController.currentLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapWidget(
        cameraOptions: CameraOptions(
          center: Point.fromJson({
            'coordinates': [
              widget.systemController.currentLocation.longitude,
              widget.systemController.currentLocation.latitude
            ]
          }),
          zoom: 14.0,
          bearing: 0.0,
          pitch: 0.0,
        ),
        onMapCreated: widget.systemController.onMapCreated,
        onCameraChangeListener: widget.onCameraChangeListener,
      ),
    );
  }
}
