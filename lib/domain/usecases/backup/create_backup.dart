import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/backup_info.dart';
import '../../repositories/backup_repository.dart';

class CreateBackup {
  final BackupRepository repository;

  CreateBackup(this.repository);

  Future<Either<Failure, BackupInfo>> call({
    String? notes,
    bool isAutoBackup = false,
  }) async {
    return await repository.createBackup(
      notes: notes,
      isAutoBackup: isAutoBackup,
    );
  }
}
