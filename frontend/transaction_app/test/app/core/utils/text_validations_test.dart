import 'package:flutter_test/flutter_test.dart';
import 'package:transaction_app/app/core/utils/text_validations.dart'; // Ajuste o caminho conforme necessário

void main() {
  group('isAlphanum', () {
    test('retorna true para texto apenas com letras', () {
      expect(TextValidations.isAlphanum('abcABC'), isTrue);
    });

    test('retorna true para texto apenas com números', () {
      expect(TextValidations.isAlphanum('123'), isTrue);
    });

    test('retorna true para texto alfanumérico', () {
      expect(TextValidations.isAlphanum('abc123'), isTrue);
    });

    test('retorna false para texto com espaços', () {
      expect(TextValidations.isAlphanum('abc 123'), isFalse);
    });

    test('retorna false para texto com caracteres especiais', () {
      expect(TextValidations.isAlphanum('abc@123'), isFalse);
    });

    test('retorna false para texto vazio', () {
      expect(TextValidations.isAlphanum(''), isFalse);
    });

    test('retorna false para texto com acentos', () {
      expect(TextValidations.isAlphanum('áéíóú'), isFalse);
    });

    test('retorna false para texto com underline', () {
      expect(TextValidations.isAlphanum('abc_123'), isFalse);
    });
  });

  group('isAlphanumWithSpaces', () {
    test('retorna true para texto apenas com letras', () {
      expect(TextValidations.isAlphanumWithSpaces('abcABC'), isTrue);
    });

    test('retorna true para texto apenas com números', () {
      expect(TextValidations.isAlphanumWithSpaces('123'), isTrue);
    });

    test('retorna true para texto alfanumérico', () {
      expect(TextValidations.isAlphanumWithSpaces('abc123'), isTrue);
    });

    test('retorna true para texto com espaços', () {
      expect(TextValidations.isAlphanumWithSpaces('abc 123'), isTrue);
    });

    test('retorna true para texto com múltiplos espaços', () {
      expect(TextValidations.isAlphanumWithSpaces('a b c 1 2 3'), isTrue);
    });

    test('retorna false para texto com caracteres especiais', () {
      expect(TextValidations.isAlphanumWithSpaces('abc@123'), isFalse);
    });

    test('retorna true para texto vazio', () {
      expect(TextValidations.isAlphanumWithSpaces(''), isTrue);
    });

    test('retorna false para texto com acentos', () {
      expect(TextValidations.isAlphanumWithSpaces('áéíóú'), isFalse);
    });

    test('retorna false para texto com quebras de linha', () {
      expect(TextValidations.isAlphanumWithSpaces('abc\n123'), isFalse);
    });

    test('retorna false para texto com tabs', () {
      expect(TextValidations.isAlphanumWithSpaces('abc\t123'), isFalse);
    });
  });
}