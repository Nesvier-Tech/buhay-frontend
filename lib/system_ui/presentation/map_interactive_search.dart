import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../controller/map_interactive_search.dart';
import '../controller/map_results_controller.dart';
import '../../features/map_check_coordinates/presentation/check_coordinate_dialog_box.dart';
import '../controller/map_marker_controller.dart';
import 'bottom_sheet.dart';

class InteractiveSearch extends StatefulWidget {
  const InteractiveSearch({super.key});

  @override
  State createState() => InteractiveSearchState();
}

class InteractiveSearchState extends State<InteractiveSearch> {
  late MapboxMap mapboxMap;
  late MapResultsController mapResultsController;
  late MapManualSearchController mapManualSearchController;
  MarkerController? markerController;
  CircleAnnotationManager? circleAnnotationManager;

  // Callback to notify BottomSheet of changes
  VoidCallback? onMarkersUpdated;

  @override
  void initState() {
    super.initState();

    mapManualSearchController = MapManualSearchController();
    mapResultsController = MapResultsController();
  }

  // Initializes circleAnnotationManager for adding circles
  _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;
    circleAnnotationManager =
        await mapboxMap.annotations.createCircleAnnotationManager();
    markerController = MarkerController(mapResultsController,
        mapManualSearchController, circleAnnotationManager, onMarkersUpdated);
  }

  // Adds circle at tapped coordinate on map
  Future<void> _onTap(
      MapContentGestureContext mapContext, BuildContext buildContext) async {
    Position coords = mapContext.point.coordinates;

    // Check if coords is valid (within QC)
    var response = await markerController!.checkBounds(coords);

    // Check if the location is outside bounds
    if (response['message'] == "false") {
      if (mounted) {
        await showDialog<AlertDialog>(
          context: buildContext,
          builder: (BuildContext context) {
            return CheckCoordinateDialogBox();
          },
        );
      }
      return; // Exit the method if out of bounds
    }

    markerController?.addMarker(coords);

    setState(() {}); // Updates UI
  }

  @override
  Widget build(BuildContext context) {
    // Define options for your camera
    CameraOptions camera = CameraOptions(
        center:
            Point(coordinates: Position(121.0685447248227, 14.648899347751673)),
        zoom: 16,
        bearing: 0,
        pitch: 0);

    // Overlap the BottomSheet in front of the map
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: const Text('Interactive Search'),
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black)),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          MapWidget(
            cameraOptions: camera,
            onTapListener: (MapContentGestureContext gestureContext) =>
                _onTap(gestureContext, context),
            onMapCreated: _onMapCreated,
          ),
          CustomBottomSheet(markerController: markerController),
        ],
      ),
    );
  }
}
