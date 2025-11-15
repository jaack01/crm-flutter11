import 'package:dartz/dartz.dart';
import '../../entities/service_pricing.dart';
import '../../repositories/service_repository.dart';
import '../../../core/error/failures.dart';

class GetPricingByService {
  final ServiceRepository repository;

  GetPricingByService(this.repository);

  Future<Either<Failure, List<ServicePricing>>> call(int serviceId) async {
    return await repository.getPricingByService(serviceId);
  }
}
