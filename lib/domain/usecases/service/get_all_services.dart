import 'package:dartz/dartz.dart';
import '../../entities/service.dart';
import '../../repositories/service_repository.dart';
import '../../../core/error/failures.dart';

class GetAllServices {
  final ServiceRepository repository;

  GetAllServices(this.repository);

  Future<Either<Failure, List<Service>>> call() async {
    return await repository.getAllServices();
  }
}
