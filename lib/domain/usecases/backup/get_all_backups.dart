import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/backup_info.dart';
import '../../repositories/backup_repository.dart';

class GetAllBackups {
  final BackupRepository repository;

  GetAllBackups(this.repository);

  Future<Either<Failure, List<BackupInfo>>> call() async {
    return await repository.getAllBackups();
  }
}
