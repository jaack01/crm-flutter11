import 'package:equatable/equatable.dart';

class Order extends Equatable {
  final int? id;
  final String orderNumber;
  final int customerId;
  final DateTime orderDate;
  final DateTime? expectedDeliveryDate;
  final DateTime? actualDeliveryDate;
  final String status; // Received, Processing, Ready, Delivered, Cancelled
  final bool isRushOrder;
  final int totalItems;
  final double subtotal;
  final double discount;
  final double taxAmount;
  final double totalAmount;
  final double advancePaid;
  final double balanceAmount;
  final String paymentStatus; // Pending, Partial, Paid
  final String? specialInstructions;
  final int? createdBy;
  final DateTime updatedAt;

  // Optional populated fields
  final String? customerName;
  final String? customerPhone;

  const Order({
    this.id,
    required this.orderNumber,
    required this.customerId,
    required this.orderDate,
    this.expectedDeliveryDate,
    this.actualDeliveryDate,
    this.status = 'Received',
    this.isRushOrder = false,
    this.totalItems = 0,
    this.subtotal = 0.0,
    this.discount = 0.0,
    this.taxAmount = 0.0,
    this.totalAmount = 0.0,
    this.advancePaid = 0.0,
    this.balanceAmount = 0.0,
    this.paymentStatus = 'Pending',
    this.specialInstructions,
    this.createdBy,
    required this.updatedAt,
    this.customerName,
    this.customerPhone,
  });

  /// Check if order is overdue
  bool get isOverdue {
    if (expectedDeliveryDate == null) return false;
    if (status == 'Delivered' || status == 'Cancelled') return false;
    return DateTime.now().isAfter(expectedDeliveryDate!);
  }

  /// Check if payment is complete
  bool get isPaymentComplete => paymentStatus == 'Paid';

  /// Check if order is active
  bool get isActive => status != 'Delivered' && status != 'Cancelled';

  Order copyWith({
    int? id,
    String? orderNumber,
    int? customerId,
    DateTime? orderDate,
    DateTime? expectedDeliveryDate,
    DateTime? actualDeliveryDate,
    String? status,
    bool? isRushOrder,
    int? totalItems,
    double? subtotal,
    double? discount,
    double? taxAmount,
    double? totalAmount,
    double? advancePaid,
    double? balanceAmount,
    String? paymentStatus,
    String? specialInstructions,
    int? createdBy,
    DateTime? updatedAt,
    String? customerName,
    String? customerPhone,
  }) {
    return Order(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      customerId: customerId ?? this.customerId,
      orderDate: orderDate ?? this.orderDate,
      expectedDeliveryDate: expectedDeliveryDate ?? this.expectedDeliveryDate,
      actualDeliveryDate: actualDeliveryDate ?? this.actualDeliveryDate,
      status: status ?? this.status,
      isRushOrder: isRushOrder ?? this.isRushOrder,
      totalItems: totalItems ?? this.totalItems,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      taxAmount: taxAmount ?? this.taxAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      advancePaid: advancePaid ?? this.advancePaid,
      balanceAmount: balanceAmount ?? this.balanceAmount,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      createdBy: createdBy ?? this.createdBy,
      updatedAt: updatedAt ?? this.updatedAt,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
    );
  }

  @override
  List<Object?> get props => [
        id,
        orderNumber,
        customerId,
        orderDate,
        expectedDeliveryDate,
        actualDeliveryDate,
        status,
        isRushOrder,
        totalItems,
        subtotal,
        discount,
        taxAmount,
        totalAmount,
        advancePaid,
        balanceAmount,
        paymentStatus,
        specialInstructions,
        createdBy,
        updatedAt,
        customerName,
        customerPhone,
      ];
}
