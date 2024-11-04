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
  });
}
