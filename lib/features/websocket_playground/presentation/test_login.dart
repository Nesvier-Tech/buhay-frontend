import 'package:flutter/material.dart';
import 'sample_data_page.dart';
import 'package:async/async.dart';
import '../controller/test_login_controller.dart';

class MapTestLogin extends StatefulWidget {
  const MapTestLogin({super.key});

  @override
  MapTestLoginState createState() => MapTestLoginState();
}

class MapTestLoginState extends State<MapTestLogin> {
  late MapTestLoginController mapTestLoginController;
  late RestartableTimer timer;

  @override
  void initState() {
    super.initState();
    mapTestLoginController = MapTestLoginController();
    timer = RestartableTimer(Duration(milliseconds: 500), () {});
  }

  @override
  void dispose() {
    mapTestLoginController.dispose();
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
                  timer = RestartableTimer(Duration(milliseconds: 500), () {
                    mapTestLoginController.data =
                        []; // Clear data before connecting
                    mapTestLoginController
                        .connectWebSocket(); // Connect to WebSocket here
                    if (mounted) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SampleDataPage(
                                    controller: mapTestLoginController,
                                    initialData: mapTestLoginController
                                        .data, // Pass current data
                                  )));
                    }
                  });
                }
              },
              child: Text('LOGIN'),
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
