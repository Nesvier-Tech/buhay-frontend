import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppNavigationDrawer extends StatelessWidget {
  const AppNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      children: <Widget>[
        ListTile(
          title: const Text('Home'),
          onTap: () {
            Navigator.of(context).pushNamed('/');
          },
        ),
        ListTile(
          title: const Text('About'),
          onTap: () {
            Navigator.of(context).pushNamed('/about');
          },
        ),
        ListTile(
          title: const Text('Contact'),
          onTap: () {
            Navigator.of(context).pushNamed('/contact');
          },
        ),

        // Google Maps Experiment.
        ListTile(
          title: const Text('Google Maps Experiment'),
          onTap: () {
            // User GoRouter to navigate to the Google Maps Experiment Page.
            GoRouter.of(context).push('/google-maps-experiment');
          },
        ),

        // Appwrite Auth Experiment.
        ListTile(
          title: const Text('Appwrite Auth Experiment'),
          onTap: () {
            // User GoRouter to navigate to the Appwrite Auth Experiment Page.
            GoRouter.of(context).push('/appwrite-auth-experiment');
          },
        ),
      ],
    );
  }
}
