import 'package:buhay/system_ui/controller/map_manual_search_controller.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../env/env.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../../features/map_search/presentation/search.dart';
import '../../features/map_check_coordinates/presentation/check_coordinate_dialog_box.dart';
import '../controller/system_results_controller.dart';

class MapManualSearch extends StatefulWidget {
  const MapManualSearch({super.key});

  @override
  State<MapManualSearch> createState() => _MapManualSearchState();
}

class _MapManualSearchState extends State<MapManualSearch> {
  String mapboxAccessToken = "";
  String googleToken = "";
  late MapManualSearchController mapManualSearchController;
  late MapResultsController mapResultsController;
  Offset? startMarkerScreenPosition;
  Offset? endMarkerScreenPosition;

  @override
  void initState() {
    super.initState();
    mapboxAccessToken = Env.mapboxPublicAccessToken1;
    googleToken = Env.googleMapsApiKey1;

    mapManualSearchController = MapManualSearchController();
    mapResultsController = MapResultsController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Single Search Page'),
      ),
      body: ListView(
        children: <Widget>[
          MapSearchWidget(
            message: "Choose a Starting Location",
            mapboxAccessToken: mapboxAccessToken,
            googleToken: googleToken,
            onSearch: (LatLng location, bool isStartMarker) => _searchPlace,
            boxType: true,
          ),

          // Dynamically display MapSearchWidgets based on locationDataList
          for (var locationData in mapManualSearchController.locationDataList)
            Row(
              key: ValueKey(locationData.id), // Use unique ID as the key
              children: [
                Expanded(
                  child: MapSearchWidget(
                    message: 'Choose another location',
                    mapboxAccessToken: mapboxAccessToken,
                    googleToken: googleToken,
                    onSearch: (LatLng location, bool isStartMarker) =>
                        _searchPlace(
                            location, false, locationData.id), // Pass the ID
                    boxType: false,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.remove_circle),
                  onPressed: () {
                    setState(() {
                      mapManualSearchController
                          .removeLocationById(locationData.id);
                    });
                  },
                ),
              ],
            ),

          if (mapManualSearchController.locationDataList.length <
              mapManualSearchController.maxLocations)
            ElevatedButton(
              onPressed: () {
                setState(() {
                  mapManualSearchController
                      .addLocation(LatLng(0, 0)); // Add a new location
                });
              },
              child: const Text('Add Another Location'),
            ),

          if (mapManualSearchController.isValidManualSearchRequest())
            ElevatedButton(onPressed: () {}, child: const Text("Submit Route")),
        ],
      ),
    );
  }

  void _searchPlace(LatLng location, bool isStartMarker, String? id) async {
    var response =
        await mapResultsController.getCheckCoordinatesIfWithinBounds(location);

    if (response['message'] == "false") {
      if (mounted) {
        await showDialog<AlertDialog>(
          context: context,
          builder: (BuildContext context) {
            return CheckCoordinateDialogBox();
          },
        );
      }
      return; // Exit if the location is out of bounds
    }

    if (isStartMarker) {
      mapManualSearchController.startMarkerPosition =
          location; // Set start marker position
    } else if (id != null) {
      mapManualSearchController.updateLocation(
          id, location); // Update location by ID
    }

    setState(() {}); // Refresh the UI
  }

  void _onSubmitRoute(Future<Map<String, dynamic>> futureData) async {
    try {
      showDialog<AlertDialog>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Calculating Route...'),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                LoadingAnimationWidget.discreteCircle(
                  color: Theme.of(context).colorScheme.primary,
                  size: 100.0,
                ),
              ],
            ),
          );
        },
      );

      // TODO: IMPLEMENT FOR MULTISEARCH ENDPOINT
      // await systemController.onSubmit(futureData);

      if (context.mounted) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();

        // TODO: PUSH MAP RESULTS PAGE
      }
    } catch (e) {
      await showDialog<AlertDialog>(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text(e.toString()),
            actions: <TextButton>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
