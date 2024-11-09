import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import 'env/env.dart';
import 'firebase_options.dart';
import 'router/app_router.dart';
import 'service_locator/app_service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Firebase Initialization.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Service Locator Initialization.
  final GetIt getIt = GetIt.instance;
  final AppServiceLocator appServiceLocator = AppServiceLocator(getIt: getIt);
  appServiceLocator.setup();

  // Mapbox Initialization.
  final String mapboxPublicAccessToken = Env.mapboxPublicAccessToken1;
  MapboxOptions.setAccessToken(mapboxPublicAccessToken);

  runApp(const BuhayApp());
}

class BuhayApp extends StatelessWidget {
  const BuhayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Buhay - Disaster Response App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
