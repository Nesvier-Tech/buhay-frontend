import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../../map_search_box/presentation/search_box.dart';
import '../../map_search_dropdown/presentation/search_dropdown.dart';
import '../controller/search_controller.dart';

class MapSearchWidget extends StatefulWidget {
  const MapSearchWidget({
    super.key,
    required this.message,
    required this.mapboxAccessToken,
    required this.googleToken,
    required this.onSearch,
    required this.boxType,
  });

  final String message;
  final String mapboxAccessToken;
  final String googleToken;
  final Function(LatLng, bool) onSearch;
  final bool boxType;

  @override
  State<MapSearchWidget> createState() => _MapSearchWidgetState();
}

class _MapSearchWidgetState extends State<MapSearchWidget> {
  late final MapSearchController controller;
  final ValueNotifier<bool> isTyping = ValueNotifier(false);
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    controller =
        MapSearchController(widget.mapboxAccessToken, widget.googleToken);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          SearchBoxWidget(
            message: widget.message,
            controller: controller,
            isTyping: isTyping,
            onSearch: widget.onSearch,
            boxType: widget.boxType,
            focusNode: focusNode,
          ),
          SearchDropdownWidget(
            message: widget.message,
            controller: controller,
            isTyping: isTyping,
            onSearch: widget.onSearch,
            boxType: widget.boxType,
          ),
        ],
      ),
    );
  }
}
