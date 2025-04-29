import 'package:flutter/services.dart';
import 'package:transaction_app/app/core/utils/text_validations.dart';

class AlphanumericInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var filteredText = newValue.text;
    if (!TextValidations.isAlphanumWithSpaces(filteredText)) {
      filteredText = oldValue.text;
    }
    return TextEditingValue(
      text: filteredText,
      selection: TextSelection.collapsed(offset: filteredText.length),
    );
  }
}
