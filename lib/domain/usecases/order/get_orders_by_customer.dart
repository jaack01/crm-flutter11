import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/order.dart';
import '../../repositories/order_repository.dart';

class GetOrdersByCustomer {
  final OrderRepository repository;

  GetOrdersByCustomer(this.repository);

  Future<Either<Failure, List<Order>>> call(int customerId) async {
    return await repository.getOrdersByCustomer(customerId);
  }
}
