import 'package:flutter/material.dart';

import '../../../core/app_navigation_drawer/app_navigation_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buhay - Disaster Response App'),
      ),
      drawer: const AppNavigationDrawer(),
      body: const Center(
        child: Text('Hello, World!'),
      ),
    );
  }
}
