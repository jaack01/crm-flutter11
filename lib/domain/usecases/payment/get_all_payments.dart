import 'package:dartz/dartz.dart';
import '../../entities/payment.dart';
import '../../repositories/payment_repository.dart';
import '../../../core/error/failures.dart';

class GetAllPayments {
  final PaymentRepository repository;

  GetAllPayments(this.repository);

  Future<Either<Failure, List<Payment>>> call() async {
    return await repository.getAllPayments();
  }
}
