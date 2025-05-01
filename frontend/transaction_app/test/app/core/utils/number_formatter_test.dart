import 'package:flutter_test/flutter_test.dart';
import 'package:transaction_app/app/core/utils/number_formatter.dart';

void main() {

  group('formatMoney', () {
    test('formata valor monetário inteiro', () {
      const money = 1000.0;
      final result = NumberFormatters.formatMoney(money);
      expect(result, equals('1.000,00'));
    });

    test('formata valor monetário com centavos', () {
      const money = 1234.56;
      final result = NumberFormatters.formatMoney(money);
      expect(result, equals('1.234,56'));
    });

    test('formata valor monetário zero', () {
      const money = 0.0;
      final result = NumberFormatters.formatMoney(money);
      expect(result, equals('0,00'));
    });

    test('formata valor monetário negativo', () {
      const money = -1234.56;
      final result = NumberFormatters.formatMoney(money);
      expect(result, equals('-1.234,56'));
    });

    test('formata valor monetário com muitos dígitos', () {
      const money = 1234567890.12;
      final result = NumberFormatters.formatMoney(money);
      expect(result, equals('1.234.567.890,12'));
    });
  });

  group('addThousandsSeparator', () {
    test('adiciona separador de milhar em número inteiro', () {
      const value = '1000,00';
      final result = NumberFormatters.addThousandsSeparator(value);
      expect(result, equals('1.000,00'));
    });

    test('adiciona múltiplos separadores de milhar', () {
      const value = '1000000,00';
      final result = NumberFormatters.addThousandsSeparator(value);
      expect(result, equals('1.000.000,00'));
    });

    test('não adiciona separador em número pequeno', () {
      const value = '999,00';
      final result = NumberFormatters.addThousandsSeparator(value);
      expect(result, equals('999,00'));
    });

    test('mantém casas decimais intactas', () {
      const value = '1234567,89';
      final result = NumberFormatters.addThousandsSeparator(value);
      expect(result, equals('1.234.567,89'));
    });

    test('lida com valor negativo', () {
      const value = '-1234567,00';
      final result = NumberFormatters.addThousandsSeparator(value);
      expect(result, equals('-1.234.567,00'));
    });
  });
}