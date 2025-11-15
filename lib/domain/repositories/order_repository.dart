import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/order.dart';
import '../entities/order_item.dart';

abstract class OrderRepository {
  // Order operations
  Future<Either<Failure, List<Order>>> getAllOrders();
  Future<Either<Failure, Order>> getOrderById(int id);
  Future<Either<Failure, Order>> getOrderByNumber(String orderNumber);
  Future<Either<Failure, List<Order>>> getOrdersByCustomer(int customerId);
  Future<Either<Failure, List<Order>>> getOrdersByStatus(String status);
  Future<Either<Failure, List<Order>>> getOrdersByDateRange(DateTime startDate, DateTime endDate);
  Future<Either<Failure, List<Order>>> searchOrders(String query);
  Future<Either<Failure, Order>> addOrder(Order order, List<OrderItem> items);
  Future<Either<Failure, Order>> updateOrder(Order order);
  Future<Either<Failure, void>> updateOrderStatus(int orderId, String status);
  Future<Either<Failure, void>> deleteOrder(int id);
  Future<Either<Failure, int>> getOrderCount();
  Future<Either<Failure, int>> getOrderCountByStatus(String status);

  // Order Item operations
  Future<Either<Failure, List<OrderItem>>> getOrderItems(int orderId);
  Future<Either<Failure, OrderItem>> addOrderItem(OrderItem item);
  Future<Either<Failure, OrderItem>> updateOrderItem(OrderItem item);
  Future<Either<Failure, void>> deleteOrderItem(int id);

  // Statistics
  Future<Either<Failure, double>> getTotalRevenue(DateTime startDate, DateTime endDate);
  Future<Either<Failure, double>> getTotalOutstanding();
}
