import 'package:dartz/dartz.dart';
import '../../entities/service_pricing.dart';
import '../../repositories/service_repository.dart';
import '../../../core/error/failures.dart';

class GetPricingByItemType {
  final ServiceRepository repository;

  GetPricingByItemType(this.repository);

  Future<Either<Failure, List<ServicePricing>>> call(int itemTypeId) async {
    return await repository.getPricingByItemType(itemTypeId);
  }
}
