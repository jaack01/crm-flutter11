import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/order.dart';
import '../../entities/order_item.dart';
import '../../repositories/order_repository.dart';

class AddOrder {
  final OrderRepository repository;

  AddOrder(this.repository);

  Future<Either<Failure, Order>> call(Order order, List<OrderItem> items) async {
    return await repository.addOrder(order, items);
  }
}
