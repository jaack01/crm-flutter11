import 'package:dartz/dartz.dart';
import '../../entities/service.dart';
import '../../repositories/service_repository.dart';
import '../../../core/error/failures.dart';

class UpdateService {
  final ServiceRepository repository;

  UpdateService(this.repository);

  Future<Either<Failure, Service>> call(Service service) async {
    return await repository.updateService(service);
  }
}
