import 'package:envied/envied.dart';

part 'env.g.dart';

/// To generate the .env.g.dart file, run the following command:
/// `fvm dart run build_runner build --delete-conflicting-outputs`
@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'OPENAI_API_KEY_1', obfuscate: true)
  static final String openAiApiKey1 = _Env.openAiApiKey1;

  @EnviedField(varName: 'GOOGLE_GEMINI_API_KEY_1', obfuscate: true)
  static final String googleGeminiApiKey1 = _Env.googleGeminiApiKey1;

  @EnviedField(varName: 'PERPLEXITY_API_KEY_1', obfuscate: true)
  static final String perplexityApiKey1 = _Env.perplexityApiKey1;

  @EnviedField(varName: 'GOOGLE_MAPS_API_KEY_ANDROID_1', obfuscate: true)
  static final String googleMapsApiKeyAndroid1 = _Env.googleMapsApiKeyAndroid1;

  @EnviedField(varName: 'GOOGLE_MAPS_API_KEY_WEB_1', obfuscate: true)
  static final String googleMapsApiKeyWeb1 = _Env.googleMapsApiKeyWeb1;
}
