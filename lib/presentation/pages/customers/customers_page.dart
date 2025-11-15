import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/customer.dart';
import '../../blocs/customer/customer_bloc.dart';
import '../../blocs/customer/customer_event.dart';
import '../../blocs/customer/customer_state.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_widget.dart';
import '../../widgets/common/empty_state_widget.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({Key? key}) : super(key: key);

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    // Load customers when page opens
    context.read<CustomerBloc>().add(const LoadCustomers());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    if (query.isEmpty) {
      context.read<CustomerBloc>().add(const LoadCustomers());
    } else {
      context.read<CustomerBloc>().add(SearchCustomersEvent(query));
    }
  }

  void _onFilterChanged(String? filter) {
    if (filter == null) return;
    setState(() {
      _selectedFilter = filter;
    });

    if (filter == 'All') {
      context.read<CustomerBloc>().add(const LoadCustomers());
    } else {
      context.read<CustomerBloc>().add(FilterCustomersByType(filter));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterBottomSheet();
            },
            tooltip: 'Filter',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search customers...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearch('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: _onSearch,
            ),
          ),

          // Customer List
          Expanded(
            child: BlocConsumer<CustomerBloc, CustomerState>(
              listener: (context, state) {
                if (state is CustomerOperationSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: AppColors.successColor,
                    ),
                  );
                } else if (state is CustomerError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: AppColors.errorColor,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is CustomerLoading) {
                  return const LoadingWidget(message: 'Loading customers...');
                } else if (state is CustomersLoaded) {
                  if (state.customers.isEmpty) {
                    return EmptyStateWidget(
                      icon: Icons.people_outline,
                      title: 'No Customers Found',
                      message: _searchController.text.isNotEmpty
                          ? 'No customers match your search'
                          : 'Add your first customer to get started',
                      action: ElevatedButton.icon(
                        onPressed: () {
                          context.push('/customers/add');
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add Customer'),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<CustomerBloc>().add(const LoadCustomers());
                    },
                    child: ListView.builder(
                      itemCount: state.customers.length,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemBuilder: (context, index) {
                        final Customer customer = state.customers[index];
                        return _CustomerCard(customer: customer);
                      },
                    ),
                  );
                } else if (state is CustomerError) {
                  return ErrorDisplayWidget(
                    message: state.message,
                    onRetry: () {
                      context.read<CustomerBloc>().add(const LoadCustomers());
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/customers/add');
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Customer'),
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter by Type',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              ...['All', ...AppConstants.customerTypes].map((String type) {
                return RadioListTile<String>(
                  title: Text(type),
                  value: type,
                  groupValue: _selectedFilter,
                  onChanged: (String? value) {
                    Navigator.pop(context);
                    _onFilterChanged(value);
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}

class _CustomerCard extends StatelessWidget {
  final Customer customer;

  const _CustomerCard({Key? key, required this.customer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          context.push('/customers/${customer.id}');
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: _getCustomerTypeColor(customer.customerType),
                    child: Text(
                      customer.firstName[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customer.fullName,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          customer.customerCode,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  _CustomerTypeChip(type: customer.customerType),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.phone, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(customer.phone),
                  if (customer.email != null && customer.email!.isNotEmpty) ...[
                    const SizedBox(width: 16),
                    const Icon(Icons.email, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        customer.email!,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
              if (customer.displayAddress.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        customer.displayAddress,
                        style: Theme.of(context).textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ],
              if (customer.loyaltyPoints > 0) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: AppColors.warningColor),
                    const SizedBox(width: 8),
                    Text(
                      '${customer.loyaltyPoints} Loyalty Points',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getCustomerTypeColor(String type) {
    switch (type) {
      case 'VIP':
        return AppColors.customerVip;
      case 'Regular':
        return AppColors.customerRegular;
      case 'New':
        return AppColors.customerNew;
      default:
        return AppColors.primaryColor;
    }
  }
}

class _CustomerTypeChip extends StatelessWidget {
  final String type;

  const _CustomerTypeChip({Key? key, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (type) {
      case 'VIP':
        color = AppColors.customerVip;
        break;
      case 'Regular':
        color = AppColors.customerRegular;
        break;
      case 'New':
        color = AppColors.customerNew;
        break;
      default:
        color = AppColors.primaryColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        type,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
