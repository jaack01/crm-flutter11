import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'database_tables.dart';

class DatabaseHelper {
  static const String _databaseName = 'laundry_crm.db';
  static const int _databaseVersion = 1;

  // Singleton pattern
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  /// Get database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialize database
  Future<Database> _initDatabase() async {
    // For Windows/Linux, use FFI
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final String path = join(documentsDirectory.path, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      onConfigure: _onConfigure,
    );
  }

  /// Configure database (enable foreign keys)
  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  /// Create database tables
  Future<void> _onCreate(Database db, int version) async {
    final Batch batch = db.batch();

    // Create all tables
    batch.execute(DatabaseTables.createCustomersTable);
    batch.execute(DatabaseTables.createOrdersTable);
    batch.execute(DatabaseTables.createOrderItemsTable);
    batch.execute(DatabaseTables.createServicesTable);
    batch.execute(DatabaseTables.createItemTypesTable);
    batch.execute(DatabaseTables.createServicePricingTable);
    batch.execute(DatabaseTables.createPaymentsTable);
    batch.execute(DatabaseTables.createEmployeesTable);
    batch.execute(DatabaseTables.createInventoryItemsTable);
    batch.execute(DatabaseTables.createStockTransactionsTable);
    batch.execute(DatabaseTables.createExpensesTable);
    batch.execute(DatabaseTables.createSettingsTable);
    batch.execute(DatabaseTables.createShopSettingsTable);
    batch.execute(DatabaseTables.createNotificationSettingsTable);
    batch.execute(DatabaseTables.createNotificationsTable);
    batch.execute(DatabaseTables.createBackupHistoryTable);

    // Create indexes for better performance
    batch.execute(DatabaseTables.createCustomersIndexes);
    batch.execute(DatabaseTables.createOrdersIndexes);
    batch.execute(DatabaseTables.createPaymentsIndexes);
    batch.execute(DatabaseTables.createNotificationsIndexes);
    batch.execute(DatabaseTables.createBackupHistoryIndexes);

    // Insert default data
    batch.execute(DatabaseTables.insertDefaultServices);
    batch.execute(DatabaseTables.insertDefaultItemTypes);
    batch.execute(DatabaseTables.insertDefaultSettings);
    batch.execute(DatabaseTables.insertDefaultShopSettings);
    batch.execute(DatabaseTables.insertDefaultNotificationSettings);

    await batch.commit(noResult: true);
  }

  /// Upgrade database
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database migrations here
    if (oldVersion < newVersion) {
      // Example: Add new columns, tables, etc.
      // await db.execute('ALTER TABLE customers ADD COLUMN new_column TEXT');
    }
  }

  /// Close database
  Future<void> close() async {
    final Database db = await database;
    await db.close();
    _database = null;
  }

  /// Delete database (for testing/reset purposes)
  Future<void> deleteDb() async {
    final Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final String path = join(documentsDirectory.path, _databaseName);
    await deleteDatabase(path);
    _database = null;
  }

  /// Backup database
  Future<String> backupDatabase() async {
    final Database db = await database;
    final Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final String timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final String backupPath = join(
      documentsDirectory.path,
      'backups',
      'laundry_crm_backup_$timestamp.db',
    );

    // Create backups directory if it doesn't exist
    final Directory backupDir = Directory(join(documentsDirectory.path, 'backups'));
    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }

    // Copy database file
    final String dbPath = db.path;
    final File dbFile = File(dbPath);
    await dbFile.copy(backupPath);

    return backupPath;
  }

  /// Restore database from backup
  Future<void> restoreDatabase(String backupPath) async {
    await close();

    final Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final String dbPath = join(documentsDirectory.path, _databaseName);

    final File backupFile = File(backupPath);
    if (!await backupFile.exists()) {
      throw Exception('Backup file does not exist');
    }

    await backupFile.copy(dbPath);
    _database = await _initDatabase();
  }

  /// Execute raw query
  Future<List<Map<String, dynamic>>> rawQuery(String sql, [List<dynamic>? arguments]) async {
    final Database db = await database;
    return await db.rawQuery(sql, arguments);
  }

  /// Execute raw insert/update/delete
  Future<int> rawExecute(String sql, [List<dynamic>? arguments]) async {
    final Database db = await database;
    return await db.rawUpdate(sql, arguments);
  }

  /// Get table row count
  Future<int> getRowCount(String tableName) async {
    final Database db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM $tableName',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Check if table exists
  Future<bool> tableExists(String tableName) async {
    final Database db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
      [tableName],
    );
    return result.isNotEmpty;
  }
}
