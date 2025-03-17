import 'package:flutter/material.dart';
import '../../controller/rescuer/rescuer_controller.dart';
import 'rescuer_dashboard.dart';

class RescuerLoading extends StatefulWidget {
  final String rescuerId; // Accept initial data

  const RescuerLoading({
    super.key,
    required this.rescuerId,
  });

  @override
  // ignore: library_private_types_in_public_api
  _RescuerLoadingState createState() => _RescuerLoadingState();
}

class _RescuerLoadingState extends State<RescuerLoading> {
  late RescuerController controller;
  late List<Map<String, dynamic>> data; // Local data to display immediately
  String rescuerId = ""; // Local data to display immediately
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    rescuerId = widget.rescuerId; // Initialize with the provided data
    data = []; // Initialize with the provided data
    isLoading = data.isEmpty; // Only show loading if initial data is empty

    print("Rescuer ID: $rescuerId");

    controller = RescuerController(rescuerId: rescuerId);
    controller.connectWebSocket(); // Connect to WebSocket here)

    // Listen to the stream for updates
    controller.stream.listen((newData) {
      if (mounted) {
        setState(() {
          print("New Data: $newData");
          if (newData.isNotEmpty) {
            data = newData; // Update the local data when new data arrives
          } else {
            data = [];
          }
          print(data);
          // data = newData; // Update the local data when new data arrives
          isLoading = false; // Stop loading once data is received
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: prefer_is_not_empty
    if (!isLoading && !data.isEmpty) {
      // Navigate when data is loaded
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RescuerDashboard(
              controller: controller,
            ),
          ),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text("Sample Data")),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16), // Add some spacing
                  Text("Gathering Data..."),
                ],
              ),
            ) // Show loading icon
          : Center(child: Text("No data available")),
    );
  }
}
