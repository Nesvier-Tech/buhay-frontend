import 'package:buhay/system_ui/controller/map_manual_search_controller.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:async/async.dart';

import '../../env/env.dart';
import '../../features/map_search/presentation/search.dart';
import '../../features/map_check_coordinates/presentation/check_coordinate_dialog_box.dart';
import '../controller/map_results_controller.dart';
// import 'map_result.dart';
import '../../features/map_error_dialog_box/presentation/map_error_dialog_box.dart';

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
  late RestartableTimer timer;

  @override
  void initState() {
    super.initState();
    mapboxAccessToken = Env.mapboxPublicAccessToken1;
    googleToken = Env.googleMapsApiKey1;

    mapManualSearchController = MapManualSearchController();
    mapResultsController = MapResultsController();

    mapResultsController.checkIfConnected();
    timer = RestartableTimer(Duration(milliseconds: 500), () {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: const Text('Manual Route Search'),
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
            const SizedBox(height: 16),

            const Text(
              "Locations to Visit",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Dynamically display MapSearchWidgets based on locationDataList
            for (var locationData in mapManualSearchController.locationDataList)
              Row(
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
                    icon: Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        mapManualSearchController
                            .removeLocationById(locationData.id);
                      });
                    },
                  ),
                ],
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
                    : 'Please fill in all required fields to submit the route. Ensure each location is unique.',
                child: ElevatedButton(
                  onPressed:
                      mapManualSearchController.isValidManualSearchRequest()
                          ? _onSubmitRoute
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
    if (!(await mapResultsController.checkIfConnected())) {
      _showErrorDialog();
      return;
    }

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
  void _onSubmitRoute() async {
    if (timer.isActive) {
      timer.reset();
    } else {
      timer = RestartableTimer(Duration(milliseconds: 500), _submitAction);
    }
  }

  void _submitAction() async {
    try {
      if (!(await mapResultsController.checkIfConnected())) {
        _showErrorDialog();
        return;
      }

      showDialog<AlertDialog>(
        // ignore: use_build_context_synchronously
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

      // ignore: unused_local_variable
      var parsedBody =
          await mapManualSearchController.manualSearchDataParsing();

      await mapResultsController.getRoute(parsedBody);

      if (context.mounted) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      }

      // if (mounted) {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => MapResultPage(
      //               mapResultsController: mapResultsController,
      //             )),
      //   );
      // }
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

  Future<void> _showErrorDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MapConnectionErrorBox(controller: mapResultsController);
      },
    );
  }
}
