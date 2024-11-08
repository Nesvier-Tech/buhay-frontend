import 'package:appwrite/appwrite.dart';

import '../../env/env.dart';
import 'package:dart_appwrite/dart_appwrite.dart' as appwrite;

class DatabaseData {
  DatabaseData(this.client, this.databases);
  final appwrite.Client client;
  final appwrite.Databases databases;

  Future<void> saveDataToDatabase(
      Map<String, dynamic> data, bool isEvacuationSite) async {
    if (isEvacuationSite) {
      try {
        final document = await databases.createDocument(
            databaseId: Env.appwriteDevDatabaseId,
            collectionId: Env
                .appwriteEvacuationSitesCollectionId, // Change to evacuation site collection ID
            documentId: ID.unique(),
            data: data);
        print('Document created: ${document.$id}');
      } on AppwriteException catch (e) {
        print(e.message);
      }
    } else {
      try {
        final document = await databases.createDocument(
            databaseId: Env.appwriteDevDatabaseId,
            collectionId: Env
                .appwriteFloodDataCollectionId, // Change to flood data collection ID
            documentId: ID.unique(),
            data: data);
        print('Document created: ${document.$id}');
      } on AppwriteException catch (e) {
        print(e.message);
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

      print(response.documents);
      return response.documents.map((doc) => doc.data).toList();
    } on AppwriteException catch (e) {
      print(e.message);
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
      print(response.documents);
      return response.documents.map((doc) => doc.data).toList();
    } on AppwriteException catch (e) {
      print(e.message);
      return [];
    }
  }
}
