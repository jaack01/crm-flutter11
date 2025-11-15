import 'package:equatable/equatable.dart';

class OrderItem extends Equatable {
  final int? id;
  final int orderId;
  final int serviceId;
  final int itemTypeId;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final String? notes;

  // Optional populated fields
  final String? serviceName;
  final String? itemTypeName;

  const OrderItem({
    this.id,
    required this.orderId,
    required this.serviceId,
    required this.itemTypeId,
    this.quantity = 1,
    required this.unitPrice,
    required this.totalPrice,
    this.notes,
    this.serviceName,
    this.itemTypeName,
  });

  OrderItem copyWith({
    int? id,
    int? orderId,
    int? serviceId,
    int? itemTypeId,
    int? quantity,
    double? unitPrice,
    double? totalPrice,
    String? notes,
    String? serviceName,
    String? itemTypeName,
  }) {
    return OrderItem(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      serviceId: serviceId ?? this.serviceId,
      itemTypeId: itemTypeId ?? this.itemTypeId,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      totalPrice: totalPrice ?? this.totalPrice,
      notes: notes ?? this.notes,
      serviceName: serviceName ?? this.serviceName,
      itemTypeName: itemTypeName ?? this.itemTypeName,
    );
  }

  @override
  List<Object?> get props => [
        id,
        orderId,
        serviceId,
        itemTypeId,
        quantity,
        unitPrice,
        totalPrice,
        notes,
        serviceName,
        itemTypeName,
      ];
}
