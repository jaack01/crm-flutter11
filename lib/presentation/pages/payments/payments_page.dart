import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/payment.dart';
import '../../../domain/entities/order.dart';
import '../../blocs/payment/payment_bloc.dart';
import '../../blocs/payment/payment_event.dart';
import '../../blocs/payment/payment_state.dart';
import '../../blocs/order/order_bloc.dart';
import '../../blocs/order/order_event.dart';
import '../../blocs/order/order_state.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_display_widget.dart';
import '../../widgets/common/empty_state_widget.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({super.key});

  @override
  State<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  @override
  void initState() {
    super.initState();
    _loadPayments();
  }

  void _loadPayments() {
    context.read<PaymentBloc>().add(const LoadPayments());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments'),
      ),
      body: BlocConsumer<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if (state is PaymentOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            _loadPayments();
          } else if (state is PaymentError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is PaymentLoading) {
            return const LoadingWidget(message: 'Loading payments...');
          }

          if (state is PaymentError) {
            return ErrorDisplayWidget(
              message: state.message,
              onRetry: _loadPayments,
            );
          }

          if (state is PaymentsLoaded) {
            if (state.payments.isEmpty) {
              return EmptyStateWidget(
                icon: Icons.payment,
                title: 'No Payments Found',
                message: 'Payment history will appear here',
                actionLabel: 'Record Payment',
                onAction: () => _showRecordPaymentDialog(context),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                _loadPayments();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: state.payments.length,
                itemBuilder: (context, index) {
                  final payment = state.payments[index];
                  return _buildPaymentCard(payment);
                },
              ),
            );
          }

          return const Center(child: Text('Unknown state'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showRecordPaymentDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPaymentCard(Payment payment) {
    final dateFormat = DateFormat('MMM dd, yyyy HH:mm');

    Color methodColor;
    switch (payment.paymentMethod) {
      case 'Cash':
        methodColor = AppColors.successColor;
        break;
      case 'Card':
        methodColor = AppColors.primaryColor;
        break;
      case 'UPI':
        methodColor = AppColors.infoColor;
        break;
      default:
        methodColor = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: methodColor.withOpacity(0.2),
          child: Icon(
            payment.paymentMethod == 'Cash'
                ? Icons.money
                : payment.paymentMethod == 'Card'
                    ? Icons.credit_card
                    : payment.paymentMethod == 'UPI'
                        ? Icons.phone_android
                        : Icons.payment,
            color: methodColor,
          ),
        ),
        title: Text(
          '₹${payment.amount.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (payment.orderNumber != null)
              Text('Order: ${payment.orderNumber}'),
            if (payment.customerName != null)
              Text('Customer: ${payment.customerName}'),
            Text(dateFormat.format(payment.paymentDate)),
            if (payment.transactionReference != null &&
                payment.transactionReference!.isNotEmpty)
              Text(
                'Ref: ${payment.transactionReference}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
          ],
        ),
        isThreeLine: true,
        trailing: Chip(
          label: Text(
            payment.paymentMethod,
            style: const TextStyle(fontSize: 12),
          ),
          backgroundColor: methodColor.withOpacity(0.2),
        ),
      ),
    );
  }

  void _showRecordPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<PaymentBloc>()),
          BlocProvider.value(value: context.read<OrderBloc>()),
        ],
        child: const _RecordPaymentDialog(),
      ),
    );
  }
}

class _RecordPaymentDialog extends StatefulWidget {
  const _RecordPaymentDialog();

  @override
  State<_RecordPaymentDialog> createState() => _RecordPaymentDialogState();
}

class _RecordPaymentDialogState extends State<_RecordPaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _transactionRefController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _receivedByController = TextEditingController(text: 'Admin');

  Order? _selectedOrder;
  String _paymentMethod = 'Cash';
  DateTime _paymentDate = DateTime.now();
  List<Order> _orders = [];

  @override
  void initState() {
    super.initState();
    // Load orders for selection
    context.read<OrderBloc>().add(const LoadOrders());
  }

  @override
  void dispose() {
    _amountController.dispose();
    _transactionRefController.dispose();
    _notesController.dispose();
    _receivedByController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Record Payment'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Selection
              BlocBuilder<OrderBloc, OrderState>(
                builder: (context, state) {
                  if (state is OrdersLoaded) {
                    _orders = state.orders;
                  }

                  return DropdownButtonFormField<Order>(
                    value: _selectedOrder,
                    decoration: const InputDecoration(
                      labelText: 'Select Order',
                      border: OutlineInputBorder(),
                    ),
                    items: _orders.map((order) {
                      return DropdownMenuItem(
                        value: order,
                        child: Text(
                          '${order.orderNumber} - ${order.customerName ?? "Unknown"} (₹${order.balanceAmount.toStringAsFixed(2)})',
                        ),
                      );
                    }).toList(),
                    onChanged: (order) {
                      setState(() {
                        _selectedOrder = order;
                        if (order != null) {
                          _amountController.text = order.balanceAmount.toStringAsFixed(2);
                        }
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select an order';
                      }
                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: 16),

              // Amount
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                  prefixText: '₹',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Payment Method
              DropdownButtonFormField<String>(
                value: _paymentMethod,
                decoration: const InputDecoration(
                  labelText: 'Payment Method',
                  border: OutlineInputBorder(),
                ),
                items: ['Cash', 'Card', 'UPI', 'Bank Transfer', 'Other']
                    .map((method) => DropdownMenuItem(
                          value: method,
                          child: Text(method),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _paymentMethod = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Payment Date
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Payment Date'),
                subtitle: Text(DateFormat('MMM dd, yyyy HH:mm').format(_paymentDate)),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: _paymentDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(_paymentDate),
                      );
                      if (time != null) {
                        setState(() {
                          _paymentDate = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            time.hour,
                            time.minute,
                          );
                        });
                      }
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Transaction Reference
              TextFormField(
                controller: _transactionRefController,
                decoration: const InputDecoration(
                  labelText: 'Transaction Reference (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Received By
              TextFormField(
                controller: _receivedByController,
                decoration: const InputDecoration(
                  labelText: 'Received By',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter who received the payment';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Notes
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _recordPayment,
          child: const Text('Record'),
        ),
      ],
    );
  }

  void _recordPayment() {
    if (_formKey.currentState!.validate()) {
      final payment = Payment(
        orderId: _selectedOrder!.id!,
        paymentDate: _paymentDate,
        amount: double.parse(_amountController.text),
        paymentMethod: _paymentMethod,
        transactionReference: _transactionRefController.text.trim().isEmpty
            ? null
            : _transactionRefController.text.trim(),
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        receivedBy: _receivedByController.text.trim(),
      );

      context.read<PaymentBloc>().add(AddPaymentEvent(payment));
      Navigator.pop(context);
    }
  }
}
