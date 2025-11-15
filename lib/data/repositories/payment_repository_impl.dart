import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/payment.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/local/payment_local_datasource.dart';
import '../models/payment_model.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentLocalDataSource localDataSource;

  PaymentRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Payment>>> getAllPayments() async {
    try {
      final result = await localDataSource.getAllPayments();
      return Right(result.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Payment>> getPaymentById(int id) async {
    return Left(DatabaseFailure('Not implemented'));
  }

  @override
  Future<Either<Failure, List<Payment>>> getPaymentsByOrder(int orderId) async {
    try {
      final result = await localDataSource.getPaymentsByOrder(orderId);
      return Right(result.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Payment>>> getPaymentsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return Left(DatabaseFailure('Not implemented'));
  }

  @override
  Future<Either<Failure, List<Payment>>> getPaymentsByMethod(String method) async {
    return Left(DatabaseFailure('Not implemented'));
  }

  @override
  Future<Either<Failure, Payment>> addPayment(Payment payment) async {
    try {
      final model = PaymentModel.fromEntity(payment);
      final result = await localDataSource.addPayment(model);
      return Right(result.toEntity());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Payment>> updatePayment(Payment payment) async {
    return Left(DatabaseFailure('Not implemented'));
  }

  @override
  Future<Either<Failure, void>> deletePayment(int id) async {
    return Left(DatabaseFailure('Not implemented'));
  }

  @override
  Future<Either<Failure, double>> getTotalPaymentsForOrder(int orderId) async {
    try {
      final result = await localDataSource.getTotalPaymentsForOrder(orderId);
      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> getTotalPaymentsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    return Left(DatabaseFailure('Not implemented'));
  }
}
