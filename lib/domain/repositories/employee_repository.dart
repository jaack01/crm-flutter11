import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/employee.dart';

abstract class EmployeeRepository {
  /// Get all employees
  Future<Either<Failure, List<Employee>>> getAllEmployees();

  /// Get employee by ID
  Future<Either<Failure, Employee>> getEmployeeById(int id);

  /// Get employees by role
  Future<Either<Failure, List<Employee>>> getEmployeesByRole(String role);

  /// Add new employee
  Future<Either<Failure, Employee>> addEmployee(Employee employee);

  /// Update employee
  Future<Either<Failure, Employee>> updateEmployee(Employee employee);

  /// Delete employee
  Future<Either<Failure, void>> deleteEmployee(int id);

  /// Get employee count
  Future<Either<Failure, int>> getEmployeeCount();

  /// Get active employees count
  Future<Either<Failure, int>> getActiveEmployeeCount();
}
