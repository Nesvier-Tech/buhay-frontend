import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../controller/search_controller.dart';
import '../../map_search_box/presentation/search_box.dart';
import '../../map_search_dropdown/presentation/search_dropdown.dart';

class MapSearchWidget extends StatelessWidget {
  MapSearchWidget(
      {super.key,
      required this.message,
      required this.mapboxAccessToken,
      required this.googleToken,
      required this.onSearch})
      : controller = MapSearchController(mapboxAccessToken, googleToken);

  final String message;
  final String mapboxAccessToken;
  final String googleToken;
  final Function(LatLng) onSearch;
  final MapSearchController controller;
  final ValueNotifier<bool> isTyping = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          SearchBoxWidget(
            message: message,
            controller: controller,
            isTyping: isTyping,
            onSearch: onSearch,
          ),
          SearchDropdownWidget(
            message: message,
            controller: controller,
            isTyping: isTyping,
            onSearch: onSearch,
          ),
        ],
      ),
    );
  }
}
