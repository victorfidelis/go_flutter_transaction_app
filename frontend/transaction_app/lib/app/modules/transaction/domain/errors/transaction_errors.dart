
class CreateTransactionError implements Exception {
  final String message;
  
  CreateTransactionError(this.message);

  @override
  String toString() {
    return message;
  }
}

class GetTransactionError implements Exception {
  final String message;
  
  GetTransactionError(this.message);
  
  @override
  String toString() {
    return message;
  }
}