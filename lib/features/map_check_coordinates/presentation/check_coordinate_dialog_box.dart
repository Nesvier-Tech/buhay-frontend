import 'package:flutter/material.dart';

class CheckCoordinateDialogBox extends StatelessWidget {
  const CheckCoordinateDialogBox({super.key});

  @override
  Widget build(BuildContext context) {
    // Show the dialog after the widget is built
    return AlertDialog(
      title: const Text('Error'),
      content: const Text(
          'Location is out of bounds. Enter a location inside Quezon City.'),
      actions: <TextButton>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
