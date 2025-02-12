import 'package:flutter/material.dart';
import 'map_result.dart';
import 'map_page.dart';

import 'package:buhay/system_ui/controller/system_results_controller.dart';

class MapDashboard extends StatefulWidget {
  const MapDashboard({super.key});

  @override
  MapDashboardState createState() => MapDashboardState();
}

class MapDashboardState extends State<MapDashboard> {
  late MapResultsController mapResultsController;

  @override
  void initState() {
    super.initState();
    mapResultsController = MapResultsController();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      var response = await mapResultsController.getPing();
      if (response['message'] == 'pong') {
        print('Ping successful');
      } else {
        print('Ping failed');
      }
    } catch (e) {
      // Show dialog on error
      _showErrorDialog();
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Connection Error'),
          content:
              Text('Could not connect to the server. Please try again later.'),
          actions: <Widget>[
            TextButton(
              child: Text('Try Again'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _initialize(); // Retry the connection
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Project Buhay'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 50),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapPage()),
                );
              },
              child: Text('Single Search'),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 50),
              ),
              onPressed: () async {
                await mapResultsController.getRoute();
                if (mounted) {
                  Navigator.push(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(
                        builder: (context) => MapResultPage(
                              mapResultsController: mapResultsController,
                            )), // TO UPDATE
                  );
                }
              },
              child: Text('Interactive Map Search'),
            ),
            // SizedBox(height: 40),
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //     minimumSize: Size(200, 50),
            //   ),
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) => MapboxResultPage()), // TO UPDATE
            //     );
            //   },
            //   child: Text('Manual Search'),
            // ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(10),
        color: Colors.grey[200], // Light background for the disclaimer
        child: Text(
          'Routes that will be shown are based on walking data.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14), // Smaller font size for disclaimer
        ),
      ),
    );
  }
}
