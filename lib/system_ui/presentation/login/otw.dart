import 'package:flutter/material.dart';

class OnTheWayPage extends StatefulWidget {
  const OnTheWayPage({super.key});

  @override
  State<OnTheWayPage> createState() => _OnTheWayPageState();
}

class _OnTheWayPageState extends State<OnTheWayPage> {

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text('On the Way'),
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Rescuer is on the Way!")
          ],
        ),
      ),
    );
  }

}