import 'package:flutter/material.dart';

class MapInteractiveSearch extends StatefulWidget {
  const MapInteractiveSearch({super.key});

  @override
  State<MapInteractiveSearch> createState() => _MapInteractiveSearchState();
}

class _MapInteractiveSearchState extends State<MapInteractiveSearch> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: const Text('Interactive Search'),
            centerTitle: true,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black)),
        body: Center(child: Text("Work in Progress. Check again later")));
  }
}
