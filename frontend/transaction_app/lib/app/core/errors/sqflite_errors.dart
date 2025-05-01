class GetDatabaseError implements Exception {
  final String message;

  GetDatabaseError(this.message);
  
  @override
  String toString() {
    return message;
  }
}
