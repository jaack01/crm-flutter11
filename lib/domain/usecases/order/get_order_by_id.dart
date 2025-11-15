import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/order.dart';
import '../../repositories/order_repository.dart';

class GetOrderById {
  final OrderRepository repository;

  GetOrderById(this.repository);

  Future<Either<Failure, Order>> call(int id) async {
    return await repository.getOrderById(id);
  }
}
