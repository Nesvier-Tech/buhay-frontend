import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'firebase_options.dart';
import 'router/app_router.dart';
import 'service_locator/app_service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase Initialization.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Service Locator Initialization.
  final GetIt getIt = GetIt.instance;
  final AppServiceLocator appServiceLocator = AppServiceLocator(getIt: getIt);
  appServiceLocator.setup();

  runApp(const BuhayApp());
}

class BuhayApp extends StatelessWidget {
  const BuhayApp({super.key});

  // This widget is the root of your application.
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
