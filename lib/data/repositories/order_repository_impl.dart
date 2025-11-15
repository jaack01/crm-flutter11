import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/order_item.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/local/order_local_datasource.dart';
import '../models/order_model.dart';
import '../models/order_item_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderLocalDataSource localDataSource;

  OrderRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Order>>> getAllOrders() async {
    try {
      final result = await localDataSource.getAllOrders();
      return Right(result.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Order>> getOrderById(int id) async {
    try {
      final result = await localDataSource.getOrderById(id);
      return Right(result.toEntity());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Order>> getOrderByNumber(String orderNumber) async {
    // Simplified - search and get first match
    try {
      final results = await localDataSource.searchOrders(orderNumber);
      if (results.isEmpty) {
        return Left(DatabaseFailure('Order not found'));
      }
      return Right(results.first.toEntity());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Order>>> getOrdersByCustomer(int customerId) async {
    try {
      final result = await localDataSource.getOrdersByCustomer(customerId);
      return Right(result.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Order>>> getOrdersByStatus(String status) async {
    try {
      final result = await localDataSource.getOrdersByStatus(status);
      return Right(result.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Order>>> getOrdersByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    // Simplified implementation
    try {
      final allOrders = await localDataSource.getAllOrders();
      final filtered = allOrders
          .where((order) =>
              order.orderDate.isAfter(startDate) &&
              order.orderDate.isBefore(endDate))
          .toList();
      return Right(filtered.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Order>>> searchOrders(String query) async {
    try {
      final result = await localDataSource.searchOrders(query);
      return Right(result.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Order>> addOrder(Order order, List<OrderItem> items) async {
    try {
      // Generate order number
      final orderNumber = await localDataSource.generateNextOrderNumber();

      final orderWithNumber = order.copyWith(orderNumber: orderNumber);
      final orderModel = OrderModel.fromEntity(orderWithNumber);
      final itemModels = items.map((item) => OrderItemModel.fromEntity(item)).toList();

      final result = await localDataSource.addOrder(orderModel, itemModels);
      return Right(result.toEntity());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Order>> updateOrder(Order order) async {
    try {
      final orderModel = OrderModel.fromEntity(order);
      await localDataSource.updateOrder(orderModel);
      final updated = await localDataSource.getOrderById(order.id!);
      return Right(updated.toEntity());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateOrderStatus(int orderId, String status) async {
    try {
      await localDataSource.updateOrderStatus(orderId, status);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteOrder(int id) async {
    // Not implemented - orders should not be deleted, only cancelled
    return Left(DatabaseFailure('Orders cannot be deleted'));
  }

  @override
  Future<Either<Failure, int>> getOrderCount() async {
    try {
      final orders = await localDataSource.getAllOrders();
      return Right(orders.length);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getOrderCountByStatus(String status) async {
    try {
      final orders = await localDataSource.getOrdersByStatus(status);
      return Right(orders.length);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<OrderItem>>> getOrderItems(int orderId) async {
    try {
      final result = await localDataSource.getOrderItems(orderId);
      return Right(result.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderItem>> addOrderItem(OrderItem item) async {
    // Not implemented in datasource yet
    return Left(DatabaseFailure('Not implemented'));
  }

  @override
  Future<Either<Failure, OrderItem>> updateOrderItem(OrderItem item) async {
    // Not implemented in datasource yet
    return Left(DatabaseFailure('Not implemented'));
  }

  @override
  Future<Either<Failure, void>> deleteOrderItem(int id) async {
    // Not implemented in datasource yet
    return Left(DatabaseFailure('Not implemented'));
  }

  @override
  Future<Either<Failure, double>> getTotalRevenue(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final orders = await localDataSource.getAllOrders();
      final filtered = orders
          .where((order) =>
              order.orderDate.isAfter(startDate) &&
              order.orderDate.isBefore(endDate) &&
              order.status != 'Cancelled')
          .toList();

      final total = filtered.fold<double>(
        0.0,
        (sum, order) => sum + order.totalAmount,
      );

      return Right(total);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, double>> getTotalOutstanding() async {
    try {
      final orders = await localDataSource.getAllOrders();
      final total = orders
          .where((order) =>
              order.status != 'Cancelled' &&
              order.paymentStatus != 'Paid')
          .fold<double>(0.0, (sum, order) => sum + order.balanceAmount);

      return Right(total);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
