import 'package:flutter/material.dart';

class EndMapMarker extends StatelessWidget {
  const EndMapMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.location_on,
      size: 40,
      color: Colors.red,
    );
  }
}
