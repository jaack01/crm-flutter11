import '../../domain/entities/order_item.dart';

class OrderItemModel extends OrderItem {
  const OrderItemModel({
    super.id,
    required super.orderId,
    required super.serviceId,
    required super.itemTypeId,
    super.quantity,
    required super.unitPrice,
    required super.totalPrice,
    super.notes,
    super.serviceName,
    super.itemTypeName,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as int?,
      orderId: json['order_id'] as int,
      serviceId: json['service_id'] as int,
      itemTypeId: json['item_type_id'] as int,
      quantity: json['quantity'] as int? ?? 1,
      unitPrice: (json['unit_price'] as num).toDouble(),
      totalPrice: (json['total_price'] as num).toDouble(),
      notes: json['notes'] as String?,
      serviceName: json['service_name'] as String?,
      itemTypeName: json['item_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'order_id': orderId,
      'service_id': serviceId,
      'item_type_id': itemTypeId,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total_price': totalPrice,
      'notes': notes,
    };
  }

  OrderItem toEntity() {
    return OrderItem(
      id: id,
      orderId: orderId,
      serviceId: serviceId,
      itemTypeId: itemTypeId,
      quantity: quantity,
      unitPrice: unitPrice,
      totalPrice: totalPrice,
      notes: notes,
      serviceName: serviceName,
      itemTypeName: itemTypeName,
    );
  }

  factory OrderItemModel.fromEntity(OrderItem entity) {
    return OrderItemModel(
      id: entity.id,
      orderId: entity.orderId,
      serviceId: entity.serviceId,
      itemTypeId: entity.itemTypeId,
      quantity: entity.quantity,
      unitPrice: entity.unitPrice,
      totalPrice: entity.totalPrice,
      notes: entity.notes,
      serviceName: entity.serviceName,
      itemTypeName: entity.itemTypeName,
    );
  }
}
