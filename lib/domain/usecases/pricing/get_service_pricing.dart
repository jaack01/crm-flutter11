import 'package:dartz/dartz.dart';
import '../../entities/service_pricing.dart';
import '../../repositories/service_repository.dart';
import '../../../core/error/failures.dart';

class GetServicePricing {
  final ServiceRepository repository;

  GetServicePricing(this.repository);

  Future<Either<Failure, ServicePricing>> call(int serviceId, int itemTypeId) async {
    return await repository.getServicePricing(serviceId, itemTypeId);
  }
}
