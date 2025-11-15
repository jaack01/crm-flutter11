import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../repositories/order_repository.dart';

class UpdateOrderStatus {
  final OrderRepository repository;

  UpdateOrderStatus(this.repository);

  Future<Either<Failure, void>> call(int orderId, String status) async {
    return await repository.updateOrderStatus(orderId, status);
  }
}
