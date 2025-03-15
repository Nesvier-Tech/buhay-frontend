import 'package:flutter/material.dart';
import '../controller/test_login_controller.dart';

class SampleDataPage extends StatefulWidget {
  final MapTestLoginController controller;
  final List<Map<String, dynamic>> initialData; // Accept initial data

  const SampleDataPage({
    super.key,
    required this.controller,
    required this.initialData,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SampleDataPageState createState() => _SampleDataPageState();
}

class _SampleDataPageState extends State<SampleDataPage> {
  late MapTestLoginController controller;
  late List<Map<String, dynamic>> data; // Local data to display immediately
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    data = widget.initialData; // Initialize with the provided data
    isLoading = data.isEmpty; // Only show loading if initial data is empty

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
          : data.isEmpty
              ? Center(child: Text("No data available")) // Show no data message
              : ListView.builder(
                  itemCount: 1, // Show only the first item
                  itemBuilder: (context, index) {
                    final item = data[0]; // Access the first item
                    return ListTile(
                      title: Text("ID: ${item['id']}"),
                      subtitle: Text("Done: ${item['done']}"),
                    );
                  },
                ),
    );
  }
}
