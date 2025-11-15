import '../../domain/entities/payment.dart';

class PaymentModel extends Payment {
  const PaymentModel({
    super.id,
    required super.orderId,
    required super.paymentDate,
    required super.amount,
    required super.paymentMethod,
    super.transactionReference,
    super.notes,
    super.receivedBy,
    super.orderNumber,
    super.customerName,
    super.receivedByName,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as int?,
      orderId: json['order_id'] as int,
      paymentDate: DateTime.parse(json['payment_date'] as String),
      amount: (json['amount'] as num).toDouble(),
      paymentMethod: json['payment_method'] as String,
      transactionReference: json['transaction_reference'] as String?,
      notes: json['notes'] as String?,
      receivedBy: json['received_by'] as int?,
      orderNumber: json['order_number'] as String?,
      customerName: json['customer_name'] as String?,
      receivedByName: json['received_by_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'order_id': orderId,
      'payment_date': paymentDate.toIso8601String(),
      'amount': amount,
      'payment_method': paymentMethod,
      'transaction_reference': transactionReference,
      'notes': notes,
      'received_by': receivedBy,
    };
  }

  Payment toEntity() {
    return Payment(
      id: id,
      orderId: orderId,
      paymentDate: paymentDate,
      amount: amount,
      paymentMethod: paymentMethod,
      transactionReference: transactionReference,
      notes: notes,
      receivedBy: receivedBy,
      orderNumber: orderNumber,
      customerName: customerName,
      receivedByName: receivedByName,
    );
  }

  factory PaymentModel.fromEntity(Payment entity) {
    return PaymentModel(
      id: entity.id,
      orderId: entity.orderId,
      paymentDate: entity.paymentDate,
      amount: entity.amount,
      paymentMethod: entity.paymentMethod,
      transactionReference: entity.transactionReference,
      notes: entity.notes,
      receivedBy: entity.receivedBy,
      orderNumber: entity.orderNumber,
      customerName: entity.customerName,
      receivedByName: entity.receivedByName,
    );
  }
}
