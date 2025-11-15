import 'package:dartz/dartz.dart';
import '../../entities/service.dart';
import '../../repositories/service_repository.dart';
import '../../../core/error/failures.dart';

class GetServiceById {
  final ServiceRepository repository;

  GetServiceById(this.repository);

  Future<Either<Failure, Service>> call(int id) async {
    return await repository.getServiceById(id);
  }
}
