
import 'package:flutter/services.dart';

class MaxLengthInputFormatter extends TextInputFormatter {
  final int maxLength;

  MaxLengthInputFormatter(this.maxLength);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var filteredText = newValue.text;
    if (filteredText.length > 50) {
      filteredText = oldValue.text;
    }
    return TextEditingValue(
      text: filteredText,
      selection: TextSelection.collapsed(offset: filteredText.length),
    );
  }
}


