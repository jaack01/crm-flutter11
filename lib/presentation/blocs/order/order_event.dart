import 'package:equatable/equatable.dart';
import '../../../domain/entities/order.dart';
import '../../../domain/entities/order_item.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class LoadOrders extends OrderEvent {
  const LoadOrders();
}

class LoadOrdersByStatus extends OrderEvent {
  final String status;

  const LoadOrdersByStatus(this.status);

  @override
  List<Object?> get props => [status];
}

class SearchOrdersEvent extends OrderEvent {
  final String query;

  const SearchOrdersEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class LoadOrderById extends OrderEvent {
  final int id;

  const LoadOrderById(this.id);

  @override
  List<Object?> get props => [id];
}

class AddOrderEvent extends OrderEvent {
  final Order order;
  final List<OrderItem> items;

  const AddOrderEvent(this.order, this.items);

  @override
  List<Object?> get props => [order, items];
}

class UpdateOrderEvent extends OrderEvent {
  final Order order;

  const UpdateOrderEvent(this.order);

  @override
  List<Object?> get props => [order];
}

class UpdateOrderStatusEvent extends OrderEvent {
  final int orderId;
  final String status;

  const UpdateOrderStatusEvent(this.orderId, this.status);

  @override
  List<Object?> get props => [orderId, status];
}
