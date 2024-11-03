// import 'package:dart_appwrite/dart_appwrite.dart';
// import 'package:http/http.dart';

// class DatabaseData {
//   final Client client;

//   DatabaseData(this.client);

//   Future<Map<String, dynamic>> saveDataToDatabase(
//       Map<String, dynamic> data, bool isEvacuationSite) async {
//     // final client = Client()
//     //     .setEndpoint('https://cloud.appwrite.io/v1')
//     //     .setProject('PROJECT_ID');

//     final databases = Databases(client);

//     if (isEvacuationSite) {
//       try {
//         final document = await databases.createDocument(
//             databaseId: '<DB_ID>',
//             collectionId:
//                 'CL_ID', // Change to evacuation site collection ID
//             documentId: ID.unique(),
//             data: data);
//         debugPrint('Document created: ${document.$id}');
//       } on AppwriteException catch (e) {
//         debugPrint(e.message);
//       }
//     } else {
//       try {
//         final document = await databases.createDocument(
//             databaseId: 'DB_ID',
//             collectionId:
//                 'CL_ID', // Change to flood data collection ID
//             documentId: ID.unique(),
//             data: data);
//         debugPrint('Document created: ${document.$id}');
//       } on AppwriteException catch (e) {
//         debugPrint(e.message);
//       }
//     }
//   }

//   Future<List<Map<String, dynamic>>> fetchFloodData() async {
//     // final client = Client()
//     //     .setEndpoint('https://cloud.appwrite.io/v1')
//     //     .setProject('PROJECT_ID');

//     final database = Databases(client);

//     try {
//       final response = await database
//           .listDocuments('DB_ID', 'CL_ID', [
//         Query.select(["latitude", "longitude"])
//       ]);
//       return response;
//       debugPrint(response);
//     } on AppwriteException catch (e) {
//       return [];
//       debugPrint(e.message);
//     }
//   }

//   Future<List<Map<String, dynamic>>> fetchEvacuationSitesData() async {
//     // final client = Client()
//     //     .setEndpoint('https://cloud.appwrite.io/v1')
//     //     .setProject('PROJECT_ID');

//     final database = Databases(client);

//     try {
//       final response = await database
//           .listDocuments('DB_ID', 'CL_ID', [
//         Query.select(["latitude", "longitude"])
//       ]);
//       return response;
//       debugPrint(response);
//     } on AppwriteException catch (e) {
//       return [];
//       debugPrint(e.message);
//     }
//   }
// }
