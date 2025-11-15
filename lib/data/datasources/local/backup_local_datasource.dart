import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../../../core/database/database_helper.dart';
import '../../models/backup_info_model.dart';

abstract class BackupLocalDataSource {
  /// Create database backup
  Future<BackupInfoModel> createBackup({String? notes, bool isAutoBackup = false});

  /// Restore database from backup
  Future<void> restoreBackup(String filePath);

  /// Get all backup history
  Future<List<BackupInfoModel>> getAllBackups();

  /// Get backup by ID
  Future<BackupInfoModel> getBackupById(int id);

  /// Insert backup record
  Future<int> insertBackupRecord(BackupInfoModel backupInfo);

  /// Delete backup
  Future<void> deleteBackup(int id);

  /// Export data to JSON
  Future<String> exportToJson();

  /// Export table to CSV
  Future<String> exportToCsv(String tableName);

  /// Validate backup file
  Future<bool> validateBackupFile(String filePath);

  /// Get backup statistics
  Future<Map<String, dynamic>> getBackupStatistics();
}

class BackupLocalDataSourceImpl implements BackupLocalDataSource {
  final DatabaseHelper databaseHelper;

  BackupLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<BackupInfoModel> createBackup({
    String? notes,
    bool isAutoBackup = false,
  }) async {
    final Database db = await databaseHelper.database;
    final Directory documentsDirectory = await getApplicationDocumentsDirectory();

    // Create backups directory
    final Directory backupDir = Directory(join(documentsDirectory.path, 'backups'));
    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }

    // Generate backup file name
    final String timestamp = DateTime.now().toIso8601String().replaceAll(':', '-').split('.').first;
    final String fileName = 'laundry_crm_backup_$timestamp.db';
    final String filePath = join(backupDir.path, fileName);

    // Copy database file
    final File dbFile = File(db.path);
    await dbFile.copy(filePath);

    // Get file size
    final File backupFile = File(filePath);
    final int fileSize = await backupFile.length();

    // Get counts
    final int customersCount = await databaseHelper.getRowCount('customers');
    final int ordersCount = await databaseHelper.getRowCount('orders');
    final int itemsCount = await databaseHelper.getRowCount('order_items');

    // Create backup info
    final BackupInfoModel backupInfo = BackupInfoModel(
      fileName: fileName,
      filePath: filePath,
      backupDate: DateTime.now(),
      fileSize: fileSize,
      backupType: isAutoBackup ? 'automatic' : 'manual',
      customersCount: customersCount,
      ordersCount: ordersCount,
      itemsCount: itemsCount,
      notes: notes,
      isAutoBackup: isAutoBackup,
    );

    // Save backup record to database
    final int id = await insertBackupRecord(backupInfo);

    return backupInfo.copyWith(id: id);
  }

  @override
  Future<void> restoreBackup(String filePath) async {
    final File backupFile = File(filePath);

    if (!await backupFile.exists()) {
      throw Exception('Backup file does not exist');
    }

    // Validate backup file
    final bool isValid = await validateBackupFile(filePath);
    if (!isValid) {
      throw Exception('Invalid backup file');
    }

    // Close current database
    await databaseHelper.close();

    // Get current database path
    final Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final String dbPath = join(documentsDirectory.path, 'laundry_crm.db');

    // Restore backup
    await backupFile.copy(dbPath);

    // Reinitialize database
    await databaseHelper.database;
  }

  @override
  Future<List<BackupInfoModel>> getAllBackups() async {
    final Database db = await databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'backup_history',
      orderBy: 'backup_date DESC',
    );

    return List.generate(
      maps.length,
      (i) => BackupInfoModel.fromJson(maps[i]),
    );
  }

  @override
  Future<BackupInfoModel> getBackupById(int id) async {
    final Database db = await databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'backup_history',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) {
      throw Exception('Backup not found');
    }

    return BackupInfoModel.fromJson(maps.first);
  }

  @override
  Future<int> insertBackupRecord(BackupInfoModel backupInfo) async {
    final Database db = await databaseHelper.database;
    return await db.insert('backup_history', backupInfo.toJson());
  }

  @override
  Future<void> deleteBackup(int id) async {
    final Database db = await databaseHelper.database;

    // Get backup info
    final BackupInfoModel backupInfo = await getBackupById(id);

    // Delete backup file
    final File backupFile = File(backupInfo.filePath);
    if (await backupFile.exists()) {
      await backupFile.delete();
    }

    // Delete backup record
    await db.delete(
      'backup_history',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<String> exportToJson() async {
    final Database db = await databaseHelper.database;

    final Map<String, dynamic> exportData = {};

    // List of tables to export
    final List<String> tables = [
      'customers',
      'orders',
      'order_items',
      'services',
      'item_types',
      'service_pricing',
      'payments',
      'employees',
      'inventory_items',
      'stock_transactions',
      'expenses',
    ];

    for (final String table in tables) {
      final List<Map<String, dynamic>> data = await db.query(table);
      exportData[table] = data;
    }

    // Create export directory
    final Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final Directory exportDir = Directory(join(documentsDirectory.path, 'exports'));
    if (!await exportDir.exists()) {
      await exportDir.create(recursive: true);
    }

    // Generate file name
    final String timestamp = DateTime.now().toIso8601String().replaceAll(':', '-').split('.').first;
    final String fileName = 'laundry_crm_export_$timestamp.json';
    final String filePath = join(exportDir.path, fileName);

    // Write JSON file
    final File jsonFile = File(filePath);
    await jsonFile.writeAsString(const JsonEncoder.withIndent('  ').convert(exportData));

    return filePath;
  }

  @override
  Future<String> exportToCsv(String tableName) async {
    final Database db = await databaseHelper.database;

    // Get table data
    final List<Map<String, dynamic>> data = await db.query(tableName);

    if (data.isEmpty) {
      throw Exception('No data to export');
    }

    // Create CSV content
    final StringBuffer csv = StringBuffer();

    // Add header
    final List<String> headers = data.first.keys.toList();
    csv.writeln(headers.join(','));

    // Add rows
    for (final Map<String, dynamic> row in data) {
      final List<String> values = row.values.map((value) => '"${value ?? ''}"').toList();
      csv.writeln(values.join(','));
    }

    // Create export directory
    final Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final Directory exportDir = Directory(join(documentsDirectory.path, 'exports'));
    if (!await exportDir.exists()) {
      await exportDir.create(recursive: true);
    }

    // Generate file name
    final String timestamp = DateTime.now().toIso8601String().replaceAll(':', '-').split('.').first;
    final String fileName = '${tableName}_export_$timestamp.csv';
    final String filePath = join(exportDir.path, fileName);

    // Write CSV file
    final File csvFile = File(filePath);
    await csvFile.writeAsString(csv.toString());

    return filePath;
  }

  @override
  Future<bool> validateBackupFile(String filePath) async {
    try {
      final File backupFile = File(filePath);

      if (!await backupFile.exists()) {
        return false;
      }

      // Open backup database
      final Database backupDb = await openDatabase(filePath, readOnly: true);

      // Check if required tables exist
      final List<String> requiredTables = [
        'customers',
        'orders',
        'settings',
      ];

      for (final String table in requiredTables) {
        final List<Map<String, dynamic>> result = await backupDb.rawQuery(
          "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
          [table],
        );

        if (result.isEmpty) {
          await backupDb.close();
          return false;
        }
      }

      await backupDb.close();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>> getBackupStatistics() async {
    final Database db = await databaseHelper.database;

    final int totalBackups = await databaseHelper.getRowCount('backup_history');

    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT
        SUM(file_size) as total_size,
        MAX(backup_date) as last_backup_date
      FROM backup_history
    ''');

    final int totalSize = result.first['total_size'] as int? ?? 0;
    final String? lastBackupDate = result.first['last_backup_date'] as String?;

    return {
      'total_backups': totalBackups,
      'total_size': totalSize,
      'last_backup_date': lastBackupDate,
    };
  }
}
