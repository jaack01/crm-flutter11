import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/backup_info.dart';

abstract class BackupRepository {
  /// Create a full database backup
  Future<Either<Failure, BackupInfo>> createBackup({
    String? notes,
    bool isAutoBackup = false,
  });

  /// Restore database from backup
  Future<Either<Failure, void>> restoreBackup(String filePath);

  /// Get all backup history
  Future<Either<Failure, List<BackupInfo>>> getAllBackups();

  /// Get backup by ID
  Future<Either<Failure, BackupInfo>> getBackupById(int id);

  /// Delete backup
  Future<Either<Failure, void>> deleteBackup(int id);

  /// Export data to JSON
  Future<Either<Failure, String>> exportToJson();

  /// Export data to CSV
  Future<Either<Failure, String>> exportToCsv(String tableName);

  /// Export data to Excel
  Future<Either<Failure, String>> exportToExcel();

  /// Validate backup file
  Future<Either<Failure, bool>> validateBackupFile(String filePath);

  /// Get backup statistics
  Future<Either<Failure, Map<String, dynamic>>> getBackupStatistics();

  /// Schedule auto backup
  Future<Either<Failure, void>> scheduleAutoBackup({
    required String frequency, // daily, weekly, monthly
    required String time,
  });

  /// Cancel auto backup
  Future<Either<Failure, void>> cancelAutoBackup();
}
