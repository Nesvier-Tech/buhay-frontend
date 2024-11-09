import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppNavigationDrawer extends StatelessWidget {
  const AppNavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      children: <Widget>[
        // // Sign In Page.
        // ListTile(
        //   leading: const Icon(Icons.login),
        //   title: const Text('Sign In'),
        //   onTap: () {
        //     GoRouter.of(context).go('/sign-in');
        //   },
        // ),

        // ListTile(
        //   leading: const Icon(Icons.home),
        //   title: const Text('Home'),
        //   onTap: () {
        //     GoRouter.of(context).go('/');
        //   },
        // ),
        // ListTile(
        //   leading: const Icon(Icons.info),
        //   title: const Text('About'),
        //   onTap: () {
        //     Navigator.of(context).pushNamed('/about');
        //   },
        // ),
        // ListTile(
        //   leading: const Icon(Icons.contact_page),
        //   title: const Text('Contact'),
        //   onTap: () {
        //     Navigator.of(context).pushNamed('/contact');
        //   },
        // ),

        // // NSTP Map.
        // ListTile(
        //   leading: const Icon(Icons.map),
        //   title: const Text('NSTP Map'),
        //   onTap: () {
        //     // User GoRouter to navigate to the NSTP Map Page.
        //     GoRouter.of(context).push('/nstp-map');
        //   },
        // ),

        // // Google Maps Experiment.
        // ListTile(
        //   leading: const Icon(Icons.map),
        //   title: const Text('Google Maps Experiment'),
        //   onTap: () {
        //     // User GoRouter to navigate to the Google Maps Experiment Page.
        //     GoRouter.of(context).push('/google-maps-experiment');
        //   },
        // ),

        // // Appwrite Auth Experiment.
        // ListTile(
        //   leading: const Icon(Icons.security),
        //   title: const Text('Appwrite Auth Experiment'),
        //   onTap: () {
        //     // User GoRouter to navigate to the Appwrite Auth Experiment Page.
        //     GoRouter.of(context).push('/appwrite-auth-experiment');
        //   },
        // ),

        // // Mapbox Experiment.
        // ListTile(
        //   leading: const Icon(Icons.map),
        //   title: const Text('Mapbox Experiment'),
        //   onTap: () {
        //     // User GoRouter to navigate to the Mapbox Experiment Page.
        //     GoRouter.of(context).push('/mapbox-experiment');
        //   },
        // ),

        // Sign Out.
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Sign Out'),
          onTap: () {
            // User GoRouter to navigate to the Sign In Page.
            GoRouter.of(context).go('/sign-in');
          },
        ),
      ],
    );
  }
}
