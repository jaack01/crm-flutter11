import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/qr_service.dart';
import '../../../core/services/pdf_service.dart';
import '../../../core/di/injection_container.dart';
import '../../../domain/entities/order.dart';
import '../../../domain/entities/order_item.dart';
import '../../../domain/entities/customer.dart';
import '../../../domain/entities/shop_settings.dart';
import '../../../domain/usecases/customer/customer_usecases.dart';
import '../../../domain/usecases/settings/get_shop_settings.dart';
import '../../blocs/order/order_bloc.dart';
import '../../blocs/order/order_event.dart';
import '../../blocs/order/order_state.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/error_display_widget.dart';

class OrderDetailsPage extends StatefulWidget {
  final int orderId;

  const OrderDetailsPage({super.key, required this.orderId});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  Order? _order;
  List<OrderItem> _orderItems = [];

  @override
  void initState() {
    super.initState();
    _loadOrder();
  }

  void _loadOrder() {
    context.read<OrderBloc>().add(LoadOrderById(widget.orderId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code),
            onPressed: _order != null ? () => _showQRCode() : null,
            tooltip: 'Show QR Code',
          ),
          IconButton(
            icon: const Icon(Icons.receipt_long),
            onPressed: _order != null ? () => _showInvoice() : null,
            tooltip: 'View Invoice',
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _order != null ? () => _generatePdf() : null,
            tooltip: 'Download PDF',
          ),
        ],
      ),
      body: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrderLoaded) {
            setState(() {
              _order = state.order;
            });
            // Load order items
            // Note: In a real implementation, you'd have a separate event/state for this
          } else if (state is OrderOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            _loadOrder();
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
            return const LoadingWidget(message: 'Loading order details...');
          }

          if (state is OrderError) {
            return ErrorDisplayWidget(
              message: state.message,
              onRetry: _loadOrder,
            );
          }

          if (_order == null) {
            return const Center(child: Text('Order not found'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              _loadOrder();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOrderHeader(),
                  const SizedBox(height: 16),
                  _buildCustomerInfo(),
                  const SizedBox(height: 16),
                  _buildOrderDates(),
                  const SizedBox(height: 16),
                  _buildOrderItems(),
                  const SizedBox(height: 16),
                  _buildPricingBreakdown(),
                  const SizedBox(height: 16),
                  _buildPaymentInfo(),
                  const SizedBox(height: 16),
                  if (_order!.notes != null && _order!.notes!.isNotEmpty)
                    _buildNotes(),
                  const SizedBox(height: 16),
                  _buildActions(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrderHeader() {
    Color statusColor = _getStatusColor(_order!.status);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _order!.orderNumber,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Created: ${DateFormat('MMM dd, yyyy').format(_order!.orderDate)}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                if (_order!.isRushOrder)
                  Chip(
                    label: const Text('RUSH', style: TextStyle(fontSize: 10)),
                    backgroundColor: AppColors.errorColor.withOpacity(0.2),
                    avatar: const Icon(Icons.bolt, size: 16),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _showStatusUpdateDialog(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.circle, color: statusColor, size: 12),
                          const SizedBox(width: 8),
                          Text(
                            _order!.status,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.edit, size: 16, color: statusColor),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Customer Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: Text(
                _order!.customerName ?? 'Unknown Customer',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('Tap to view customer details'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Navigate to customer details
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Customer details coming soon')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderDates() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Important Dates',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            _buildDateRow(
              'Order Date',
              _order!.orderDate,
              Icons.calendar_today,
            ),
            const SizedBox(height: 8),
            _buildDateRow(
              'Expected Delivery',
              _order!.expectedDeliveryDate,
              Icons.local_shipping,
              isHighlighted: _order!.isOverdue,
            ),
            if (_order!.actualDeliveryDate != null) ...[
              const SizedBox(height: 8),
              _buildDateRow(
                'Actual Delivery',
                _order!.actualDeliveryDate!,
                Icons.check_circle,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDateRow(String label, DateTime date, IconData icon,
      {bool isHighlighted = false}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: isHighlighted ? AppColors.errorColor : null),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: isHighlighted ? AppColors.errorColor : Colors.grey[600],
              fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        Text(
          DateFormat('MMM dd, yyyy').format(date),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isHighlighted ? AppColors.errorColor : null,
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItems() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Order Items',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Chip(
                  label: Text('${_order!.totalItems} items'),
                  backgroundColor: AppColors.primaryColor.withOpacity(0.2),
                ),
              ],
            ),
            const Divider(),
            // Mock order items - in real implementation, fetch from database
            _buildOrderItemRow('Wash & Fold', 5, 100.0, 500.0),
            const Divider(height: 1),
            _buildOrderItemRow('Dry Cleaning', 2, 150.0, 300.0),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItemRow(
      String serviceName, int quantity, double unitPrice, double total) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  serviceName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Qty: $quantity × ₹${unitPrice.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Text(
            '₹${total.toStringAsFixed(2)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingBreakdown() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pricing Breakdown',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            _buildPriceRow('Subtotal', _order!.subtotal),
            const SizedBox(height: 8),
            _buildPriceRow('Discount', -_order!.discount,
                color: AppColors.successColor),
            const SizedBox(height: 8),
            _buildPriceRow('Tax', _order!.taxAmount),
            const Divider(),
            _buildPriceRow('Total Amount', _order!.totalAmount,
                isBold: true, fontSize: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentInfo() {
    Color paymentStatusColor;
    switch (_order!.paymentStatus) {
      case 'Paid':
        paymentStatusColor = AppColors.successColor;
        break;
      case 'Partial':
        paymentStatusColor = AppColors.warningColor;
        break;
      default:
        paymentStatusColor = AppColors.errorColor;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Payment Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Chip(
                  label: Text(_order!.paymentStatus),
                  backgroundColor: paymentStatusColor.withOpacity(0.2),
                  labelStyle: TextStyle(
                    color: paymentStatusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            _buildPriceRow('Advance Paid', _order!.advancePaid,
                color: AppColors.successColor),
            const SizedBox(height: 8),
            _buildPriceRow('Balance Amount', _order!.balanceAmount,
                color: AppColors.warningColor, isBold: true, fontSize: 16),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _recordPayment(),
              icon: const Icon(Icons.payment),
              label: const Text('Record Payment'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount,
      {Color? color, bool isBold = false, double fontSize = 14}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: fontSize,
          ),
        ),
        Text(
          '₹${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: fontSize,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildNotes() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            Text(_order!.notes!),
          ],
        ),
      ),
    );
  }

  Widget _buildActions() {
    return Column(
      children: [
        OutlinedButton.icon(
          onPressed: () => _showQRCode(),
          icon: const Icon(Icons.qr_code),
          label: const Text('Show QR Code'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => _showInvoice(),
          icon: const Icon(Icons.receipt_long),
          label: const Text('View Invoice'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Received':
        return AppColors.statusReceived;
      case 'Processing':
        return AppColors.statusProcessing;
      case 'Ready':
        return AppColors.statusReady;
      case 'Delivered':
        return AppColors.statusDelivered;
      case 'Cancelled':
        return AppColors.statusCancelled;
      default:
        return Colors.grey;
    }
  }

  void _showStatusUpdateDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Update Order Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppConstants.orderStatuses.map((status) {
            final isCurrentStatus = status == _order!.status;
            return ListTile(
              leading: Icon(
                isCurrentStatus ? Icons.check_circle : Icons.circle_outlined,
                color: _getStatusColor(status),
              ),
              title: Text(status),
              selected: isCurrentStatus,
              onTap: isCurrentStatus
                  ? null
                  : () {
                      Navigator.pop(dialogContext);
                      _updateOrderStatus(status);
                    },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _updateOrderStatus(String newStatus) {
    context.read<OrderBloc>().add(
          UpdateOrderStatusEvent(orderId: _order!.id!, status: newStatus),
        );
  }

  void _recordPayment() {
    context.push('/payments');
  }

  void _showQRCode() {
    final qrService = QrService();
    final qrData = qrService.generateQrData(
      type: 'order',
      id: _order!.id.toString(),
      data: {
        'order_number': _order!.orderNumber,
        'customer_name': _order!.customerName ?? '',
        'total_amount': _order!.totalAmount.toString(),
      },
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('QR Code - ${_order!.orderNumber}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Image.memory(
                qrService.generateQrImage(qrData),
                width: 250,
                height: 250,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _order!.orderNumber,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
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

  Future<void> _generatePdf() async {
    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Get dependencies
      final pdfService = getIt<PdfService>();
      final getCustomerById = getIt<GetCustomerById>();
      final getShopSettings = getIt<GetShopSettings>();

      // Fetch customer
      final customerResult = await getCustomerById(_order!.customerId);
      Customer? customer;
      customerResult.fold(
        (failure) => customer = null,
        (c) => customer = c,
      );

      // Fetch shop settings
      final settingsResult = await getShopSettings();
      ShopSettings? settings;
      settingsResult.fold(
        (failure) => settings = null,
        (s) => settings = s,
      );

      // Generate PDF
      final pdfBytes = await pdfService.generateInvoicePdf(
        order: _order!,
        orderItems: _orderItems,
        customer: customer ?? Customer(
          customerCode: 'UNKNOWN',
          firstName: _order!.customerName ?? 'Unknown',
          phone: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        settings: settings,
      );

      // Close loading
      if (mounted) Navigator.pop(context);

      // Share PDF
      final fileName = 'invoice_${_order!.orderNumber}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      await pdfService.printPdf(pdfBytes, fileName);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invoice PDF generated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Close loading if still open
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showInvoice() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InvoicePreviewPage(order: _order!),
      ),
    );
  }
}

class InvoicePreviewPage extends StatelessWidget {
  final Order order;

  const InvoicePreviewPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice'),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Print functionality coming soon')),
              );
            },
            tooltip: 'Print',
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share functionality coming soon')),
              );
            },
            tooltip: 'Share',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                const Center(
                  child: Text(
                    'LAUNDRY CRM',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Center(
                  child: Text(
                    'TAX INVOICE',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(thickness: 2),
                const SizedBox(height: 16),

                // Invoice Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Invoice No:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(order.orderNumber),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Date:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(DateFormat('MMM dd, yyyy').format(order.orderDate)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Bill To
                const Text(
                  'Bill To:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  order.customerName ?? 'Unknown Customer',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),

                // Items Table
                Table(
                  border: TableBorder.all(color: Colors.grey.shade300),
                  columnWidths: const {
                    0: FlexColumnWidth(3),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(1.5),
                    3: FlexColumnWidth(1.5),
                  },
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: Colors.grey.shade200),
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('Description',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('Qty',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('Rate',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('Amount',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    // Mock items - in real implementation, fetch from database
                    _buildInvoiceItemRow('Wash & Fold', 5, 100.0, 500.0),
                    _buildInvoiceItemRow('Dry Cleaning', 2, 150.0, 300.0),
                  ],
                ),
                const SizedBox(height: 24),

                // Totals
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildTotalRow('Subtotal', order.subtotal),
                    _buildTotalRow('Discount', -order.discount),
                    _buildTotalRow('Tax', order.taxAmount),
                    const Divider(),
                    _buildTotalRow('Total Amount', order.totalAmount,
                        isBold: true),
                    const SizedBox(height: 8),
                    _buildTotalRow('Advance Paid', order.advancePaid),
                    _buildTotalRow('Balance Due', order.balanceAmount,
                        isBold: true),
                  ],
                ),
                const SizedBox(height: 32),

                // Footer
                const Center(
                  child: Text(
                    'Thank you for your business!',
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TableRow _buildInvoiceItemRow(
      String description, int qty, double rate, double amount) {
    return TableRow(
      children: [
        Padding(padding: const EdgeInsets.all(8), child: Text(description)),
        Padding(padding: const EdgeInsets.all(8), child: Text('$qty')),
        Padding(
            padding: const EdgeInsets.all(8),
            child: Text('₹${rate.toStringAsFixed(2)}')),
        Padding(
            padding: const EdgeInsets.all(8),
            child: Text('₹${amount.toStringAsFixed(2)}')),
      ],
    );
  }

  Widget _buildTotalRow(String label, double amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontSize: isBold ? 16 : 14,
              ),
            ),
          ),
          SizedBox(
            width: 100,
            child: Text(
              '₹${amount.toStringAsFixed(2)}',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontSize: isBold ? 16 : 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
