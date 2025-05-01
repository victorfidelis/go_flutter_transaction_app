import 'package:flutter_test/flutter_test.dart';
import 'package:transaction_app/app/core/utils/date_formatter.dart';

void main() {
  group('formatDate', () {
    test('formata data com dia e mês de um dígito', () {
      final date = DateTime(2023, 5, 3);
      final result = DateFormatters.formatDate(date);
      
      expect(result, equals('03/05/2023'));
    });

    test('formata data com dia e mês de dois dígitos', () {
      final date = DateTime(2023, 12, 25);
      final result = DateFormatters.formatDate(date);
      
      expect(result, equals('25/12/2023'));
    });

    test('formata data do primeiro dia do ano', () {
      final date = DateTime(2024, 1, 1);
      final result = DateFormatters.formatDate(date);
      
      expect(result, equals('01/01/2024'));
    });

    test('formata data do último dia do ano', () {
      final date = DateTime(2023, 12, 31);
      final result = DateFormatters.formatDate(date);
      
      expect(result, equals('31/12/2023'));
    });

    test('formata data com ano bissexto', () {
      final date = DateTime(2024, 2, 29);
      final result = DateFormatters.formatDate(date);
      
      expect(result, equals('29/02/2024'));
    });

    test('formata data com ano grande', () {
      final date = DateTime(9999, 12, 31);
      final result = DateFormatters.formatDate(date);
      
      expect(result, equals('31/12/9999'));
    });
  });
}