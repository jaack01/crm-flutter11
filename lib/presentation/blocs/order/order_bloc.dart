import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/error/failures.dart';
import '../../../domain/usecases/order/get_all_orders.dart';
import '../../../domain/usecases/order/get_order_by_id.dart';
import '../../../domain/usecases/order/get_orders_by_status.dart';
import '../../../domain/usecases/order/search_orders.dart';
import '../../../domain/usecases/order/add_order.dart';
import '../../../domain/usecases/order/update_order.dart';
import '../../../domain/usecases/order/update_order_status.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final GetAllOrders getAllOrders;
  final GetOrderById getOrderById;
  final GetOrdersByStatus getOrdersByStatus;
  final SearchOrders searchOrders;
  final AddOrder addOrder;
  final UpdateOrder updateOrder;
  final UpdateOrderStatus updateOrderStatus;

  OrderBloc({
    required this.getAllOrders,
    required this.getOrderById,
    required this.getOrdersByStatus,
    required this.searchOrders,
    required this.addOrder,
    required this.updateOrder,
    required this.updateOrderStatus,
  }) : super(const OrderInitial()) {
    on<LoadOrders>(_onLoadOrders);
    on<LoadOrdersByStatus>(_onLoadOrdersByStatus);
    on<SearchOrdersEvent>(_onSearchOrders);
    on<LoadOrderById>(_onLoadOrderById);
    on<AddOrderEvent>(_onAddOrder);
    on<UpdateOrderEvent>(_onUpdateOrder);
    on<UpdateOrderStatusEvent>(_onUpdateOrderStatus);
  }

  Future<void> _onLoadOrders(
    LoadOrders event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoading());

    final result = await getAllOrders();

    result.fold(
      (failure) => emit(OrderError(_mapFailureToMessage(failure))),
      (orders) => emit(OrdersLoaded(orders)),
    );
  }

  Future<void> _onLoadOrdersByStatus(
    LoadOrdersByStatus event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoading());

    final result = await getOrdersByStatus(event.status);

    result.fold(
      (failure) => emit(OrderError(_mapFailureToMessage(failure))),
      (orders) => emit(OrdersLoaded(orders)),
    );
  }

  Future<void> _onSearchOrders(
    SearchOrdersEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoading());

    final result = await searchOrders(event.query);

    result.fold(
      (failure) => emit(OrderError(_mapFailureToMessage(failure))),
      (orders) => emit(OrdersLoaded(orders)),
    );
  }

  Future<void> _onLoadOrderById(
    LoadOrderById event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoading());

    final result = await getOrderById(event.id);

    result.fold(
      (failure) => emit(OrderError(_mapFailureToMessage(failure))),
      (order) => emit(OrderLoaded(order)),
    );
  }

  Future<void> _onAddOrder(
    AddOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoading());

    final result = await addOrder(event.order, event.items);

    result.fold(
      (failure) => emit(OrderError(_mapFailureToMessage(failure))),
      (order) {
        emit(OrderLoaded(order));
        emit(const OrderOperationSuccess('Order created successfully'));
      },
    );
  }

  Future<void> _onUpdateOrder(
    UpdateOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoading());

    final result = await updateOrder(event.order);

    result.fold(
      (failure) => emit(OrderError(_mapFailureToMessage(failure))),
      (order) {
        emit(OrderLoaded(order));
        emit(const OrderOperationSuccess('Order updated successfully'));
      },
    );
  }

  Future<void> _onUpdateOrderStatus(
    UpdateOrderStatusEvent event,
    Emitter<OrderState> emit,
  ) async {
    emit(const OrderLoading());

    final result = await updateOrderStatus(event.orderId, event.status);

    result.fold(
      (failure) => emit(OrderError(_mapFailureToMessage(failure))),
      (_) {
        emit(const OrderOperationSuccess('Order status updated'));
        // Reload order
        add(LoadOrderById(event.orderId));
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is DatabaseFailure) {
      return failure.message;
    } else if (failure is ValidationFailure) {
      return failure.message;
    }
    return 'Unexpected error occurred';
  }
}
