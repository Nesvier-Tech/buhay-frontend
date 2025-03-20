import 'package:buhay/system_ui/presentation/map_result.dart';
import 'package:flutter/material.dart';
import '../../controller/rescuer/rescuer_controller.dart';

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
  bool isLoading = true; // Track loading state
  String routeInfoId = "1";

  @override
  void initState() {
    super.initState();
    data = []; // Initialize with the provided data
    isLoading = data.isEmpty; // Only show loading if initial data is empty

    controller = RescuerController(rescuerId: widget.rescuerId);

    // print rescuer id stored in controller)
    print("Rescuer ID: ${widget.rescuerId}");
    controller.connectWebSocket(); // Connect to WebSocket here)

    // Listen to the stream for updates
    controller.stream.listen((newData) {
      if (mounted) {
        setState(() {
          // print("New Data: $newData");
          data = newData; // Update the local data when new data arrives

          // print("data: $data");
          // print("data[0]['id']: ${data[0]['id']}");
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
      print("\n\nid: ${data[0]['id']}");

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        // Uncomment the following lines to update the ongoing status of the rescuer and get the route info
        // await controller.updateOngoing(data[0]['id'].toString());
        // await controller.getRouteInfo(data[0]['route_info_id'].toString());
        await controller.getRouteInfo(routeInfoId);
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => MapResultPage(
              mapResultsController: controller,
              rescuerId: controller.rescuerId,
            ),
          ),
        );
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text('Project Buhay'),
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 24),
            Text(isLoading
                ? "Gathering Data..."
                : data.isEmpty
                    ? "No new data available. Waiting for new assignments..."
                    : "Processing data..."),
          ],
        ),
      ),
    );
  }
}
