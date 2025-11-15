import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/customer.dart';

abstract class CustomerRepository {
  /// Get all customers
  Future<Either<Failure, List<Customer>>> getAllCustomers();

  /// Get customer by ID
  Future<Either<Failure, Customer>> getCustomerById(int id);

  /// Get customer by phone number
  Future<Either<Failure, Customer>> getCustomerByPhone(String phone);

  /// Search customers by name or phone
  Future<Either<Failure, List<Customer>>> searchCustomers(String query);

  /// Get customers by type
  Future<Either<Failure, List<Customer>>> getCustomersByType(String type);

  /// Add new customer
  Future<Either<Failure, Customer>> addCustomer(Customer customer);

  /// Update customer
  Future<Either<Failure, Customer>> updateCustomer(Customer customer);

  /// Delete customer
  Future<Either<Failure, void>> deleteCustomer(int id);

  /// Get customer count
  Future<Either<Failure, int>> getCustomerCount();

  /// Update loyalty points
  Future<Either<Failure, void>> updateLoyaltyPoints(int customerId, int points);
}
