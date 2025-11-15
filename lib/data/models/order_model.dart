import '../../domain/entities/order.dart';

class OrderModel extends Order {
  const OrderModel({
    super.id,
    required super.orderNumber,
    required super.customerId,
    required super.orderDate,
    super.expectedDeliveryDate,
    super.actualDeliveryDate,
    super.status,
    super.isRushOrder,
    super.totalItems,
    super.subtotal,
    super.discount,
    super.taxAmount,
    super.totalAmount,
    super.advancePaid,
    super.balanceAmount,
    super.paymentStatus,
    super.specialInstructions,
    super.createdBy,
    required super.updatedAt,
    super.customerName,
    super.customerPhone,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as int?,
      orderNumber: json['order_number'] as String,
      customerId: json['customer_id'] as int,
      orderDate: DateTime.parse(json['order_date'] as String),
      expectedDeliveryDate: json['expected_delivery_date'] != null
          ? DateTime.parse(json['expected_delivery_date'] as String)
          : null,
      actualDeliveryDate: json['actual_delivery_date'] != null
          ? DateTime.parse(json['actual_delivery_date'] as String)
          : null,
      status: json['status'] as String? ?? 'Received',
      isRushOrder: (json['is_rush_order'] as int?) == 1,
      totalItems: json['total_items'] as int? ?? 0,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      taxAmount: (json['tax_amount'] as num?)?.toDouble() ?? 0.0,
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      advancePaid: (json['advance_paid'] as num?)?.toDouble() ?? 0.0,
      balanceAmount: (json['balance_amount'] as num?)?.toDouble() ?? 0.0,
      paymentStatus: json['payment_status'] as String? ?? 'Pending',
      specialInstructions: json['special_instructions'] as String?,
      createdBy: json['created_by'] as int?,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
      customerName: json['customer_name'] as String?,
      customerPhone: json['customer_phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'order_number': orderNumber,
      'customer_id': customerId,
      'order_date': orderDate.toIso8601String(),
      'expected_delivery_date': expectedDeliveryDate?.toIso8601String(),
      'actual_delivery_date': actualDeliveryDate?.toIso8601String(),
      'status': status,
      'is_rush_order': isRushOrder ? 1 : 0,
      'total_items': totalItems,
      'subtotal': subtotal,
      'discount': discount,
      'tax_amount': taxAmount,
      'total_amount': totalAmount,
      'advance_paid': advancePaid,
      'balance_amount': balanceAmount,
      'payment_status': paymentStatus,
      'special_instructions': specialInstructions,
      'created_by': createdBy,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Order toEntity() {
    return Order(
      id: id,
      orderNumber: orderNumber,
      customerId: customerId,
      orderDate: orderDate,
      expectedDeliveryDate: expectedDeliveryDate,
      actualDeliveryDate: actualDeliveryDate,
      status: status,
      isRushOrder: isRushOrder,
      totalItems: totalItems,
      subtotal: subtotal,
      discount: discount,
      taxAmount: taxAmount,
      totalAmount: totalAmount,
      advancePaid: advancePaid,
      balanceAmount: balanceAmount,
      paymentStatus: paymentStatus,
      specialInstructions: specialInstructions,
      createdBy: createdBy,
      updatedAt: updatedAt,
      customerName: customerName,
      customerPhone: customerPhone,
    );
  }

  factory OrderModel.fromEntity(Order entity) {
    return OrderModel(
      id: entity.id,
      orderNumber: entity.orderNumber,
      customerId: entity.customerId,
      orderDate: entity.orderDate,
      expectedDeliveryDate: entity.expectedDeliveryDate,
      actualDeliveryDate: entity.actualDeliveryDate,
      status: entity.status,
      isRushOrder: entity.isRushOrder,
      totalItems: entity.totalItems,
      subtotal: entity.subtotal,
      discount: entity.discount,
      taxAmount: entity.taxAmount,
      totalAmount: entity.totalAmount,
      advancePaid: entity.advancePaid,
      balanceAmount: entity.balanceAmount,
      paymentStatus: entity.paymentStatus,
      specialInstructions: entity.specialInstructions,
      createdBy: entity.createdBy,
      updatedAt: entity.updatedAt,
      customerName: entity.customerName,
      customerPhone: entity.customerPhone,
    );
  }
}
