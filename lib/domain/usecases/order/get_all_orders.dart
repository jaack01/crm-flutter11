import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/order.dart';
import '../../repositories/order_repository.dart';

class GetAllOrders {
  final OrderRepository repository;

  GetAllOrders(this.repository);

  Future<Either<Failure, List<Order>>> call() async {
    return await repository.getAllOrders();
  }
}
