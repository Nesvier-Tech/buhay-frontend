import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../../system_ui/controller/system_controller.dart';

import 'package:latlong2/latlong.dart';

class MapboxResultExperimentPage extends StatefulWidget {
  const MapboxResultExperimentPage({super.key});

  @override
  MapboxResultExperimentPageState createState() =>
      MapboxResultExperimentPageState();
}

class MapboxResultExperimentPageState
    extends State<MapboxResultExperimentPage> {
  late SystemController systemController;

  final List<Map<String, dynamic>> _locations = [
    {
      "title": "Manila",
      "geojson": {
        "type": "FeatureCollection",
        "features": [
          {
            "type": "Feature",
            "geometry": {
              "type": "LineString",
              "coordinates": [
                [121.0692926, 14.6566825],
                [121.0692924, 14.6570228],
                [121.0692923, 14.6571388],
                [121.0692788, 14.6575483],
                [121.0691674, 14.6575465],
                [121.0685724, 14.657549],
                [121.0685887, 14.6563592],
                [121.0685919, 14.6561265],
                [121.0685931, 14.6560372],
                [121.0686178, 14.6542372],
                [121.0686184, 14.6541901],
                [121.0686202, 14.6540599],
                [121.0686219, 14.6539378],
                [121.0686228, 14.6538697],
                [121.0686251, 14.6538026],
                [121.0687008, 14.653804],
                [121.0696052, 14.6538097],
                [121.0696067, 14.6537466],
                [121.069606, 14.6535779]
              ]
            },
            "properties": {}
          },
        ],
      },
      "distance": 150,
    },
    {
      "title": "Quezon City",
      "geojson": {
        "type": "FeatureCollection",
        "features": [
          {
            "type": "Feature",
            "geometry": {
              "type": "LineString",
              "coordinates": [
                [121.0490547, 14.6546545],
                [121.0489602, 14.6546152],
                [121.0489754, 14.6546009],
                [121.0495049, 14.654461],
                [121.0501742, 14.6541691],
                [121.050321, 14.6540815],
                [121.0509091, 14.6536375],
                [121.0512979, 14.6532816],
                [121.0515611, 14.6532258],
                [121.0516734, 14.6531452],
                [121.0522316, 14.6534556],
                [121.0526065, 14.6537015],
                [121.053817, 14.6546086],
                [121.0538532, 14.6546385],
                [121.0541919, 14.6548911],
                [121.0542273, 14.6549164],
                [121.0563125, 14.656238],
                [121.0573546, 14.6569138],
                [121.0576801, 14.6571272],
                [121.058196, 14.657443],
                [121.0589541, 14.6574159],
                [121.059232, 14.6576054],
                [121.0594745, 14.6577707],
                [121.0599407, 14.6580788],
                [121.0628712, 14.6600362],
                [121.0638328, 14.6606718],
                [121.0643419, 14.66101],
                [121.0656282, 14.6618741],
                [121.0669179, 14.6627011],
                [121.0678376, 14.6632914],
                [121.0688648, 14.663953],
                [121.0705256, 14.6649635],
                [121.0705863, 14.6650025],
                [121.0708693, 14.6651871],
                [121.0709174, 14.6652185],
                [121.0709362, 14.6652308],
                [121.0713313, 14.6655111],
                [121.0720529, 14.665953],
                [121.0726099, 14.6663069],
                [121.0730772, 14.6666186],
                [121.0737988, 14.6671013],
                [121.0739385, 14.6671947],
                [121.0742318, 14.667391],
                [121.0745812, 14.6665265]
              ]
            },
            "properties": {}
          }
        ],
      },
      "distance": 160,
    },
  ];

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
        title: Text('Mapbox Experiment'),
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
                    children: _locations.map((location) {
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
                                    'Location ${_locations.indexOf(location) + 1}',
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
