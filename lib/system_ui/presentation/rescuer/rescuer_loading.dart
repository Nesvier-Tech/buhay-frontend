import 'package:buhay/system_ui/presentation/rescuer/map_result.dart';
import 'package:flutter/material.dart';
import '../../controller/rescuer/rescuer_controller.dart';
import '../../../features/map_error_dialog_box/presentation/map_error_dialog_box.dart';

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
  // String routeInfoId = "1";

  @override
  void initState() {
    super.initState();
    data = []; // Initialize with the provided data
    isLoading = data.isEmpty; // Only show loading if initial data is empty
    controller = RescuerController(rescuerId: widget.rescuerId);

    // Call initialization logic in a separate async method
    _initialize();
  }

  Future<void> _initialize() async {
    if (!(await controller.checkIfConnected())) {
      if (!mounted) return;
      await _showErrorDialog();
      return;
    }

    // print rescuer id stored in controller
    print("Rescuer ID: ${widget.rescuerId}");
    controller.connectWebSocket(); // Connect to WebSocket here

    // Listen to the stream for updates
    controller.stream.listen((newData) {
      if (mounted) {
        setState(() {
          data = newData; // Update the local data when new data arrives
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
      print("\n\nid: ${data[0]['request_id']}");
      // print("data: $data\n\n");

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        // Update the ongoing status of the rescuer
        await controller.updateOngoing(data[0]['request_id'].toString());
        print("Ongoing status updated");
        await controller.getRouteInfo(data[0]['route_info_id'].toString());
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => MapResultPage(
              rescuerController: controller,
              requestId: data[0]['request_id'].toString(),
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

  Future<void> _showErrorDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MapConnectionErrorBox(controller: controller);
      },
    );
    Navigator.pop(context);
  }
}
