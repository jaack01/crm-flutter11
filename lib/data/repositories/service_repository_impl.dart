import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/service.dart';
import '../../domain/entities/item_type.dart';
import '../../domain/entities/service_pricing.dart';
import '../../domain/repositories/service_repository.dart';
import '../datasources/local/service_local_datasource.dart';
import '../datasources/local/item_type_local_datasource.dart';
import '../datasources/local/service_pricing_local_datasource.dart';
import '../models/service_model.dart';
import '../models/item_type_model.dart';
import '../models/service_pricing_model.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final ServiceLocalDataSource localDataSource;
  final ItemTypeLocalDataSource? itemTypeLocalDataSource;
  final ServicePricingLocalDataSource? servicePricingLocalDataSource;

  ServiceRepositoryImpl({
    required this.localDataSource,
    this.itemTypeLocalDataSource,
    this.servicePricingLocalDataSource,
  });

  @override
  Future<Either<Failure, List<Service>>> getAllServices() async {
    try {
      final result = await localDataSource.getAllServices();
      return Right(result.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Service>> getServiceById(int id) async {
    try {
      final result = await localDataSource.getServiceById(id);
      return Right(result.toEntity());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Service>> addService(Service service) async {
    try {
      final model = ServiceModel.fromEntity(service);
      await localDataSource.addService(model);
      // Return the added service - simplified
      return Right(service);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Service>> updateService(Service service) async {
    try {
      final model = ServiceModel.fromEntity(service);
      await localDataSource.updateService(model);
      return Right(service);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteService(int id) async {
    return Left(DatabaseFailure('Not implemented'));
  }

  // Item Type operations
  @override
  Future<Either<Failure, List<ItemType>>> getAllItemTypes() async {
    if (itemTypeLocalDataSource == null) {
      return Left(DatabaseFailure('Item Type data source not initialized'));
    }
    try {
      final result = await itemTypeLocalDataSource!.getAllItemTypes();
      return Right(result.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ItemType>> getItemTypeById(int id) async {
    if (itemTypeLocalDataSource == null) {
      return Left(DatabaseFailure('Item Type data source not initialized'));
    }
    try {
      final result = await itemTypeLocalDataSource!.getItemTypeById(id);
      return Right(result.toEntity());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ItemType>>> getItemTypesByCategory(String category) async {
    if (itemTypeLocalDataSource == null) {
      return Left(DatabaseFailure('Item Type data source not initialized'));
    }
    try {
      final result = await itemTypeLocalDataSource!.getItemTypesByCategory(category);
      return Right(result.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ItemType>> addItemType(ItemType itemType) async {
    if (itemTypeLocalDataSource == null) {
      return Left(DatabaseFailure('Item Type data source not initialized'));
    }
    try {
      final model = ItemTypeModel.fromEntity(itemType);
      final result = await itemTypeLocalDataSource!.addItemType(model);
      return Right(result.toEntity());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ItemType>> updateItemType(ItemType itemType) async {
    if (itemTypeLocalDataSource == null) {
      return Left(DatabaseFailure('Item Type data source not initialized'));
    }
    try {
      final model = ItemTypeModel.fromEntity(itemType);
      await itemTypeLocalDataSource!.updateItemType(model);
      return Right(itemType);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteItemType(int id) async {
    return Left(DatabaseFailure('Not implemented'));
  }

  // Service Pricing operations
  @override
  Future<Either<Failure, List<ServicePricing>>> getAllServicePricing() async {
    if (servicePricingLocalDataSource == null) {
      return Left(DatabaseFailure('Service Pricing data source not initialized'));
    }
    try {
      final result = await servicePricingLocalDataSource!.getAllServicePricing();
      return Right(result.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ServicePricing>> getServicePricing(int serviceId, int itemTypeId) async {
    if (servicePricingLocalDataSource == null) {
      return Left(DatabaseFailure('Service Pricing data source not initialized'));
    }
    try {
      final result = await servicePricingLocalDataSource!.getServicePricing(serviceId, itemTypeId);
      return Right(result.toEntity());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ServicePricing>>> getPricingByService(int serviceId) async {
    if (servicePricingLocalDataSource == null) {
      return Left(DatabaseFailure('Service Pricing data source not initialized'));
    }
    try {
      final result = await servicePricingLocalDataSource!.getPricingByService(serviceId);
      return Right(result.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ServicePricing>>> getPricingByItemType(int itemTypeId) async {
    if (servicePricingLocalDataSource == null) {
      return Left(DatabaseFailure('Service Pricing data source not initialized'));
    }
    try {
      final result = await servicePricingLocalDataSource!.getPricingByItemType(itemTypeId);
      return Right(result.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ServicePricing>> addServicePricing(ServicePricing pricing) async {
    if (servicePricingLocalDataSource == null) {
      return Left(DatabaseFailure('Service Pricing data source not initialized'));
    }
    try {
      final model = ServicePricingModel.fromEntity(pricing);
      final result = await servicePricingLocalDataSource!.addServicePricing(model);
      return Right(result.toEntity());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ServicePricing>> updateServicePricing(ServicePricing pricing) async {
    if (servicePricingLocalDataSource == null) {
      return Left(DatabaseFailure('Service Pricing data source not initialized'));
    }
    try {
      final model = ServicePricingModel.fromEntity(pricing);
      await servicePricingLocalDataSource!.updateServicePricing(model);
      return Right(pricing);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteServicePricing(int id) async {
    if (servicePricingLocalDataSource == null) {
      return Left(DatabaseFailure('Service Pricing data source not initialized'));
    }
    try {
      await servicePricingLocalDataSource!.deleteServicePricing(id);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
