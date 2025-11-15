import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/order.dart';
import '../../blocs/order/order_bloc.dart';
import '../../blocs/order/order_event.dart';
import '../../blocs/order/order_state.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_display_widget.dart';
import '../../widgets/common/empty_state_widget.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  String _selectedStatus = 'All';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  void _loadOrders() {
    if (_selectedStatus == 'All') {
      context.read<OrderBloc>().add(const LoadOrders());
    } else {
      context.read<OrderBloc>().add(LoadOrdersByStatus(_selectedStatus));
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search orders...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _loadOrders();
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    if (value.isEmpty) {
                      _loadOrders();
                    } else {
                      context.read<OrderBloc>().add(SearchOrdersEvent(value));
                    }
                  },
                ),
              ),
              SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  children: [
                    _buildStatusChip('All'),
                    ...AppConstants.orderStatuses
                        .map((status) => _buildStatusChip(status)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            _loadOrders();
          } else if (state is OrderError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is OrderLoading) {
            return const LoadingWidget(message: 'Loading orders...');
          }

          if (state is OrderError) {
            return ErrorDisplayWidget(
              message: state.message,
              onRetry: _loadOrders,
            );
          }

          if (state is OrdersLoaded) {
            if (state.orders.isEmpty) {
              return EmptyStateWidget(
                icon: Icons.receipt_long,
                title: 'No Orders Found',
                message: 'Start by creating your first order',
                actionLabel: 'Create Order',
                onAction: () {
                  // TODO: Navigate to create order
                },
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                _loadOrders();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: state.orders.length,
                itemBuilder: (context, index) {
                  final order = state.orders[index];
                  return _buildOrderCard(order);
                },
              ),
            );
          }

          return const Center(child: Text('Unknown state'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to create order
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Create order coming soon')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final isSelected = _selectedStatus == status;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(status),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedStatus = status;
          });
          _loadOrders();
        },
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    Color statusColor;
    switch (order.status) {
      case 'Received':
        statusColor = AppColors.statusReceived;
        break;
      case 'Processing':
        statusColor = AppColors.statusProcessing;
        break;
      case 'Ready':
        statusColor = AppColors.statusReady;
        break;
      case 'Delivered':
        statusColor = AppColors.statusDelivered;
        break;
      case 'Cancelled':
        statusColor = AppColors.statusCancelled;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.2),
          child: Icon(Icons.receipt, color: statusColor),
        ),
        title: Text(
          order.orderNumber,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (order.customerName != null) Text(order.customerName!),
            Text('₹${order.totalAmount.toStringAsFixed(2)}'),
            Text(
              order.orderDate.toString().split(' ')[0],
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        isThreeLine: true,
        trailing: Chip(
          label: Text(
            order.status,
            style: const TextStyle(fontSize: 12),
          ),
          backgroundColor: statusColor.withOpacity(0.2),
        ),
        onTap: () {
          // TODO: Navigate to order details
          context.read<OrderBloc>().add(LoadOrderById(order.id!));
        },
      ),
    );
  }
}
