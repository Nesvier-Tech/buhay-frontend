import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../main.dart';

class AppRouter {
  const AppRouter._();

  static final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const HomePage();
        },
      ),
    ],
  );
}
