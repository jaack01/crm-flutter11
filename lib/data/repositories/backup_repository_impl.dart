import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/backup_info.dart';
import '../../domain/repositories/backup_repository.dart';
import '../datasources/local/backup_local_datasource.dart';

class BackupRepositoryImpl implements BackupRepository {
  final BackupLocalDataSource localDataSource;

  BackupRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, BackupInfo>> createBackup({
    String? notes,
    bool isAutoBackup = false,
  }) async {
    try {
      final result = await localDataSource.createBackup(
        notes: notes,
        isAutoBackup: isAutoBackup,
      );
      return Right(result.toEntity());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> restoreBackup(String filePath) async {
    try {
      await localDataSource.restoreBackup(filePath);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BackupInfo>>> getAllBackups() async {
    try {
      final result = await localDataSource.getAllBackups();
      return Right(result.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BackupInfo>> getBackupById(int id) async {
    try {
      final result = await localDataSource.getBackupById(id);
      return Right(result.toEntity());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBackup(int id) async {
    try {
      await localDataSource.deleteBackup(id);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> exportToJson() async {
    try {
      final result = await localDataSource.exportToJson();
      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> exportToCsv(String tableName) async {
    try {
      final result = await localDataSource.exportToCsv(tableName);
      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> exportToExcel() async {
    // TODO: Implement Excel export functionality
    // This would require the excel package and more complex implementation
    return const Left(DatabaseFailure('Excel export not yet implemented'));
  }

  @override
  Future<Either<Failure, bool>> validateBackupFile(String filePath) async {
    try {
      final result = await localDataSource.validateBackupFile(filePath);
      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getBackupStatistics() async {
    try {
      final result = await localDataSource.getBackupStatistics();
      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> scheduleAutoBackup({
    required String frequency,
    required String time,
  }) async {
    // TODO: Implement auto backup scheduling
    // This would require using WorkManager or similar for background tasks
    return const Left(DatabaseFailure('Auto backup scheduling not yet implemented'));
  }

  @override
  Future<Either<Failure, void>> cancelAutoBackup() async {
    // TODO: Implement cancel auto backup
    return const Left(DatabaseFailure('Cancel auto backup not yet implemented'));
  }
}
