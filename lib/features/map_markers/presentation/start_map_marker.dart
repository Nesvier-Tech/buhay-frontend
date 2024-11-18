import 'package:flutter/material.dart';

class StartMapMarker extends StatelessWidget {
  const StartMapMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.location_on,
      size: 40,
      color: Colors.red,
    );
  }
}
