import 'package:dartz/dartz.dart';
import '../../entities/service_pricing.dart';
import '../../repositories/service_repository.dart';
import '../../../core/error/failures.dart';

class UpdateServicePricing {
  final ServiceRepository repository;

  UpdateServicePricing(this.repository);

  Future<Either<Failure, ServicePricing>> call(ServicePricing pricing) async {
    return await repository.updateServicePricing(pricing);
  }
}
