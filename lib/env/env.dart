import 'package:envied/envied.dart';

part 'env.g.dart';

/// TODO: Write a test for the Env abstract class (and the usage of the generated .env.g.dart file).
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
}
