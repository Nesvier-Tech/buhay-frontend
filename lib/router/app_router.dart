import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/appwrite_auth_experiment/presentation/appwrite_auth_experiment_page.dart';
import '../features/google_maps_experiment/presentation/google_maps_experiment_page.dart';
import '../features/home/presentation/home_page.dart';

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
        pageBuilder: (BuildContext context, GoRouterState state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const HomePage(),
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) {
              // Change the opacity of the page using a Curve based on the
              // animation's value.
              return FadeTransition(
                opacity:
                    CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        },
      ),

      // Google Maps Experiment Page.
      GoRoute(
        path: '/google-maps-experiment',
        builder: (BuildContext context, GoRouterState state) {
          return const GoogleMapsExperimentPage();
        },
        pageBuilder: (BuildContext context, GoRouterState state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const GoogleMapsExperimentPage(),
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) {
              return FadeTransition(
                opacity:
                    CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        },
      ),

      // Appwrite Auth Experiment Page.
      GoRoute(
        path: '/appwrite-auth-experiment',
        builder: (BuildContext context, GoRouterState state) {
          return const AppwriteAuthExperimentPage();
        },
        pageBuilder: (BuildContext context, GoRouterState state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const AppwriteAuthExperimentPage(),
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) {
              return FadeTransition(
                opacity:
                    CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        },
      ),
    ],
  );
}
