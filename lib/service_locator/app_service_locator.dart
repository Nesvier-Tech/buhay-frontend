import 'package:appwrite/appwrite.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../env/env.dart';

class AppServiceLocator {
  const AppServiceLocator({required getIt}) : _getIt = getIt;

  final GetIt _getIt;

  void setup() {
    // Appwrite Initialization.
    final Client client = Client()
        .setEndpoint(Env.appwriteEndpoint)
        .setProject(Env.appwriteProjectId);

    _getIt.registerLazySingleton<Client>(() => client);

    _getIt.registerLazySingleton<Realtime>(() => Realtime(_getIt()));

    _getIt.registerLazySingleton<Databases>(() => Databases(_getIt()));

    _getIt.registerLazySingleton<Account>(() => Account(_getIt()));

    // Logger Initialization.
    final Logger logger = Logger();
    _getIt.registerLazySingleton(() => logger);
  }
}
