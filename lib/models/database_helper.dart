import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database? _db;

  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDatabase();
    return _db!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'login.db');
    var db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
    return db;
  }

// Tambahkan kolom baru ke dalam tabel users
  void _onCreate(Database db, int newVersion) async {
    await db.execute('''
        CREATE TABLE IF NOT EXISTS users (
          id INTEGER PRIMARY KEY,
          username TEXT,
          password TEXT,
          total_pengeluaran REAL,
          total_pemasukan REAL
        )
      ''');

    // Buat Kolom Transaksi
    await db.execute('''
        CREATE TABLE IF NOT EXISTS transactions (
          id INTEGER PRIMARY KEY,
          username TEXT,
          transaction_date TEXT,
          amount INT,
          description TEXT,
          transaction_type TEXT
        )
      ''');

    // Insert beberapa data dummy
    await db.rawInsert('''
      INSERT INTO users(username, password, total_pengeluaran, total_pemasukan)
      VALUES('admin', 'admin', 20000.0, 3000.0)
    ''');
  }

  Future<bool> login(String username, String password) async {
    final dbClient = await db;
    List<Map<String, dynamic>> result = await dbClient.rawQuery(
        'SELECT * FROM users WHERE username = ? AND password = ?',
        [username, password]);

    return result.isNotEmpty;
  }

  Future<Map<String, dynamic>> getUserData(String username) async {
    final dbClient = await db;
    List<Map<String, dynamic>> result = await dbClient.rawQuery(
      'SELECT * FROM users WHERE username = ? LIMIT 1',
      [username],
    );
    return result.first;
  }

  Future<void> saveTransaction(String username, String transactionDate,
      double amount, String description, String transactionType) async {
    final dbClient = await db;
    await dbClient.insert('transactions', {
      'username': username,
      'transaction_date': transactionDate,
      'amount': amount,
      'description': description,
      'transaction_type': transactionType,
    });
  }

  Future<List<Map<String, dynamic>>> getTransactionsByDate(
      String username, String startDate, String endDate) async {
    final dbClient = await db;
    return await dbClient.query('transactions',
        where:
            'username = ? AND transaction_date >= ? AND transaction_date <= ?',
        whereArgs: [username, startDate, endDate],
        orderBy: 'transaction_date ASC');
  }

  Future<List<Map<String, dynamic>>> getAllTransactions(String username) async {
    final dbClient = await db;
    return await dbClient.query('transactions',
        where: 'username = ?',
        whereArgs: [username],
        orderBy: 'transaction_date DESC');
  }

  Future<String> getTotalPengeluaran(String username) async {
    final dbClient = await db;
    final result = await dbClient.rawQuery(
        'SELECT SUM(amount) AS total FROM transactions WHERE username = ? AND transaction_type = ?',
        [username, 'Pengeluaran']);
    final total = result.first['total'];
    print(result);
    if (total == null) {
      return "0"; // Atur nilai default jika total null
    } else {
      return total.toString();
    }
  }

  Future<String> getTotalPemasukan(String username) async {
    final dbClient = await db;
    final result = await dbClient.rawQuery(
        'SELECT SUM(amount) AS total FROM transactions WHERE username = ? AND transaction_type = ?',
        [username, 'Pemasukan']);
    final total = result.first['total'];

    if (total == null) {
      return "0"; // Atur nilai default jika total null
    } else {
      return total.toString();
    }
  }

  Future<void> changePassword(String username, String newPassword) async {
    final dbClient = await db;
    await dbClient.update(
      'users',
      {'password': newPassword},
      where: 'username = ?',
      whereArgs: [username],
    );
  }

  Future<int> deleteAllTransactions() async {
    final dbClient = await db;
    return await dbClient.rawDelete('DELETE FROM transactions');
  }
}
