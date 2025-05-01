import 'package:sqflite/sqflite.dart';

class SqfliteConfig {
  final String nameDb = 'transaction.db';
  final String transactions = 'transactions';
  Database? mainDatabase;

  static final SqfliteConfig _instance = SqfliteConfig._internal();
  SqfliteConfig._internal();
  factory SqfliteConfig() {
    return _instance;
  }

  Future<Database> getDatabase() async {
    if (mainDatabase != null) return mainDatabase!;

    final String dataBasePath = await getDatabasesPath();
    final String fullNameDb = '$dataBasePath$nameDb';

    mainDatabase = await openDatabase(
      fullNameDb,
      version: 1,
      onCreate: (database, version) => createDatabase(database),
    );

    return mainDatabase!;
  }

  void disposeDatabase() {
    if (mainDatabase != null) {
      mainDatabase!.close();
      mainDatabase = null;
    }
  }

  Future<void> createDatabase(Database database) async {
    await _createTransactionTable(database: database);
  }

  Future<void> _createTransactionTable({required Database database}) async {
    int? transactionQuantity = Sqflite.firstIntValue(
      await database.rawQuery(
        'SELECT COUNT(*) FROM sqlite_master WHERE name = ?',
        [transactions],
      ),
    );
    if (transactionQuantity == 0) {
      await database.execute(
        'CREATE TABLE $transactions ('
        'id INT PRIMARY KEY AUTOINCREMENT, '
        'description TEXT, '
        'date INT, '
        'amount REAL'
        ')',
      );
    }
  }
}
