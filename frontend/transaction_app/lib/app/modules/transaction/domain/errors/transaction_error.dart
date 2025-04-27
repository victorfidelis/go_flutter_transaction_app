
class CreateTransactionError implements Exception {
  final String message;
  
  CreateTransactionError(this.message);
}

class GetTransactionError implements Exception {
  final String message;
  
  GetTransactionError(this.message);
}