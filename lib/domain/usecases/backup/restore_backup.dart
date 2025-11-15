import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/backup_repository.dart';

class RestoreBackup {
  final BackupRepository repository;

  RestoreBackup(this.repository);

  Future<Either<Failure, void>> call(String filePath) async {
    return await repository.restoreBackup(filePath);
  }
}
