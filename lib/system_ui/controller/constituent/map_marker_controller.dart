import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'map_interactive_search.dart';
import '../rescuer/map_results_controller.dart';

class MarkerController {
  // BANDAID SOLUTION TO DELETE MARKER BUG
  // bool delete = false;

  // To be assigned by paramters
  MapResultsController mapResultsController;
  MapInteractiveSearchController mapInteractiveSearchController;
  CircleAnnotationManager? circleAnnotationManager;
  VoidCallback? onMarkersUpdated;

  // Pass as parameters
  MarkerController(
      this.mapResultsController,
      this.mapInteractiveSearchController,
      this.circleAnnotationManager,
      this.onMarkersUpdated);

  // Properties to keep track of markers and coordinates
  int maxMarkers = 6;
  int markerCounter = 0;
  LatLng? startingPoint;
  List<LatLng> endPoints = [];

  int? markerColor;

  checkBounds(Position coords) async {
    double lat = coords.lat.toDouble();
    double lng = coords.lng.toDouble();
    LatLng position = LatLng(lat, lng);

    return await mapResultsController
        .getCheckCoordinatesIfWithinBounds(position);
  }

  ValueNotifier<int> markerCountNotifier = ValueNotifier<int>(0);
  void addMarker(Position coords) {
    if (canAddMarker()) {
      double lat = coords.lat.toDouble();
      double lng = coords.lng.toDouble();
      LatLng position = LatLng(lat, lng);

      // if (delete) {
      //   delete = !delete;
      //   return;
      // }

      if (startingPoint == null) {
        markerColor = Colors.blue.value;
        startingPoint = position;
        mapInteractiveSearchController.startMarkerPosition = position;
      } else {
        markerColor = Colors.red.value;
        endPoints.add(position);
        mapInteractiveSearchController.addLocation(position);
      }

      onMarkersUpdated?.call();

      markerCounter++;
      markerCountNotifier.value = markerCounter;

      CircleAnnotationOptions circleAnnotationOptions = CircleAnnotationOptions(
          geometry: Point(coordinates: coords),
          circleColor: markerColor,
          circleRadius: 12.0);
      circleAnnotationManager?.create(circleAnnotationOptions);

      circleAnnotationManager?.addOnCircleAnnotationClickListener(
          AnnotationClickListener(onAnnotationClick: (annotation) {
        deleteCircleAnnotation(annotation);
        onMarkersUpdated?.call();
      }));
    }
  }

  bool canAddMarker() => markerCounter < maxMarkers;

  // Deletes circle annotation
  deleteCircleAnnotation(CircleAnnotation annotation) async {
    Position coords = annotation.geometry.coordinates;
    double lat = coords.lat.toDouble();
    double lng = coords.lng.toDouble();
    LatLng currLatLng = LatLng(lat, lng);

    markerCounter -= 1;
    markerCountNotifier.value = markerCounter;

    if (currLatLng == startingPoint) {
      startingPoint = null;
    } else {
      endPoints.remove(currLatLng);
    }

    mapInteractiveSearchController.removeLocationByLatLng(currLatLng);

    // Notify BottomSheet of changes
    onMarkersUpdated?.call();

    circleAnnotationManager?.delete(annotation);

    // delete = true;
  }
}

// Allows OnClickListener to be added to Circle Annotations
class AnnotationClickListener extends OnCircleAnnotationClickListener {
  AnnotationClickListener({
    required this.onAnnotationClick,
  });

  final void Function(CircleAnnotation annotation) onAnnotationClick;

  @override
  void onCircleAnnotationClick(CircleAnnotation annotation) {
    onAnnotationClick(annotation);
  }
}
