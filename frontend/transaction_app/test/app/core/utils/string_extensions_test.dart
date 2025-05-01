import 'package:flutter_test/flutter_test.dart';
import 'package:transaction_app/app/core/utils/string_extensions.dart'; 

void main() {
  group('StringExtensions.reverse', () {
    test('inverte string não vazia', () {
      const value = 'abcde';
      final result = value.reverse();
      expect(result, equals('edcba'));
    });

    test('inverte string com espaços', () {
      const value = 'hello world';
      final result = value.reverse();
      expect(result, equals('dlrow olleh'));
    });

    test('inverte string com caracteres especiais', () {
      const value = '!@#\$%';
      final result = value.reverse();
      expect(result, equals('%\$#@!'));
    });

    test('inverte string com números', () {
      const value = '12345';
      final result = value.reverse();
      expect(result, equals('54321'));
    });

    test('inverte string vazia retorna vazio', () {
      const value = '';
      final result = value.reverse();
      expect(result, isEmpty);
    });

    test('inverte string com um único caractere', () {
      const value = 'a';
      final result = value.reverse();
      expect(result, equals('a'));
    });

    test('inverte string com caracteres Unicode', () {
      const value = 'áéíóú';
      final result = value.reverse();
      expect(result, equals('úóíéá'));
    });

    test('inverte string com combinação de caracteres', () {
      const value = 'a1!B2@C3#';
      final result = value.reverse();
      expect(result, equals('#3C@2B!1a'));
    });

    test('inverte string com múltiplos espaços', () {
      const value = 'a  b   c';
      final result = value.reverse();
      expect(result, equals('c   b  a'));
    });
  });
}