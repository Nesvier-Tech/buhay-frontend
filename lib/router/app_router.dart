import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/appwrite_auth_experiment/presentation/appwrite_auth_experiment_page.dart';
import '../features/google_maps_experiment/presentation/google_maps_experiment_page.dart';
import '../features/home/presentation/home_page.dart';
import '../features/mapbox_experiment/presentation/mapbox_experiment_page.dart';

class AppRouter {
  const AppRouter._();

  static final GoRouter router = GoRouter(
    routes: <RouteBase>[
      // Home Page.
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const HomePage();
        },
        pageBuilder: pageBuilder(child: const HomePage()),
      ),

      // Google Maps Experiment Page.
      GoRoute(
        path: '/google-maps-experiment',
        builder: (BuildContext context, GoRouterState state) {
          return const GoogleMapsExperimentPage();
        },
        pageBuilder: pageBuilder(child: const GoogleMapsExperimentPage()),
      ),

      // Appwrite Auth Experiment Page.
      GoRoute(
        path: '/appwrite-auth-experiment',
        builder: (BuildContext context, GoRouterState state) {
          return const AppwriteAuthExperimentPage();
        },
        pageBuilder: pageBuilder(child: const AppwriteAuthExperimentPage()),
      ),

      // Mapbox Experiment Page.
      GoRoute(
        path: '/mapbox-experiment',
        builder: (BuildContext context, GoRouterState state) {
          return const MapboxExperimentPage();
        },
        pageBuilder: pageBuilder(child: const MapboxExperimentPage()),
      ),
    ],
  );

  static Page<dynamic> Function(BuildContext, GoRouterState) pageBuilder({
    required Widget child,
  }) {
    return (
      BuildContext context,
      GoRouterState state,
    ) {
      return CustomTransitionPage(
        key: state.pageKey,
        child: child,
        transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) {
          return FadeTransition(
            opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
            child: child,
          );
        },
      );
    };
  }
}
