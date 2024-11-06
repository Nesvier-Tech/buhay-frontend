import 'package:buhay/env/env.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Env', () {
    group('openAiApiKey1', () {
      test('should not return null', () {
        expect(Env.openAiApiKey1, isNotNull);
      });

      test('should return a String', () {
        expect(Env.openAiApiKey1, isA<String>());
      });

      // Should not return an empty String.
      test('should not return an empty String', () {
        expect(Env.openAiApiKey1, isNot(''));
      });
    });

    group('googleGeminiApiKey1', () {
      test('should not return null', () {
        expect(Env.googleGeminiApiKey1, isNotNull);
      });

      test('should return a String', () {
        expect(Env.googleGeminiApiKey1, isA<String>());
      });

      // Should not return an empty String.
      test('should not return an empty String', () {
        expect(Env.googleGeminiApiKey1, isNot(''));
      });
    });

    group('perplexityApiKey1', () {
      test('should not return null', () {
        expect(Env.perplexityApiKey1, isNotNull);
      });

      test('should return a String', () {
        expect(Env.perplexityApiKey1, isA<String>());
      });

      // Should not return an empty String.
      test('should not return an empty String', () {
        expect(Env.perplexityApiKey1, isNot(''));
      });
    });

    group('googleMapsApiKeyAndroid1', () {
      test('should not return null', () {
        expect(Env.googleMapsApiKeyAndroid1, isNotNull);
      });

      test('should return a String', () {
        expect(Env.googleMapsApiKeyAndroid1, isA<String>());
      });

      // Should not return an empty String.
      test('should not return an empty String', () {
        expect(Env.googleMapsApiKeyAndroid1, isNot(''));
      });
    });

    group('googleMapsApiKeyWeb1', () {
      test('should not return null', () {
        expect(Env.googleMapsApiKeyWeb1, isNotNull);
      });

      test('should return a String', () {
        expect(Env.googleMapsApiKeyWeb1, isA<String>());
      });

      // Should not return an empty String.
      test('should not return an empty String', () {
        expect(Env.googleMapsApiKeyWeb1, isNot(''));
      });
    });

    group('googleMapsApiKeyIp1', () {
      test('should not return null', () {
        expect(Env.googleMapsApiKeyIp1, isNotNull);
      });

      test('should return a String', () {
        expect(Env.googleMapsApiKeyIp1, isA<String>());
      });

      // Should not return an empty String.
      test('should not return an empty String', () {
        expect(Env.googleMapsApiKeyIp1, isNot(''));
      });
    });

    group('appwriteProjectId', () {
      test('should not return null', () {
        expect(Env.appwriteProjectId, isNotNull);
      });

      test('should return a String', () {
        expect(Env.appwriteProjectId, isA<String>());
      });

      // Should not return an empty String.
      test('should not return an empty String', () {
        expect(Env.appwriteProjectId, isNot(''));
      });
    });

    group('appwriteEndpoint', () {
      test('should not return null', () {
        expect(Env.appwriteEndpoint, isNotNull);
      });

      test('should return a String', () {
        expect(Env.appwriteEndpoint, isA<String>());
      });

      // Should not return an empty String.
      test('should not return an empty String', () {
        expect(Env.appwriteEndpoint, isNot(''));
      });
    });
  });
}
