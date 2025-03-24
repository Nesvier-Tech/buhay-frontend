import 'package:flutter/material.dart';
import 'map_interactive_search.dart';
import '../../controller/rescuer/map_results_controller.dart';
import 'map_manual_search.dart';
import 'package:async/async.dart';

class MapDashboard extends StatefulWidget {
  final int personID;
  const MapDashboard({super.key, required this.personID});

  @override
  MapDashboardState createState() => MapDashboardState();
}

class MapDashboardState extends State<MapDashboard> {
  late MapResultsController mapResultsController;
  late RestartableTimer timer;

  @override
  void initState() {
    super.initState();
    mapResultsController = MapResultsController();
    _initialize();
    timer = RestartableTimer(Duration(milliseconds: 500), () {});
  }

  @override
  Widget build(BuildContext context) {
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
          children: <Widget>[
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //     minimumSize: Size(200, 50),
            //   ),
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => MapPage()),
            //     );
            //   },
            //   child: Text('Single Search'),
            // ),
            SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 50),
              ),
              onPressed: () async {
                if (timer.isActive) {
                  timer.reset();
                } else {
                  timer = RestartableTimer(Duration(milliseconds: 500), () {
                    if (mounted) {
                      Navigator.push(
                          // ignore: use_build_context_synchronously
                          context,
                          MaterialPageRoute(
                              builder: (context) => InteractiveSearch(
                                  personID: widget.personID)));
                    }
                  });
                }
              },
              child: Text('Interactive Search'),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 50),
              ),
              onPressed: () {
                if (timer.isActive) {
                  timer.reset();
                } else {
                  timer = RestartableTimer(Duration(milliseconds: 500), () {
                    if (mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MapManualSearch(
                                  personID: widget.personID,
                                )),
                      );
                    }
                  });
                }
              },
              child: Text('Manual Search'),
            ),
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
}
