import 'package:buhay/system_ui/controller/map_results_controller.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../../system_ui/controller/system_controller.dart';

import 'package:latlong2/latlong.dart';

class MapResultPage extends StatefulWidget {
  final MapResultsController mapResultsController;

  const MapResultPage({super.key, required this.mapResultsController});

  @override
  MapResultPageState createState() => MapResultPageState();
}

class MapResultPageState extends State<MapResultPage> {
  late SystemController systemController;

  @override
  void initState() {
    super.initState();
    LatLng defaultLocation = const LatLng(14.6539, 121.0685);

    systemController = SystemController(currentLocation: defaultLocation);
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
                      ...widget.mapResultsController.routes.map((location) {
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
                                      'Location ${widget.mapResultsController.routes.indexOf(location) + 1}',
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
                                                "${location['start'][0].toStringAsFixed(7)},${location['start'][1].toStringAsFixed(7)}\n",
                                          ),
                                          TextSpan(
                                            text: "End: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          TextSpan(
                                            text:
                                                "${location['end'][0].toStringAsFixed(7)},${location['end'][1].toStringAsFixed(7)}\n",
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
                            systemController.addCircleAnnotation(
                              LatLng(
                                  location['start'][1], location['start'][0]),
                              systemController.startMarkerId,
                              Colors.blue,
                            );

                            systemController.addCircleAnnotation(
                              LatLng(location['end'][1], location['end'][0]),
                              systemController.endMarkerId,
                              Colors.red,
                            );

                            var midpointData =
                                systemController.calculateMidpoint(
                              location['start'][1],
                              location['start'][0],
                              location['end'][1],
                              location['end'][0],
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
                            print('Finish Rescue');
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
}
