import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/service.dart';
import '../entities/item_type.dart';
import '../entities/service_pricing.dart';

abstract class ServiceRepository {
  // Service operations
  Future<Either<Failure, List<Service>>> getAllServices();
  Future<Either<Failure, Service>> getServiceById(int id);
  Future<Either<Failure, Service>> addService(Service service);
  Future<Either<Failure, Service>> updateService(Service service);
  Future<Either<Failure, void>> deleteService(int id);

  // Item Type operations
  Future<Either<Failure, List<ItemType>>> getAllItemTypes();
  Future<Either<Failure, ItemType>> getItemTypeById(int id);
  Future<Either<Failure, List<ItemType>>> getItemTypesByCategory(String category);
  Future<Either<Failure, ItemType>> addItemType(ItemType itemType);
  Future<Either<Failure, ItemType>> updateItemType(ItemType itemType);
  Future<Either<Failure, void>> deleteItemType(int id);

  // Service Pricing operations
  Future<Either<Failure, List<ServicePricing>>> getAllServicePricing();
  Future<Either<Failure, ServicePricing>> getServicePricing(int serviceId, int itemTypeId);
  Future<Either<Failure, List<ServicePricing>>> getPricingByService(int serviceId);
  Future<Either<Failure, List<ServicePricing>>> getPricingByItemType(int itemTypeId);
  Future<Either<Failure, ServicePricing>> addServicePricing(ServicePricing pricing);
  Future<Either<Failure, ServicePricing>> updateServicePricing(ServicePricing pricing);
  Future<Either<Failure, void>> deleteServicePricing(int id);
}
