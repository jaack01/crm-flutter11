import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/payment.dart';

abstract class PaymentRepository {
  /// Get all payments
  Future<Either<Failure, List<Payment>>> getAllPayments();

  /// Get payment by ID
  Future<Either<Failure, Payment>> getPaymentById(int id);

  /// Get payments by order
  Future<Either<Failure, List<Payment>>> getPaymentsByOrder(int orderId);

  /// Get payments by date range
  Future<Either<Failure, List<Payment>>> getPaymentsByDateRange(
    DateTime startDate,
    DateTime endDate,
  );

  /// Get payments by method
  Future<Either<Failure, List<Payment>>> getPaymentsByMethod(String method);

  /// Add new payment
  Future<Either<Failure, Payment>> addPayment(Payment payment);

  /// Update payment
  Future<Either<Failure, Payment>> updatePayment(Payment payment);

  /// Delete payment
  Future<Either<Failure, void>> deletePayment(int id);

  /// Get total payments for an order
  Future<Either<Failure, double>> getTotalPaymentsForOrder(int orderId);

  /// Get total payments by date range
  Future<Either<Failure, double>> getTotalPaymentsByDateRange(
    DateTime startDate,
    DateTime endDate,
  );
}
