import 'package:dartz/dartz.dart';
import '../../entities/service.dart';
import '../../repositories/service_repository.dart';
import '../../../core/error/failures.dart';

class AddService {
  final ServiceRepository repository;

  AddService(this.repository);

  Future<Either<Failure, Service>> call(Service service) async {
    return await repository.addService(service);
  }
}
