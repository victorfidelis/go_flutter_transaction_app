class TextValidations {
  static bool isAlphanum(String input) {
    final RegExp alphanumericWithSpacesRegex = RegExp(r'^[a-zA-Z0-9]+$');
    return alphanumericWithSpacesRegex.hasMatch(input);
  }

  static bool isAlphanumWithSpaces(String input) {
    if (input.isEmpty) return true;
    final RegExp alphanumericWithSpacesRegex = RegExp(r'^[a-zA-Z0-9 ]+$');
    return alphanumericWithSpacesRegex.hasMatch(input);
  }
}
