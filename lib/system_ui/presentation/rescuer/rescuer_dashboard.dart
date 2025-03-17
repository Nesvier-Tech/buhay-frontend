import 'package:flutter/material.dart';
import 'package:async/async.dart';
import '../../controller/rescuer/rescuer_controller.dart';
import '../map_result.dart';

class RescuerDashboard extends StatefulWidget {
  final RescuerController controller;
  const RescuerDashboard({super.key, required this.controller});

  @override
  RescuerDashboardState createState() => RescuerDashboardState();
}

class RescuerDashboardState extends State<RescuerDashboard> {
  late RescuerController rescuerController;
  late RestartableTimer timer;

  @override
  void initState() {
    super.initState();
    rescuerController = widget.controller;
    timer = RestartableTimer(Duration(milliseconds: 500), () {});
  }

  @override
  void dispose() {
    rescuerController.dispose();
    timer.cancel();
    super.dispose();
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
            SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 50),
              ),
              onPressed: () async {
                if (timer.isActive) {
                  timer.reset();
                } else {
                  timer =
                      RestartableTimer(Duration(milliseconds: 500), () async {
                    if (mounted) {
                      await rescuerController.getRouteInfo();
                      Navigator.push(
                          // ignore: use_build_context_synchronously
                          context,
                          MaterialPageRoute(
                              builder: (context) => MapResultPage(
                                    mapResultsController: rescuerController,
                                  )));
                    }
                  });
                }
              },
              child: Text('Begin Rescue'),
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
}
