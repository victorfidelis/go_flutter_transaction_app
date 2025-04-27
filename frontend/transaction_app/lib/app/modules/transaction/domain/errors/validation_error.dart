class ValidationError implements Exception {
  final Map<String, String> errors;
  
  ValidationError(this.errors);
}
