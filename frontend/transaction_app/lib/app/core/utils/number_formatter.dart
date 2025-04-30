import 'package:transaction_app/app/core/utils/string_extensions.dart';

class NumberFormatters {
  static String formatZipCode(String zipCode) {
    return '${zipCode.substring(0, 5)}-${zipCode.substring(5, 8)}';
  }

  static String formatMoney(double money) {
    var textPrice = money.toStringAsFixed(2).replaceAll('.', ',').trim();
    textPrice = addThousandsSeparator(textPrice);
    textPrice = textPrice;
    return textPrice;
  }

  static String addThousandsSeparator(String value) {
    var reverseTextPrice = value.reverse();
    var formatReverseTextPrice = reverseTextPrice.substring(0, 3);
    for (int i = 3; i < reverseTextPrice.length; i++) {
      var intIndex = i - 3;
      if (intIndex > 0 && intIndex % 3 == 0) {
        formatReverseTextPrice += '.';
      }
      formatReverseTextPrice += reverseTextPrice[i];
    }
    return formatReverseTextPrice.reverse();
  }
}