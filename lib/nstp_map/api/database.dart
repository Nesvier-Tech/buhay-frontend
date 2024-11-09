import 'package:appwrite/appwrite.dart';

import '../../env/env.dart';

class DatabaseData {
  DatabaseData(this.client, this.databases);
  final Client client;
  final Databases databases;

  Future<void> saveDataToDatabase(
      Map<String, dynamic> data, bool isEvacuationSite) async {
    if (isEvacuationSite) {
      try {
        await databases.createDocument(
            databaseId: Env.appwriteDevDatabaseId,
            collectionId: Env
                .appwriteEvacuationSitesCollectionId, // Change to evacuation site collection ID
            documentId: ID.unique(),
            data: data);
      } on AppwriteException {
        // print(e.message);
      }
    } else {
      try {
        await databases.createDocument(
            databaseId: Env.appwriteDevDatabaseId,
            collectionId: Env
                .appwriteFloodDataCollectionId, // Change to flood data collection ID
            documentId: ID.unique(),
            data: data);
      } on AppwriteException {
        // print(e.message);
      }
    }
  }

  Future<List<Map<String, dynamic>>> fetchFloodData() async {
    try {
      final response = await databases.listDocuments(
          databaseId: Env.appwriteDevDatabaseId,
          collectionId: Env.appwriteFloodDataCollectionId,
          queries: [
            Query.select(["latitude", "longitude"])
          ]);

      return response.documents.map((doc) => doc.data).toList();
    } on AppwriteException {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchEvacuationSitesData() async {
    try {
      final response = await databases.listDocuments(
          databaseId: Env.appwriteDevDatabaseId,
          collectionId: Env.appwriteEvacuationSitesCollectionId,
          queries: [
            Query.select(["latitude", "longitude"])
          ]);
      return response.documents.map((doc) => doc.data).toList();
    } on AppwriteException {
      return [];
    }
  }
}
