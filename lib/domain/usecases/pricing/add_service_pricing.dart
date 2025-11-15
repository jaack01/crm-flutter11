import 'package:dartz/dartz.dart';
import '../../entities/service_pricing.dart';
import '../../repositories/service_repository.dart';
import '../../../core/error/failures.dart';

class AddServicePricing {
  final ServiceRepository repository;

  AddServicePricing(this.repository);

  Future<Either<Failure, ServicePricing>> call(ServicePricing pricing) async {
    return await repository.addServicePricing(pricing);
  }
}
