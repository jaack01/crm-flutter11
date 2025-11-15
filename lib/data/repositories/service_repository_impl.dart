import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/service.dart';
import '../../domain/entities/item_type.dart';
import '../../domain/entities/service_pricing.dart';
import '../../domain/repositories/service_repository.dart';
import '../datasources/local/service_local_datasource.dart';
import '../models/service_model.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final ServiceLocalDataSource localDataSource;

  ServiceRepositoryImpl({required this.localDataSource});

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

  // Item Type operations - Simplified (not fully implemented)
  @override
  Future<Either<Failure, List<ItemType>>> getAllItemTypes() async {
    return Left(DatabaseFailure('Not implemented'));
  }

  @override
  Future<Either<Failure, ItemType>> getItemTypeById(int id) async {
    return Left(DatabaseFailure('Not implemented'));
  }

  @override
  Future<Either<Failure, List<ItemType>>> getItemTypesByCategory(String category) async {
    return Left(DatabaseFailure('Not implemented'));
  }

  @override
  Future<Either<Failure, ItemType>> addItemType(ItemType itemType) async {
    return Left(DatabaseFailure('Not implemented'));
  }

  @override
  Future<Either<Failure, ItemType>> updateItemType(ItemType itemType) async {
    return Left(DatabaseFailure('Not implemented'));
  }

  @override
  Future<Either<Failure, void>> deleteItemType(int id) async {
    return Left(DatabaseFailure('Not implemented'));
  }

  // Service Pricing operations - Simplified (not fully implemented)
  @override
  Future<Either<Failure, List<ServicePricing>>> getAllServicePricing() async {
    return Left(DatabaseFailure('Not implemented'));
  }

  @override
  Future<Either<Failure, ServicePricing>> getServicePricing(int serviceId, int itemTypeId) async {
    return Left(DatabaseFailure('Not implemented'));
  }

  @override
  Future<Either<Failure, List<ServicePricing>>> getPricingByService(int serviceId) async {
    return Left(DatabaseFailure('Not implemented'));
  }

  @override
  Future<Either<Failure, List<ServicePricing>>> getPricingByItemType(int itemTypeId) async {
    return Left(DatabaseFailure('Not implemented'));
  }

  @override
  Future<Either<Failure, ServicePricing>> addServicePricing(ServicePricing pricing) async {
    return Left(DatabaseFailure('Not implemented'));
  }

  @override
  Future<Either<Failure, ServicePricing>> updateServicePricing(ServicePricing pricing) async {
    return Left(DatabaseFailure('Not implemented'));
  }

  @override
  Future<Either<Failure, void>> deleteServicePricing(int id) async {
    return Left(DatabaseFailure('Not implemented'));
  }
}
