import 'package:equatable/equatable.dart';

class Payment extends Equatable {
  final int? id;
  final int orderId;
  final DateTime paymentDate;
  final double amount;
  final String paymentMethod; // Cash, Card, UPI, Wallet, Bank Transfer
  final String? transactionReference;
  final String? notes;
  final int? receivedBy;

  // Optional populated fields
  final String? orderNumber;
  final String? customerName;
  final String? receivedByName;

  const Payment({
    this.id,
    required this.orderId,
    required this.paymentDate,
    required this.amount,
    required this.paymentMethod,
    this.transactionReference,
    this.notes,
    this.receivedBy,
    this.orderNumber,
    this.customerName,
    this.receivedByName,
  });

  Payment copyWith({
    int? id,
    int? orderId,
    DateTime? paymentDate,
    double? amount,
    String? paymentMethod,
    String? transactionReference,
    String? notes,
    int? receivedBy,
    String? orderNumber,
    String? customerName,
    String? receivedByName,
  }) {
    return Payment(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      paymentDate: paymentDate ?? this.paymentDate,
      amount: amount ?? this.amount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      transactionReference: transactionReference ?? this.transactionReference,
      notes: notes ?? this.notes,
      receivedBy: receivedBy ?? this.receivedBy,
      orderNumber: orderNumber ?? this.orderNumber,
      customerName: customerName ?? this.customerName,
      receivedByName: receivedByName ?? this.receivedByName,
    );
  }

  @override
  List<Object?> get props => [
        id,
        orderId,
        paymentDate,
        amount,
        paymentMethod,
        transactionReference,
        notes,
        receivedBy,
        orderNumber,
        customerName,
        receivedByName,
      ];
}
