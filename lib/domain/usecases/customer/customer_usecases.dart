import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/customer.dart';
import '../../repositories/customer_repository.dart';

/// Get all customers
class GetAllCustomers {
  final CustomerRepository repository;

  GetAllCustomers(this.repository);

  Future<Either<Failure, List<Customer>>> call() {
    return repository.getAllCustomers();
  }
}

/// Get customer by ID
class GetCustomerById {
  final CustomerRepository repository;

  GetCustomerById(this.repository);

  Future<Either<Failure, Customer>> call(int id) {
    return repository.getCustomerById(id);
  }
}

/// Search customers
class SearchCustomers {
  final CustomerRepository repository;

  SearchCustomers(this.repository);

  Future<Either<Failure, List<Customer>>> call(String query) {
    if (query.isEmpty) {
      return repository.getAllCustomers();
    }
    return repository.searchCustomers(query);
  }
}

/// Get customers by type
class GetCustomersByType {
  final CustomerRepository repository;

  GetCustomersByType(this.repository);

  Future<Either<Failure, List<Customer>>> call(String type) {
    return repository.getCustomersByType(type);
  }
}

/// Add customer
class AddCustomer {
  final CustomerRepository repository;

  AddCustomer(this.repository);

  Future<Either<Failure, Customer>> call(Customer customer) {
    return repository.addCustomer(customer);
  }
}

/// Update customer
class UpdateCustomer {
  final CustomerRepository repository;

  UpdateCustomer(this.repository);

  Future<Either<Failure, Customer>> call(Customer customer) {
    return repository.updateCustomer(customer);
  }
}

/// Delete customer
class DeleteCustomer {
  final CustomerRepository repository;

  DeleteCustomer(this.repository);

  Future<Either<Failure, void>> call(int id) {
    return repository.deleteCustomer(id);
  }
}

/// Get customer count
class GetCustomerCount {
  final CustomerRepository repository;

  GetCustomerCount(this.repository);

  Future<Either<Failure, int>> call() {
    return repository.getCustomerCount();
  }
}
