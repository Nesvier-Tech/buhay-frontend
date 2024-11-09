import 'package:appwrite/appwrite.dart';
// import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../env/env.dart';
import '../controller/nstp_map_controller.dart';
import '../controller/search_controller.dart' as custom;
import 'form_data.dart';
import 'search_widget.dart';

class NSTPMapScreen extends StatefulWidget {
  const NSTPMapScreen({super.key});

  @override
  State<NSTPMapScreen> createState() => _NSTPMapScreenState();
}

class _NSTPMapScreenState extends State<NSTPMapScreen> {
  late NSTPMapController _mapController;
  late custom.SearchController _searchController;
  int lengthOfDecimalPlaces = 10;
  int maxWidth = 1000;
  late BuildContext _buildContext;
  Offset? markerScreenPosition;
  bool isSearched = false;
  bool isTapped = false;
  List<Offset> floodMarkersScreenPositions = [];
  List<Offset> evacSiteMarkersScreenPositions = [];
  late MapboxMap mapboxMap;
  late Future<List<Map<String, dynamic>>> evacSiteLocations;
  late Future<List<Map<String, dynamic>>> floodLocations;
  late Realtime realtime;

  List<String> databaseCredentials = [
    'databases.${Env.appwriteDevDatabaseId}.collections.${Env.appwriteEvacuationSitesCollectionId}.documents',
    'databases.${Env.appwriteDevDatabaseId}.collections.${Env.appwriteFloodDataCollectionId}.documents',
  ];

  bool get isDesktop => MediaQuery.of(_buildContext).size.width > maxWidth;

  @override
  void initState() {
    super.initState();
    final String mapboxAccessToken = Env.mapboxPublicAccessToken1;
    final String googleToken = Env.googleMapsApiKey1;
    MapboxOptions.setAccessToken(mapboxAccessToken);
    _mapController = NSTPMapController(
      mapboxAccessToken: mapboxAccessToken,
      currentLocation: const LatLng(14.6539, 121.0685),
      googleToken: googleToken,
    );
    _searchController = custom.SearchController(mapboxAccessToken, googleToken);
    evacSiteLocations = _mapController.getEvacSitesData();
    floodLocations = _mapController.getFloodData();
    _updateFloodAndEvacSiteMarkers();
  }

  void _updateFloodAndEvacSiteMarkers() {
    realtime = GetIt.I<Realtime>();
    final subscription = realtime.subscribe(databaseCredentials);
    subscription.stream.listen((response) {
      setState(() {
        evacSiteLocations = _mapController.getEvacSitesData();
        floodLocations = _mapController.getFloodData();
      });
      _showEvacSiteMarkers();
      _showFloodDataMarkers();
    });
  }

  void _showLocationInfo(LatLng point) {
    if (isDesktop) {
      // Close bottom sheet if it's open
      Navigator.of(_buildContext).popUntil((route) => route.isFirst);
      // Show sidebar for desktop
      setState(() {
        _mapController.showSidebar = true;
      });
    } else {
      // Hide sidebar for mobile
      setState(() {
        _mapController.showSidebar = false;
      });
      // Show bottom sheet for mobile
      _showBottomSheet(point);
    }
  }

  void _searchPlace(String query) async {
    _mapController.searchPlace(query);
    _updateUI();
    isSearched = true;
    isTapped = false;

    // if (mounted) {
    //   _showLocationInfo(_mapController.currentLocation);
    // }
  }

  bool _handleMapTap(MapContentGestureContext mapContext) {
    _mapController.handleMapTap(mapContext);
    _updateUI();
    isTapped = true;
    isSearched = false;

    if (mounted) {
      _showLocationInfo(_mapController.currentLocation);
    }
    return true;
  }

  void _showMarkers(Future<List<Map<String, dynamic>>> locations,
      List<Offset> markerPositions) async {
    markerPositions.clear();
    final locationsList = await locations;
    for (var location in locationsList) {
      mapboxMap
          .pixelForCoordinate(Point.fromJson({
        'coordinates': [location['longitude'], location['latitude']]
      }))
          .then((point) {
        setState(() {
          markerPositions.add(Offset(point.x, point.y));
        });
      });
    }
  }

  void _showEvacSiteMarkers() {
    _showMarkers(evacSiteLocations, evacSiteMarkersScreenPositions);
  }

  void _showFloodDataMarkers() {
    _showMarkers(floodLocations, floodMarkersScreenPositions);
  }

  @override
  Widget build(BuildContext context) {
    final String userEmail = GoRouterState.of(context).extra as String;
    GetIt.I<Logger>().i('User email: $userEmail');

    _buildContext = context;
    return Material(
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final searchWidth = isDesktop
                ? constraints.maxWidth * 0.75
                : constraints.maxWidth - 32;
            return Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      if (isDesktop && _mapController.showSidebar)
                        SizedBox(
                          width: 400,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: _showSidebar(_mapController.currentLocation),
                          ),
                        ),
                      Expanded(
                        child: Stack(
                          children: [
                            MapWidget(
                              cameraOptions: CameraOptions(
                                center: Point.fromJson({
                                  'coordinates': [
                                    _mapController.currentLocation.longitude,
                                    _mapController.currentLocation.latitude
                                  ]
                                }),
                                zoom: 18.0,
                              ),
                              onMapCreated: _onMapCreated,
                              onTapListener: _handleMapTap,
                              onCameraChangeListener: _onCameraChange,
                            ),
                            for (var entry in floodMarkersScreenPositions)
                              Positioned(
                                left: entry.dx - 20,
                                top: entry.dy - 40,
                                child: Column(
                                  children: [
                                    _buildFloodMarker(),
                                  ],
                                ),
                              ),
                            for (var entry in evacSiteMarkersScreenPositions)
                              Positioned(
                                left: entry.dx - 20,
                                top: entry.dy - 40,
                                child: Column(
                                  children: [
                                    _buildEvacSiteMarker(),
                                  ],
                                ),
                              ),
                            if (markerScreenPosition != null)
                              Positioned(
                                left: markerScreenPosition!.dx - 20,
                                top: markerScreenPosition!.dy - 40,
                                child: _buildMarker(),
                              ),
                            Positioned(
                              top: 16,
                              left: 16,
                              right: 16,
                              child: Container(
                                width: searchWidth,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SearchWidget(
                                    controller: _searchController,
                                    onSearch: _searchPlace,
                                    width: searchWidth - 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMarker() {
    return const Icon(
      Icons.add_location_alt,
      color: Colors.black,
      size: 40,
    );
  }

  Widget _buildEvacSiteMarker() {
    return const Icon(
      Icons.health_and_safety,
      color: Colors.blue,
      size: 40,
    );
  }

  Widget _buildFloodMarker() {
    return const Icon(
      Icons.flood,
      color: Colors.red,
      size: 40,
    );
  }

  void _updateUI() {
    setState(() {});
    _updateMarkerPosition();
  }

  void _updateMarkerPosition() async {
    final screenPosition = await _mapController.getMarkerScreenPosition();
    if (screenPosition != null && mounted) {
      setState(() {
        markerScreenPosition = screenPosition;
      });
    }
  }

  void _onCameraChange(CameraChangedEventData eventData) {
    _updateMarkerPosition();
    _showEvacSiteMarkers();
    _showFloodDataMarkers();
  }

  void _showBottomSheet(LatLng point) {
    if (!isDesktop) {
      // Only show bottom sheet on mobile
      showModalBottomSheet(
        context: _buildContext,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return OrientationBuilder(
            builder: (context, orientation) {
              // Check if we should close the bottom sheet
              if (MediaQuery.of(context).size.width > maxWidth) {
                Navigator.of(context).pop();
                // Show sidebar instead
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _mapController.showSidebar = true;
                  });
                });
                return const SizedBox.shrink();
              }
              return DraggableScrollableSheet(
                initialChildSize: 0.5,
                minChildSize: 0.2,
                maxChildSize: 0.9,
                expand: false,
                builder: (context, scrollController) {
                  return Column(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: _buildBottomSheetContent(point),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      );
    }
  }

  Widget _buildBottomSheetContent(LatLng point) {
    return MapForm(
      latitude: point.latitude.toStringAsFixed(lengthOfDecimalPlaces),
      longitude: point.longitude.toStringAsFixed(lengthOfDecimalPlaces),
      email: GoRouterState.of(_buildContext).extra as String,
    );
  }

  Widget _showSidebar(LatLng point) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              setState(() {
                _mapController.showSidebar = false;
              });
            },
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: MapForm(
                latitude: point.latitude.toStringAsFixed(lengthOfDecimalPlaces),
                longitude:
                    point.longitude.toStringAsFixed(lengthOfDecimalPlaces),
                email: GoRouterState.of(_buildContext).extra as String,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    this.mapboxMap = mapboxMap;
    _mapController.onMapCreated(mapboxMap);
    _showEvacSiteMarkers();
    _showFloodDataMarkers();
  }
}
