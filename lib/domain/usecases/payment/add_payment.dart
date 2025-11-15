import 'package:dartz/dartz.dart';
import '../../entities/payment.dart';
import '../../repositories/payment_repository.dart';
import '../../../core/error/failures.dart';

class AddPayment {
  final PaymentRepository repository;

  AddPayment(this.repository);

  Future<Either<Failure, Payment>> call(Payment payment) async {
    return await repository.addPayment(payment);
  }
}
