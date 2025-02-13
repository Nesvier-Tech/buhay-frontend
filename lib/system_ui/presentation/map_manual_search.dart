import 'package:buhay/system_ui/controller/map_manual_search_controller.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../../env/env.dart';
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
        title: const Text('Manual Route Search'),
        centerTitle: true, // Centers the title for better balance
      ),
      body: Padding(
        padding: const EdgeInsets.all(
            16.0), // Adds consistent padding around the content
        child: ListView(
          children: <Widget>[
            const Text(
              "Start Location",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Starting Location Input
            MapSearchWidget(
              message: "Choose a Starting Location",
              mapboxAccessToken: mapboxAccessToken,
              googleToken: googleToken,
              onSearch: (LatLng location, bool isStartMarker) =>
                  _searchPlace(location, true, null),
              boxType: true,
            ),
            const SizedBox(
                height:
                    16), // Adds spacing between widgets for better readability

            const Text(
              "Locations to Visit",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Dynamically display MapSearchWidgets based on locationDataList
            for (var locationData in mapManualSearchController.locationDataList)
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 2.0), // Adds vertical spacing
                child: Row(
                  key: ValueKey(locationData.id),
                  children: [
                    Expanded(
                      child: MapSearchWidget(
                        message: 'Choose another location',
                        mapboxAccessToken: mapboxAccessToken,
                        googleToken: googleToken,
                        onSearch: (LatLng location, bool isStartMarker) =>
                            _searchPlace(location, false, locationData.id),
                        boxType: false,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_circle,
                          color:
                              Colors.red), // Adds a color to indicate removal
                      onPressed: () {
                        setState(() {
                          mapManualSearchController
                              .removeLocationById(locationData.id);
                        });
                      },
                    ),
                  ],
                ),
              ),

            // Add Another Location Button
            if (mapManualSearchController.locationDataList.length <
                mapManualSearchController.maxLocations)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      mapManualSearchController.addLocation(LatLng(0, 0));
                    });
                  },
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Another Location'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                  ),
                ),
              ),

            // Submit Route Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Tooltip(
                message: mapManualSearchController.isValidManualSearchRequest()
                    ? ''
                    : 'Please fill in all required fields to submit the route.',
                child: ElevatedButton(
                  onPressed:
                      mapManualSearchController.isValidManualSearchRequest()
                          ? () {}
                          : null, // Make button unclickable
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                  ),
                  child: const Text(
                    "Submit Route",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Search Place Function
  void _searchPlace(LatLng location, bool isStartMarker, String? id) async {
    var response =
        await mapResultsController.getCheckCoordinatesIfWithinBounds(location);

    if (response['message'] == "false") {
      if (mounted) {
        await showDialog<AlertDialog>(
          context: context,
          builder: (BuildContext context) {
            return const CheckCoordinateDialogBox();
          },
        );
      }
      return;
    }

    if (isStartMarker) {
      mapManualSearchController.startMarkerPosition = location;
    } else if (id != null) {
      mapManualSearchController.updateLocation(id, location);
    }

    setState(() {});
  }

  // Submit Route Function
  void _onSubmitRoute(Future<Map<String, dynamic>> futureData) async {
    try {
      showDialog<AlertDialog>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Calculating Route...'),
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
        Navigator.of(context).pop();
        // TODO: PUSH MAP RESULTS PAGE
      }
    } catch (e) {
      await showDialog<AlertDialog>(
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
