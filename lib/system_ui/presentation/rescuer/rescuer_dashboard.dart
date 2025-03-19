import 'package:buhay/system_ui/presentation/rescuer/rescuer_loading.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';

class RescuerDashboard extends StatefulWidget {
  final String rescuerId; // Accept initial data
  const RescuerDashboard({super.key, required this.rescuerId});

  @override
  RescuerDashboardState createState() => RescuerDashboardState();
}

class RescuerDashboardState extends State<RescuerDashboard> {
  late String rescuerId;
  late RestartableTimer timer;

  @override
  void initState() {
    super.initState();
    rescuerId = widget.rescuerId;
    timer = RestartableTimer(Duration(milliseconds: 500), () {});
  }

  @override
  void dispose() {
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
                      Navigator.push(
                          // ignore: use_build_context_synchronously
                          context,
                          MaterialPageRoute(
                              builder: (context) => RescuerLoading(
                                    rescuerId: rescuerId,
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
