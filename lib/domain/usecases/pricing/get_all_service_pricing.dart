import 'package:dartz/dartz.dart';
import '../../entities/service_pricing.dart';
import '../../repositories/service_repository.dart';
import '../../../core/error/failures.dart';

class GetAllServicePricing {
  final ServiceRepository repository;

  GetAllServicePricing(this.repository);

  Future<Either<Failure, List<ServicePricing>>> call() async {
    return await repository.getAllServicePricing();
  }
}
