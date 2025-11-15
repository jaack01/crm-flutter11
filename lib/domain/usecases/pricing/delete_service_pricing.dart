import 'package:dartz/dartz.dart';
import '../../repositories/service_repository.dart';
import '../../../core/error/failures.dart';

class DeleteServicePricing {
  final ServiceRepository repository;

  DeleteServicePricing(this.repository);

  Future<Either<Failure, void>> call(int id) async {
    return await repository.deleteServicePricing(id);
  }
}
