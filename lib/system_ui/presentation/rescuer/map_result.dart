// import 'package:buhay/system_ui/controller/map_results_controller.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:buhay/system_ui/controller/rescuer/rescuer_controller.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../../../system_ui/controller/system_controller.dart';
import 'package:async/async.dart';
import '../../../features/map_error_dialog_box/presentation/map_error_dialog_box.dart';

import 'package:latlong2/latlong.dart';

class MapResultPage extends StatefulWidget {
  final RescuerController rescuerController;
  final String? requestId;

  const MapResultPage(
      {super.key, required this.rescuerController, this.requestId});

  @override
  MapResultPageState createState() => MapResultPageState();
}

class MapResultPageState extends State<MapResultPage> {
  late SystemController systemController;
  late String requestId;
  late RestartableTimer timer;

  @override
  void initState() {
    super.initState();
    LatLng defaultLocation = const LatLng(14.6539, 121.0685);

    systemController = SystemController(currentLocation: defaultLocation);
    if (widget.requestId != null) {
      print('Request ID: ${widget.requestId}');
      requestId = widget.requestId!;
    } else {
      requestId = "";
    }

    timer = RestartableTimer(Duration(milliseconds: 500), () {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text('Map Results'),
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black)),
      body: Stack(
        children: [
          MapWidget(
            onMapCreated: systemController.onMapCreated,
            cameraOptions: CameraOptions(
              center: Point(coordinates: Position(121.0685, 14.6539)),
              zoom: 14.0,
              bearing: 0.0,
              pitch: 0.0,
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.2,
            minChildSize: 0.15,
            maxChildSize: 0.60,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                margin: const EdgeInsets.only(top: 8.0),
                width: 30.0,
                height: 3.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...widget.rescuerController.routes.map((location) {
                        return ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Left column: Coordinates
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Location ${widget.rescuerController.routes.indexOf(location) + 1}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "Start: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(
                                            text:
                                                // "${location['start'][0].toStringAsFixed(7)},${location['start'][1].toStringAsFixed(7)}\n",
                                                "${location['start']}\n",
                                          ),
                                          TextSpan(
                                            text: "End: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(
                                            text:
                                                // "${location['end'][0].toStringAsFixed(7)},${location['end'][1].toStringAsFixed(7)}\n",
                                                "${location['end']}\n",
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Right column: Distance
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Wrap the distance in a Column to separate the number and the unit
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${location['data']['route']['distanceKm'].toStringAsFixed(2)}", // Rounding to 2 decimal places
                                        style: TextStyle(
                                            fontSize: 26,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text("kilometers"),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          onTap: () async {
                            systemController
                                .clearRoute(systemController.uniqueId);
                            systemController.removeCircleAnnotation(
                                systemController.startMarkerId);
                            systemController.removeCircleAnnotation(
                                systemController.endMarkerId);

                            systemController.generateMarkerIds();

                            await systemController.onSubmit(
                                Future.value(location['data']['geojson']));

                            // Add circle annotations for start and end markers
                            var access = location['data']['geojson']['features']
                                [0]['geometry']['coordinates'];
                            // print('access: $access');
                            systemController.addCircleAnnotation(
                              LatLng(
                                  access[0][1],
                                  // location['start'][0]),
                                  access[0][0]),
                              systemController.startMarkerId,
                              Colors.red,
                            );

                            // get length of coordinates
                            int length = access.length;
                            // print('length: $length');

                            systemController.addCircleAnnotation(
                              LatLng(
                                  access[length - 1][1],
                                  // location['start'][0]),
                                  access[length - 1][0]),
                              systemController.endMarkerId,
                              Colors.blue,
                            );

                            var midpointData =
                                systemController.calculateMidpoint(
                              access[0][1],
                              access[0][0],
                              access[length - 1][1],
                              access[length - 1][0],
                            );

                            systemController.flyOperation(
                                midpointData['midpoint'].longitude,
                                midpointData['midpoint'].latitude,
                                midpointData['zoom']);

                            setState(() {});
                          },
                        );
                      }),
                      // Add a button called finish rescue
                      Padding(
                        padding: EdgeInsets.only(top: 2.0, bottom: 20.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 150, vertical: 15),
                          ),
                          onPressed: () {
                            _onPressed();
                          },
                          child: Text('Finish Rescue'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  void _onPressed() {
    // Add the logic for finishing the rescue here
    if (timer.isActive) {
      timer.reset();
    } else {
      timer = RestartableTimer(Duration(milliseconds: 500), () async {
        await _submitAction(); // Wait for submit action to complete
      });
    }
  }

  Future<void> _submitAction() async {
    try {
      if (!(await widget.rescuerController.checkIfConnected())) {
        if (!mounted) return; // Check if still mounted
        _showErrorDialog();
        return;
      }

      showDialog<AlertDialog>(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Finishing Rescue...'),
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

      // print('Finish Rescue');

      // Add the logic for finishing the rescue here
      await widget.rescuerController.updateRescued(widget.requestId!);

      if (mounted) {
        // Check if widget is still mounted before navigating
        Navigator.pop(context);
        Navigator.pop(context);
      }
    } catch (e) {
      if (!mounted) return; // Check if still mounted
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

  Future<void> _showErrorDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MapConnectionErrorBox(controller: widget.rescuerController);
      },
    );
  }
}
