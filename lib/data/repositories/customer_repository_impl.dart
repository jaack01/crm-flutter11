import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/customer.dart';
import '../../domain/repositories/customer_repository.dart';
import '../datasources/local/customer_local_datasource.dart';
import '../models/customer_model.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerLocalDataSource localDataSource;

  CustomerRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Customer>>> getAllCustomers() async {
    try {
      final List<CustomerModel> customers = await localDataSource.getAllCustomers();
      return Right(customers.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Customer>> getCustomerById(int id) async {
    try {
      final CustomerModel customer = await localDataSource.getCustomerById(id);
      return Right(customer.toEntity());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Customer>> getCustomerByPhone(String phone) async {
    try {
      final CustomerModel? customer = await localDataSource.getCustomerByPhone(phone);
      if (customer == null) {
        return const Left(NotFoundFailure('Customer not found'));
      }
      return Right(customer.toEntity());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Customer>>> searchCustomers(String query) async {
    try {
      final List<CustomerModel> customers = await localDataSource.searchCustomers(query);
      return Right(customers.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Customer>>> getCustomersByType(String type) async {
    try {
      final List<CustomerModel> customers = await localDataSource.getCustomersByType(type);
      return Right(customers.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Customer>> addCustomer(Customer customer) async {
    try {
      // Generate customer code if not provided
      String customerCode = customer.customerCode;
      if (customerCode.isEmpty) {
        customerCode = await localDataSource.generateNextCustomerCode();
      }

      final CustomerModel customerModel = CustomerModel(
        customerCode: customerCode,
        firstName: customer.firstName,
        lastName: customer.lastName,
        phone: customer.phone,
        email: customer.email,
        alternatePhone: customer.alternatePhone,
        address: customer.address,
        city: customer.city,
        pincode: customer.pincode,
        customerType: customer.customerType,
        loyaltyPoints: customer.loyaltyPoints,
        photoPath: customer.photoPath,
        notes: customer.notes,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isActive: true,
      );

      final int id = await localDataSource.insertCustomer(customerModel);
      final CustomerModel savedCustomer = await localDataSource.getCustomerById(id);
      return Right(savedCustomer.toEntity());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Customer>> updateCustomer(Customer customer) async {
    try {
      if (customer.id == null) {
        return const Left(ValidationFailure('Customer ID is required for update'));
      }

      final CustomerModel customerModel = CustomerModel(
        id: customer.id,
        customerCode: customer.customerCode,
        firstName: customer.firstName,
        lastName: customer.lastName,
        phone: customer.phone,
        email: customer.email,
        alternatePhone: customer.alternatePhone,
        address: customer.address,
        city: customer.city,
        pincode: customer.pincode,
        customerType: customer.customerType,
        loyaltyPoints: customer.loyaltyPoints,
        photoPath: customer.photoPath,
        notes: customer.notes,
        createdAt: customer.createdAt,
        updatedAt: DateTime.now(),
        isActive: customer.isActive,
      );

      await localDataSource.updateCustomer(customerModel);
      final CustomerModel updatedCustomer = await localDataSource.getCustomerById(customer.id!);
      return Right(updatedCustomer.toEntity());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCustomer(int id) async {
    try {
      await localDataSource.deleteCustomer(id);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getCustomerCount() async {
    try {
      final int count = await localDataSource.getCustomerCount();
      return Right(count);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateLoyaltyPoints(int customerId, int points) async {
    try {
      final CustomerModel customer = await localDataSource.getCustomerById(customerId);
      final CustomerModel updatedCustomer = CustomerModel(
        id: customer.id,
        customerCode: customer.customerCode,
        firstName: customer.firstName,
        lastName: customer.lastName,
        phone: customer.phone,
        email: customer.email,
        alternatePhone: customer.alternatePhone,
        address: customer.address,
        city: customer.city,
        pincode: customer.pincode,
        customerType: customer.customerType,
        loyaltyPoints: points,
        photoPath: customer.photoPath,
        notes: customer.notes,
        createdAt: customer.createdAt,
        updatedAt: DateTime.now(),
        isActive: customer.isActive,
      );
      await localDataSource.updateCustomer(updatedCustomer);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
