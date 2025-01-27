import 'package:flutter/material.dart';
import 'map_result.dart';

class MapDashboard extends StatelessWidget {
  const MapDashboard({super.key});

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
                minimumSize: Size(200, 50), // Set uniform size for buttons
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MapboxResultPage()), // TO UPDATE
                );
              },
              child: Text('Interactive Map Search'),
            ),
            SizedBox(height: 40), // Adds space between buttons
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 50), // Set uniform size for buttons
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MapboxResultPage()), // TO UPDATE
                );
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
          'Results shown will be based on walking data.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12), // Smaller font size for disclaimer
        ),
      ),
    );
  }
}
