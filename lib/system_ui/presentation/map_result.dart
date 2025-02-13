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
      appBar: AppBar(
        title: Text('Map Results'),
        centerTitle: true,
      ),
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
                    children:
                        widget.mapResultsController.routes.map((location) {
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
                                              "${location['start'][0]},${location['start'][1]}\n",
                                        ),
                                        TextSpan(
                                          text: "End: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text:
                                              "${location['end'][0]},${location['end'][1]}\n",
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${location['data']['distance'].toStringAsFixed(2)}", // Rounding to 2 decimal places
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
                          await systemController.onSubmit(
                              Future.value(location['data']['geojson']));

                          var midpointData = systemController.calculateMidpoint(
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
                    }).toList(),
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
