import 'package:flutter/material.dart';

import '../../../system_ui/controller/system_controller.dart';
import '../controller/map_submit_controller.dart';

class MapSubmitWidget extends StatefulWidget {
  const MapSubmitWidget({
    super.key,
    required this.systemController,
    required this.onSubmit,
  });

  final SystemController systemController;
  final Function(Future<Map<String, dynamic>>) onSubmit;

  @override
  State<MapSubmitWidget> createState() => _MapSubmitWidgetState();
}

class _MapSubmitWidgetState extends State<MapSubmitWidget> {
  late MapSubmitController mapSubmitController;

  @override
  void initState() {
    super.initState();
    mapSubmitController = MapSubmitController();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _onPressed,
      child: const Text('Submit Request'),
    );
  }

  void _onPressed() {
    Future<Map<String, dynamic>> data = mapSubmitController.getRoute(
      widget.systemController.startMarkerPosition,
      widget.systemController.endMarkerPosition,
    );
    widget.onSubmit(data);
  }
}
