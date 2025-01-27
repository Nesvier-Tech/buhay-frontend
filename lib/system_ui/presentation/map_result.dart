import 'package:buhay/system_ui/controller/system_results_controller.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../../system_ui/controller/system_controller.dart';

import 'package:latlong2/latlong.dart';

class MapboxResultPage extends StatefulWidget {
  const MapboxResultPage({super.key});

  @override
  MapboxResultPageState createState() => MapboxResultPageState();
}

class MapboxResultPageState extends State<MapboxResultPage> {
  late SystemController systemController;
  late SystemResultsController systemResultsController;

  @override
  void initState() {
    super.initState();
    LatLng defaultLocation = const LatLng(14.6539, 121.0685);

    systemController = SystemController(currentLocation: defaultLocation);
    systemResultsController = SystemResultsController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapbox Results Page'),
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
                    children: systemResultsController.locations.map((location) {
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
                                    'Location ${systemResultsController.locations.indexOf(location) + 1}',
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
                                              "${location['geojson']['features'][0]['geometry']['coordinates'][0].join(', ')}\n",
                                        ),
                                        TextSpan(
                                          text: "End: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        TextSpan(
                                          text:
                                              "${location['geojson']['features'][0]['geometry']['coordinates'].last.join(', ')}",
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
                                      "${location['distance'].toStringAsFixed(2)}", // Rounding to 2 decimal places
                                      style: TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("meters"),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        onTap: () async {
                          systemController
                              .clearRoute(systemController.uniqueId);
                          await systemController
                              .onSubmit(Future.value(location['geojson']));

                          var midpointData = systemController.calculateMidpoint(
                            location['geojson']['features'][0]['geometry']
                                ['coordinates'][0][1],
                            location['geojson']['features'][0]['geometry']
                                ['coordinates'][0][0],
                            location['geojson']['features'][0]['geometry']
                                    ['coordinates']
                                .last[1],
                            location['geojson']['features'][0]['geometry']
                                    ['coordinates']
                                .last[0],
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
