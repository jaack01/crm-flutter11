import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/customer.dart';
import '../../../domain/entities/order.dart';
import '../../blocs/customer/customer_bloc.dart';
import '../../blocs/customer/customer_event.dart';
import '../../blocs/customer/customer_state.dart';
import '../../blocs/order/order_bloc.dart';
import '../../blocs/order/order_event.dart';
import '../../blocs/order/order_state.dart';

class CustomerDetailsPage extends StatefulWidget {
  final int customerId;

  const CustomerDetailsPage({
    super.key,
    required this.customerId,
  });

  @override
  State<CustomerDetailsPage> createState() => _CustomerDetailsPageState();
}

class _CustomerDetailsPageState extends State<CustomerDetailsPage> {
  Customer? _customer;
  List<Order> _orders = [];
  bool _isLoadingOrders = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    context.read<CustomerBloc>().add(LoadCustomerById(widget.customerId));
    context.read<OrderBloc>().add(LoadOrdersByCustomer(widget.customerId));
  }

  // Calculate statistics
  int get totalOrders => _orders.length;

  double get totalRevenue => _orders.fold(0.0, (sum, order) => sum + order.totalAmount);

  double get pendingBalance => _orders.fold(0.0, (sum, order) => sum + order.balanceAmount);

  double get averageOrderValue => totalOrders > 0 ? totalRevenue / totalOrders : 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Details'),
        actions: [
          if (_customer != null)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                context.push('/customers/edit/${widget.customerId}').then((_) => _loadData());
              },
              tooltip: 'Edit Customer',
            ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<CustomerBloc, CustomerState>(
            listener: (context, state) {
              if (state is CustomerLoaded) {
                setState(() {
                  _customer = state.customer;
                });
              } else if (state is CustomerError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
          BlocListener<OrderBloc, OrderState>(
            listener: (context, state) {
              if (state is OrdersLoaded) {
                setState(() {
                  _orders = state.orders;
                  _isLoadingOrders = false;
                });
              } else if (state is OrderLoading) {
                setState(() {
                  _isLoadingOrders = true;
                });
              } else if (state is OrderError) {
                setState(() {
                  _isLoadingOrders = false;
                });
              }
            },
          ),
        ],
        child: BlocBuilder<CustomerBloc, CustomerState>(
          builder: (context, state) {
            if (state is CustomerLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (_customer == null) {
              return const Center(child: Text('Customer not found'));
            }

            return RefreshIndicator(
              onRefresh: () async {
                _loadData();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCustomerInfoCard(),
                    const SizedBox(height: 16),
                    _buildStatisticsCards(),
                    const SizedBox(height: 16),
                    _buildQuickActions(),
                    const SizedBox(height: 24),
                    _buildOrderHistorySection(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCustomerInfoCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                  child: _customer!.photoPath != null
                      ? ClipOval(
                          child: Image.network(
                            _customer!.photoPath!,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildDefaultAvatar();
                            },
                          ),
                        )
                      : _buildDefaultAvatar(),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _customer!.fullName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _customer!.customerCode,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      _buildCustomerTypeBadge(_customer!.customerType),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildInfoRow(Icons.phone, 'Phone', _customer!.phone),
            if (_customer!.alternatePhone != null) ...[
              const SizedBox(height: 8),
              _buildInfoRow(Icons.phone_android, 'Alternate', _customer!.alternatePhone!),
            ],
            if (_customer!.email != null) ...[
              const SizedBox(height: 8),
              _buildInfoRow(Icons.email, 'Email', _customer!.email!),
            ],
            if (_customer!.displayAddress.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildInfoRow(Icons.location_on, 'Address', _customer!.displayAddress),
            ],
            if (_customer!.notes != null && _customer!.notes!.isNotEmpty) ...[
              const Divider(height: 24),
              _buildInfoRow(Icons.note, 'Notes', _customer!.notes!),
            ],
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Loyalty Points',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${_customer!.loyaltyPoints}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Icon(
      Icons.person,
      size: 40,
      color: AppColors.primaryColor,
    );
  }

  Widget _buildCustomerTypeBadge(String type) {
    Color color;
    IconData icon;

    switch (type) {
      case 'VIP':
        color = Colors.purple;
        icon = Icons.diamond;
        break;
      case 'Regular':
        color = Colors.blue;
        icon = Icons.person;
        break;
      default:
        color = Colors.green;
        icon = Icons.person_add;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            type,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticsCards() {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Orders',
            totalOrders.toString(),
            Icons.shopping_bag,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Total Revenue',
            '₹${totalRevenue.toStringAsFixed(0)}',
            Icons.currency_rupee,
            Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              context.push('/orders/add').then((_) => _loadData());
            },
            icon: const Icon(Icons.add),
            label: const Text('New Order'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              _showCustomerStats();
            },
            icon: const Icon(Icons.analytics),
            label: const Text('View Stats'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Order History',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_orders.isNotEmpty)
              TextButton(
                onPressed: () {
                  context.push('/orders');
                },
                child: const Text('View All'),
              ),
          ],
        ),
        const SizedBox(height: 12),
        if (_isLoadingOrders)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            ),
          )
        else if (_orders.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.receipt_long,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No orders yet',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        context.push('/orders/add').then((_) => _loadData());
                      },
                      child: const Text('Create First Order'),
                    ),
                  ],
                ),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _orders.length,
            itemBuilder: (context, index) {
              final order = _orders[index];
              return _buildOrderCard(order);
            },
          ),
      ],
    );
  }

  Widget _buildOrderCard(Order order) {
    Color statusColor = _getStatusColor(order.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          context.push('/orders/${order.id}').then((_) => _loadData());
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.orderNumber,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('dd MMM yyyy, hh:mm a').format(order.orderDate),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '₹${order.totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: statusColor),
                        ),
                        child: Text(
                          order.status,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildOrderInfo(
                      Icons.shopping_bag,
                      '${order.totalItems} items',
                    ),
                  ),
                  Expanded(
                    child: _buildOrderInfo(
                      Icons.payment,
                      order.paymentStatus,
                    ),
                  ),
                  if (order.isRushOrder)
                    Icon(
                      Icons.flash_on,
                      size: 16,
                      color: Colors.orange[700],
                    ),
                ],
              ),
              if (order.balanceAmount > 0) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber, size: 16, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text(
                        'Pending: ₹${order.balanceAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'received':
        return Colors.blue;
      case 'processing':
        return Colors.orange;
      case 'ready':
        return Colors.purple;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showCustomerStats() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Customer Statistics'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatRow('Total Orders', totalOrders.toString()),
              const Divider(),
              _buildStatRow('Total Revenue', '₹${totalRevenue.toStringAsFixed(2)}'),
              const Divider(),
              _buildStatRow('Pending Balance', '₹${pendingBalance.toStringAsFixed(2)}'),
              const Divider(),
              _buildStatRow('Average Order Value', '₹${averageOrderValue.toStringAsFixed(2)}'),
              const Divider(),
              _buildStatRow('Loyalty Points', '${_customer!.loyaltyPoints}'),
              const Divider(),
              _buildStatRow('Customer Since',
                DateFormat('dd MMM yyyy').format(_customer!.createdAt)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
