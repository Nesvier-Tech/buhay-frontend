import 'package:flutter/material.dart';

class MapConnectionErrorBox extends StatelessWidget {
  final controller;
  const MapConnectionErrorBox({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Connection Error'),
      content: Text('Could not connect to the server. Please try again later.'),
      actions: <Widget>[
        TextButton(
          child: Text('Try Again'),
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
            controller.checkIfConnected(); // Retry the connection
          },
        ),
      ],
    );
  }
}
