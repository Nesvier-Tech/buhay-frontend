import 'package:buhay/system_ui/controller/constituent/map_manual_search_controller.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:async/async.dart';

import '../../../env/env.dart';
import '../../../features/map_search/presentation/search.dart';
import '../../../features/map_check_coordinates/presentation/check_coordinate_dialog_box.dart';
import '../../controller/rescuer/map_results_controller.dart';
import '../login/otw.dart';
import 'map_dashboard.dart';
import '../../../features/map_error_dialog_box/presentation/map_error_dialog_box.dart';

class MapManualSearch extends StatefulWidget {
  final int personID;
  const MapManualSearch({super.key, required this.personID});

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

    mapManualSearchController = MapManualSearchController(widget.personID);
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
            title: const Text('Sending Request...'),
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
      var request = await mapManualSearchController.addRequestParsing();

      // Call the api for addRequest, response stores the response of the call (can be used to debug)
      var response = await mapManualSearchController
          .mapResultsController.mapResultsApi
          .addRequest(request);

      if (context.mounted) {
        // Pop twice so we can go back to dashboard when pressing the back arrow from the otw page
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();

        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MapDashboard(personID: mapManualSearchController.personID)),
        );
        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
              builder: (context) => OnTheWayPage(
                  requestId: response["request_id"],
                  mapManualSearchController: mapManualSearchController)),
        );
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

  Future<void> _showErrorDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MapConnectionErrorBox(controller: mapResultsController);
      },
    );
  }
}
