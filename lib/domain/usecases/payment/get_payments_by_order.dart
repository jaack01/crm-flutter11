import 'package:dartz/dartz.dart';
import '../../entities/payment.dart';
import '../../repositories/payment_repository.dart';
import '../../../core/error/failures.dart';

class GetPaymentsByOrder {
  final PaymentRepository repository;

  GetPaymentsByOrder(this.repository);

  Future<Either<Failure, List<Payment>>> call(int orderId) async {
    return await repository.getPaymentsByOrder(orderId);
  }
}
