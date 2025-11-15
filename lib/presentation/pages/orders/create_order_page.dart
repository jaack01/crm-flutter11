import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/customer.dart';
import '../../../domain/entities/service.dart';
import '../../../domain/entities/order.dart';
import '../../../domain/entities/order_item.dart';
import '../../blocs/customer/customer_bloc.dart';
import '../../blocs/customer/customer_event.dart';
import '../../blocs/customer/customer_state.dart';
import '../../blocs/service/service_bloc.dart';
import '../../blocs/service/service_event.dart';
import '../../blocs/service/service_state.dart';
import '../../blocs/order/order_bloc.dart';
import '../../blocs/order/order_event.dart';
import '../../blocs/order/order_state.dart';

class CreateOrderPage extends StatefulWidget {
  const CreateOrderPage({super.key});

  @override
  State<CreateOrderPage> createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends State<CreateOrderPage> {
  final _formKey = GlobalKey<FormState>();

  Customer? _selectedCustomer;
  DateTime _orderDate = DateTime.now();
  DateTime _expectedDeliveryDate = DateTime.now().add(const Duration(days: 3));
  String _status = 'Received';
  bool _isRushOrder = false;

  final TextEditingController _discountController = TextEditingController(text: '0');
  final TextEditingController _taxController = TextEditingController(text: '18');
  final TextEditingController _advanceController = TextEditingController(text: '0');
  final TextEditingController _notesController = TextEditingController();

  final List<_OrderItemEntry> _orderItems = [];
  List<Customer> _customers = [];
  List<Service> _services = [];

  @override
  void initState() {
    super.initState();
    context.read<CustomerBloc>().add(const LoadCustomers());
    context.read<ServiceBloc>().add(const LoadServices());
  }

  @override
  void dispose() {
    _discountController.dispose();
    _taxController.dispose();
    _advanceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  double get _subtotal {
    return _orderItems.fold(0, (sum, item) => sum + (item.quantity * item.unitPrice));
  }

  double get _discount {
    return double.tryParse(_discountController.text) ?? 0;
  }

  double get _taxAmount {
    final taxRate = double.tryParse(_taxController.text) ?? 0;
    return (_subtotal - _discount) * (taxRate / 100);
  }

  double get _totalAmount {
    return _subtotal - _discount + _taxAmount;
  }

  double get _balanceAmount {
    final advance = double.tryParse(_advanceController.text) ?? 0;
    return _totalAmount - advance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Order'),
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
            Navigator.pop(context);
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
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Customer Selection
                  _buildSectionTitle('Customer Information'),
                  BlocBuilder<CustomerBloc, CustomerState>(
                    builder: (context, state) {
                      if (state is CustomersLoaded) {
                        _customers = state.customers;
                      }

                      return DropdownButtonFormField<Customer>(
                        value: _selectedCustomer,
                        decoration: const InputDecoration(
                          labelText: 'Select Customer',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                        items: _customers.map((customer) {
                          return DropdownMenuItem(
                            value: customer,
                            child: Text('${customer.name} - ${customer.phone}'),
                          );
                        }).toList(),
                        onChanged: (customer) {
                          setState(() {
                            _selectedCustomer = customer;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a customer';
                          }
                          return null;
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Order Details
                  _buildSectionTitle('Order Details'),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateField(
                          'Order Date',
                          _orderDate,
                          (date) => setState(() => _orderDate = date),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildDateField(
                          'Expected Delivery',
                          _expectedDeliveryDate,
                          (date) => setState(() => _expectedDeliveryDate = date),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _status,
                          decoration: const InputDecoration(
                            labelText: 'Status',
                            border: OutlineInputBorder(),
                          ),
                          items: AppConstants.orderStatuses
                              .map((status) => DropdownMenuItem(
                                    value: status,
                                    child: Text(status),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _status = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SwitchListTile(
                          title: const Text('Rush Order'),
                          value: _isRushOrder,
                          onChanged: (value) {
                            setState(() {
                              _isRushOrder = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Order Items
                  _buildSectionTitle('Order Items'),
                  ..._orderItems.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return _buildOrderItemCard(index, item);
                  }),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: _addOrderItem,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Item'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Pricing
                  _buildSectionTitle('Pricing'),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          _buildPriceRow('Subtotal', _subtotal, isBold: false),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _discountController,
                                  decoration: const InputDecoration(
                                    labelText: 'Discount',
                                    prefixText: '₹',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: TextFormField(
                                  controller: _taxController,
                                  decoration: const InputDecoration(
                                    labelText: 'Tax Rate',
                                    suffixText: '%',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _buildPriceRow('Tax Amount', _taxAmount, isBold: false),
                          const Divider(),
                          _buildPriceRow('Total Amount', _totalAmount, isBold: true),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _advanceController,
                            decoration: const InputDecoration(
                              labelText: 'Advance Payment',
                              prefixText: '₹',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (_) => setState(() {}),
                          ),
                          const SizedBox(height: 8),
                          _buildPriceRow('Balance Amount', _balanceAmount,
                              isBold: true, color: AppColors.warningColor),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Notes
                  TextFormField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      labelText: 'Notes (Optional)',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),

                  // Submit Button
                  ElevatedButton(
                    onPressed: _orderItems.isEmpty ? null : _createOrder,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                    ),
                    child: state is OrderLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Create Order', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDateField(String label, DateTime date, Function(DateTime) onChanged) {
    return InkWell(
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (selectedDate != null) {
          onChanged(selectedDate);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(DateFormat('MMM dd, yyyy').format(date)),
      ),
    );
  }

  Widget _buildOrderItemCard(int index, _OrderItemEntry item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.serviceName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      _orderItems.removeAt(index);
                    });
                  },
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text('Qty: ${item.quantity}'),
                ),
                Expanded(
                  child: Text('Price: ₹${item.unitPrice.toStringAsFixed(2)}'),
                ),
                Expanded(
                  child: Text(
                    'Total: ₹${(item.quantity * item.unitPrice).toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount,
      {bool isBold = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: isBold ? 16 : 14,
          ),
        ),
        Text(
          '₹${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: isBold ? 16 : 14,
            color: color,
          ),
        ),
      ],
    );
  }

  void _addOrderItem() {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<ServiceBloc>(),
        child: _AddOrderItemDialog(
          services: _services,
          onAdd: (item) {
            setState(() {
              _orderItems.add(item);
            });
          },
        ),
      ),
    );
  }

  void _createOrder() {
    if (_formKey.currentState!.validate()) {
      if (_orderItems.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please add at least one order item'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final order = Order(
        orderNumber: '', // Auto-generated
        customerId: _selectedCustomer!.id!,
        customerName: _selectedCustomer!.name,
        orderDate: _orderDate,
        expectedDeliveryDate: _expectedDeliveryDate,
        status: _status,
        isRushOrder: _isRushOrder,
        totalItems: _orderItems.length,
        subtotal: _subtotal,
        discount: _discount,
        taxAmount: _taxAmount,
        totalAmount: _totalAmount,
        advancePaid: double.tryParse(_advanceController.text) ?? 0,
        balanceAmount: _balanceAmount,
        paymentStatus: _balanceAmount == 0
            ? 'Paid'
            : (double.tryParse(_advanceController.text) ?? 0) > 0
                ? 'Partial'
                : 'Pending',
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        updatedAt: DateTime.now(),
      );

      final items = _orderItems
          .map((item) => OrderItem(
                orderId: 0, // Will be set by datasource
                serviceId: item.serviceId,
                itemTypeId: 1, // Default item type for now
                quantity: item.quantity,
                unitPrice: item.unitPrice,
                totalPrice: item.quantity * item.unitPrice,
                serviceName: item.serviceName,
              ))
          .toList();

      context.read<OrderBloc>().add(AddOrderEvent(order, items));
    }
  }
}

class _OrderItemEntry {
  final int serviceId;
  final String serviceName;
  final int quantity;
  final double unitPrice;

  _OrderItemEntry({
    required this.serviceId,
    required this.serviceName,
    required this.quantity,
    required this.unitPrice,
  });
}

class _AddOrderItemDialog extends StatefulWidget {
  final List<Service> services;
  final Function(_OrderItemEntry) onAdd;

  const _AddOrderItemDialog({
    required this.services,
    required this.onAdd,
  });

  @override
  State<_AddOrderItemDialog> createState() => _AddOrderItemDialogState();
}

class _AddOrderItemDialogState extends State<_AddOrderItemDialog> {
  final _formKey = GlobalKey<FormState>();
  Service? _selectedService;
  final TextEditingController _quantityController = TextEditingController(text: '1');
  final TextEditingController _priceController = TextEditingController();

  @override
  void dispose() {
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Order Item'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<ServiceBloc, ServiceState>(
              builder: (context, state) {
                List<Service> services = widget.services;
                if (state is ServicesLoaded) {
                  services = state.services;
                }

                return DropdownButtonFormField<Service>(
                  value: _selectedService,
                  decoration: const InputDecoration(
                    labelText: 'Service',
                    border: OutlineInputBorder(),
                  ),
                  items: services.map((service) {
                    return DropdownMenuItem(
                      value: service,
                      child: Text('${service.serviceName} - ₹${service.basePrice}'),
                    );
                  }).toList(),
                  onChanged: (service) {
                    setState(() {
                      _selectedService = service;
                      if (service != null) {
                        _priceController.text = service.basePrice.toString();
                      }
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a service';
                    }
                    return null;
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _quantityController,
              decoration: const InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter quantity';
                }
                if (int.tryParse(value) == null || int.parse(value) <= 0) {
                  return 'Please enter a valid quantity';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Unit Price',
                border: OutlineInputBorder(),
                prefixText: '₹',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter price';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid price';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onAdd(_OrderItemEntry(
                serviceId: _selectedService!.id!,
                serviceName: _selectedService!.serviceName,
                quantity: int.parse(_quantityController.text),
                unitPrice: double.parse(_priceController.text),
              ));
              Navigator.pop(context);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
