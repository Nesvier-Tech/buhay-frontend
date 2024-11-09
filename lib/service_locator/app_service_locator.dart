import 'package:appwrite/appwrite.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/web.dart';

import '../env/env.dart';

class AppServiceLocator {
  const AppServiceLocator({required getIt}) : _getIt = getIt;

  final GetIt _getIt;

  void setup() {
    // Appwrite Initialization.
    final Client client = Client()
        .setEndpoint(Env.appwriteEndpoint)
        .setProject(Env.appwriteProjectId);
    final Account account = Account(client);

    _getIt.registerLazySingleton<Account>(() => account);

    // Logger Initialization.
    final Logger logger = Logger();
    _getIt.registerLazySingleton(() => logger);
  }
}
