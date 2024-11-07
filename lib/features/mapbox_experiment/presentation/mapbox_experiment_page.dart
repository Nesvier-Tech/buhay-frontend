import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapboxExperimentPage extends StatelessWidget {
  const MapboxExperimentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapbox Experiment'),
      ),
      body: MapWidget(
        cameraOptions: CameraOptions(
          center: Point(coordinates: Position(121.0685, 14.6539)),
          zoom: 14.0,
          bearing: 0.0,
          pitch: 0.0,
        ),
      ),
    );
  }
}
