import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/order.dart';
import '../../repositories/order_repository.dart';

class GetOrdersByStatus {
  final OrderRepository repository;

  GetOrdersByStatus(this.repository);

  Future<Either<Failure, List<Order>>> call(String status) async {
    return await repository.getOrdersByStatus(status);
  }
}
