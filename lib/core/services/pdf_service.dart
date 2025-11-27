import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/order_item.dart';
import '../../domain/entities/customer.dart';
import '../../domain/entities/payment.dart';
import '../../domain/entities/shop_settings.dart';

class PdfService {
  /// Generate invoice PDF for an order
  Future<Uint8List> generateInvoicePdf({
    required Order order,
    required List<OrderItem> orderItems,
    required Customer customer,
    required ShopSettings? settings,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => [
          _buildInvoiceHeader(settings),
          pw.SizedBox(height: 20),
          _buildInvoiceTitle('TAX INVOICE'),
          pw.SizedBox(height: 20),
          _buildInvoiceDetails(order, customer),
          pw.SizedBox(height: 20),
          _buildOrderItemsTable(orderItems, order.isRushOrder),
          pw.SizedBox(height: 20),
          _buildPricingBreakdown(order),
          pw.SizedBox(height: 20),
          _buildPaymentSummary(order),
          pw.Spacer(),
          _buildInvoiceFooter(settings),
        ],
        footer: (context) => _buildPageFooter(context, order.orderNumber),
      ),
    );

    return pdf.save();
  }

  /// Generate receipt PDF for a payment
  Future<Uint8List> generateReceiptPdf({
    required Payment payment,
    required Order order,
    required Customer customer,
    required ShopSettings? settings,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _buildInvoiceHeader(settings),
            pw.SizedBox(height: 20),
            _buildInvoiceTitle('PAYMENT RECEIPT'),
            pw.SizedBox(height: 20),
            _buildReceiptDetails(payment, order, customer),
            pw.SizedBox(height: 30),
            _buildPaymentDetails(payment),
            pw.Spacer(),
            _buildInvoiceFooter(settings),
            pw.SizedBox(height: 20),
            _buildReceiptSignature(),
          ],
        ),
      ),
    );

    return pdf.save();
  }

  /// Build shop header with logo and details
  pw.Widget _buildInvoiceHeader(ShopSettings? settings) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  settings?.shopName ?? 'Laundry CRM',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue900,
                  ),
                ),
                pw.SizedBox(height: 4),
                if (settings?.address != null)
                  pw.Text(
                    settings!.address!,
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                if (settings?.phone != null)
                  pw.Text(
                    'Phone: ${settings!.phone!}',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                if (settings?.email != null)
                  pw.Text(
                    'Email: ${settings!.email!}',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                if (settings?.gstNumber != null)
                  pw.Text(
                    'GST: ${settings!.gstNumber!}',
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Divider(thickness: 2),
      ],
    );
  }

  /// Build invoice title
  pw.Widget _buildInvoiceTitle(String title) {
    return pw.Center(
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 20,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.blue900,
        ),
      ),
    );
  }

  /// Build invoice details section
  pw.Widget _buildInvoiceDetails(Order order, Customer customer) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'BILL TO:',
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                customer.fullName,
                style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                customer.phone,
                style: const pw.TextStyle(fontSize: 10),
              ),
              if (customer.email != null)
                pw.Text(
                  customer.email!,
                  style: const pw.TextStyle(fontSize: 10),
                ),
              if (customer.displayAddress.isNotEmpty)
                pw.Text(
                  customer.displayAddress,
                  style: const pw.TextStyle(fontSize: 10),
                ),
            ],
          ),
        ),
        pw.SizedBox(width: 20),
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Invoice No:', order.orderNumber),
              _buildDetailRow(
                'Invoice Date:',
                DateFormat('dd MMM yyyy').format(order.orderDate),
              ),
              _buildDetailRow(
                'Delivery Date:',
                DateFormat('dd MMM yyyy').format(order.expectedDeliveryDate),
              ),
              _buildDetailRow('Status:', order.status),
              if (order.isRushOrder)
                _buildDetailRow('Rush Order:', 'YES', isHighlight: true),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildDetailRow(String label, String value, {bool isHighlight = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        children: [
          pw.Container(
            width: 100,
            child: pw.Text(
              label,
              style: pw.TextStyle(
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: isHighlight ? pw.FontWeight.bold : pw.FontWeight.normal,
              color: isHighlight ? PdfColors.orange : PdfColors.black,
            ),
          ),
        ],
      ),
    );
  }

  /// Build order items table
  pw.Widget _buildOrderItemsTable(List<OrderItem> items, bool isRushOrder) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      children: [
        // Header
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.blue50),
          children: [
            _buildTableHeader('S.No'),
            _buildTableHeader('Service'),
            _buildTableHeader('Item Type'),
            _buildTableHeader('Qty'),
            _buildTableHeader('Rate'),
            _buildTableHeader('Amount'),
          ],
        ),
        // Items
        ...items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return pw.TableRow(
            children: [
              _buildTableCell('${index + 1}'),
              _buildTableCell(item.serviceName ?? '-'),
              _buildTableCell(item.itemTypeName ?? '-'),
              _buildTableCell('${item.quantity}'),
              _buildTableCell('₹${item.unitPrice.toStringAsFixed(2)}'),
              _buildTableCell('₹${item.totalPrice.toStringAsFixed(2)}'),
            ],
          );
        }),
      ],
    );
  }

  pw.Widget _buildTableHeader(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: pw.FontWeight.bold,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  pw.Widget _buildTableCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: const pw.TextStyle(fontSize: 9),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  /// Build pricing breakdown
  pw.Widget _buildPricingBreakdown(Order order) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      child: pw.Container(
        width: 250,
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.grey300),
        ),
        child: pw.Column(
          children: [
            _buildPricingRow('Subtotal:', '₹${order.subtotal.toStringAsFixed(2)}'),
            if (order.discount > 0)
              _buildPricingRow('Discount:', '-₹${order.discount.toStringAsFixed(2)}'),
            _buildPricingRow('Tax Amount:', '₹${order.taxAmount.toStringAsFixed(2)}'),
            pw.Divider(thickness: 1.5),
            _buildPricingRow(
              'Total Amount:',
              '₹${order.totalAmount.toStringAsFixed(2)}',
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }

  pw.Widget _buildPricingRow(String label, String value, {bool isBold = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: pw.BoxDecoration(
        color: isBold ? PdfColors.grey200 : null,
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: isBold ? 12 : 10,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: isBold ? 12 : 10,
              fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  /// Build payment summary
  pw.Widget _buildPaymentSummary(Order order) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: order.balanceAmount > 0 ? PdfColors.orange50 : PdfColors.green50,
        border: pw.Border.all(
          color: order.balanceAmount > 0 ? PdfColors.orange : PdfColors.green,
        ),
      ),
      child: pw.Column(
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Advance Paid:',
                style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                '₹${order.advancePaid.toStringAsFixed(2)}',
                style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
              ),
            ],
          ),
          pw.SizedBox(height: 6),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Balance Amount:',
                style: pw.TextStyle(
                  fontSize: 13,
                  fontWeight: pw.FontWeight.bold,
                  color: order.balanceAmount > 0 ? PdfColors.orange900 : PdfColors.green900,
                ),
              ),
              pw.Text(
                '₹${order.balanceAmount.toStringAsFixed(2)}',
                style: pw.TextStyle(
                  fontSize: 13,
                  fontWeight: pw.FontWeight.bold,
                  color: order.balanceAmount > 0 ? PdfColors.orange900 : PdfColors.green900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build invoice footer
  pw.Widget _buildInvoiceFooter(ShopSettings? settings) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Divider(),
        pw.SizedBox(height: 10),
        pw.Text(
          'Terms & Conditions:',
          style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          '• Please check all items before leaving the premises',
          style: const pw.TextStyle(fontSize: 8),
        ),
        pw.Text(
          '• We are not responsible for items left over 30 days',
          style: const pw.TextStyle(fontSize: 8),
        ),
        pw.Text(
          '• Color bleeding and shrinkage is not our responsibility',
          style: const pw.TextStyle(fontSize: 8),
        ),
        pw.SizedBox(height: 10),
        pw.Text(
          'Thank you for your business!',
          style: pw.TextStyle(
            fontSize: 11,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.blue900,
          ),
        ),
      ],
    );
  }

  /// Build page footer
  pw.Widget _buildPageFooter(pw.Context context, String orderNumber) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(top: 10),
      padding: const pw.EdgeInsets.only(top: 5),
      decoration: const pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: PdfColors.grey300)),
      ),
      child: pw.Text(
        'Invoice: $orderNumber | Page ${context.pageNumber}/${context.pagesCount}',
        style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
      ),
    );
  }

  /// Build receipt details
  pw.Widget _buildReceiptDetails(Payment payment, Order order, Customer customer) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'RECEIVED FROM:',
                    style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(customer.fullName, style: const pw.TextStyle(fontSize: 11)),
                  pw.Text(customer.phone, style: const pw.TextStyle(fontSize: 10)),
                ],
              ),
            ),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('Receipt No:', payment.id?.toString() ?? '-'),
                  _buildDetailRow(
                    'Receipt Date:',
                    DateFormat('dd MMM yyyy').format(payment.paymentDate),
                  ),
                  _buildDetailRow('Order No:', order.orderNumber),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Build payment details
  pw.Widget _buildPaymentDetails(Payment payment) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.green50,
        border: pw.Border.all(color: PdfColors.green),
      ),
      child: pw.Column(
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Amount Received:',
                style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                '₹${payment.amount.toStringAsFixed(2)}',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.green900,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Payment Method:', style: const pw.TextStyle(fontSize: 11)),
              pw.Text(
                payment.paymentMethod,
                style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
              ),
            ],
          ),
          if (payment.transactionId != null) ...[
            pw.SizedBox(height: 6),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Transaction ID:', style: const pw.TextStyle(fontSize: 11)),
                pw.Text(
                  payment.transactionId!,
                  style: const pw.TextStyle(fontSize: 11),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// Build receipt signature area
  pw.Widget _buildReceiptSignature() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(
              width: 150,
              height: 1,
              color: PdfColors.grey400,
            ),
            pw.SizedBox(height: 4),
            pw.Text('Customer Signature', style: const pw.TextStyle(fontSize: 9)),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(
              width: 150,
              height: 1,
              color: PdfColors.grey400,
            ),
            pw.SizedBox(height: 4),
            pw.Text('Authorized Signatory', style: const pw.TextStyle(fontSize: 9)),
          ],
        ),
      ],
    );
  }

  /// Print or share PDF
  Future<void> printPdf(Uint8List pdfBytes, String fileName) async {
    await Printing.sharePdf(
      bytes: pdfBytes,
      filename: fileName,
    );
  }

  /// Save PDF to file
  Future<File> savePdfToFile(Uint8List pdfBytes, String fileName) async {
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/$fileName');
    await file.writeAsBytes(pdfBytes);
    return file;
  }
}

/// Get temporary directory
Future<Directory> getTemporaryDirectory() async {
  // This is a placeholder - actual implementation would use path_provider
  return Directory.systemTemp;
}
