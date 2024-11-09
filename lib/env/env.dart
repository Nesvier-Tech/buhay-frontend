import 'package:envied/envied.dart';

part 'env.g.dart';

/// To generate the .env.g.dart file, run the following command:
/// `fvm dart run build_runner build --delete-conflicting-outputs`
@Envied(path: '.env')
abstract class Env {
  // LLMs.
  @EnviedField(varName: 'OPENAI_API_KEY_1', obfuscate: true)
  static final String openAiApiKey1 = _Env.openAiApiKey1;

  @EnviedField(varName: 'GOOGLE_GEMINI_API_KEY_1', obfuscate: true)
  static final String googleGeminiApiKey1 = _Env.googleGeminiApiKey1;

  @EnviedField(varName: 'PERPLEXITY_API_KEY_1', obfuscate: true)
  static final String perplexityApiKey1 = _Env.perplexityApiKey1;

  // Google Maps.
  @EnviedField(varName: 'GOOGLE_MAPS_API_KEY_ANDROID_1', obfuscate: true)
  static final String googleMapsApiKeyAndroid1 = _Env.googleMapsApiKeyAndroid1;

  @EnviedField(varName: 'GOOGLE_MAPS_API_KEY_WEB_1', obfuscate: true)
  static final String googleMapsApiKeyWeb1 = _Env.googleMapsApiKeyWeb1;

  @EnviedField(varName: 'GOOGLE_MAPS_API_KEY_IP_1', obfuscate: true)
  static final String googleMapsApiKeyIp1 = _Env.googleMapsApiKeyIp1;

  @EnviedField(varName: 'GOOGLE_MAPS_API_KEY_1', obfuscate: true)
  static final String googleMapsApiKey1 = _Env.googleMapsApiKey1;

  // Appwrite.
  @EnviedField(varName: 'APPWRITE_PROJECT_ID', obfuscate: true)
  static final String appwriteProjectId = _Env.appwriteProjectId;

  @EnviedField(varName: 'APPWRITE_ENDPOINT', obfuscate: true)
  static final String appwriteEndpoint = _Env.appwriteEndpoint;

  @EnviedField(varName: 'APPWRITE_DEV_DATABASE_ID', obfuscate: true)
  static final String appwriteDevDatabaseId = _Env.appwriteDevDatabaseId;

  @EnviedField(varName: 'APPWRITE_FLOOD_DATA_COLLECTION_ID', obfuscate: true)
  static final String appwriteFloodDataCollectionId =
      _Env.appwriteFloodDataCollectionId;

  @EnviedField(
    varName: 'APPWRITE_EVACUATION_SITES_COLLECTION_ID',
    obfuscate: true,
  )
  static final String appwriteEvacuationSitesCollectionId =
      _Env.appwriteEvacuationSitesCollectionId;

  // Mapbox.
  @EnviedField(varName: 'MAPBOX_SECRET_ACCESS_TOKEN_1', obfuscate: true)
  static final String mapboxSecretAccessToken1 = _Env.mapboxSecretAccessToken1;

  @EnviedField(varName: 'MAPBOX_PUBLIC_ACCESS_TOKEN_1', obfuscate: true)
  static final String mapboxPublicAccessToken1 = _Env.mapboxPublicAccessToken1;
}
