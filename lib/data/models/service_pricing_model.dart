import '../../domain/entities/service_pricing.dart';

class ServicePricingModel extends ServicePricing {
  const ServicePricingModel({
    int? id,
    required int serviceId,
    required int itemTypeId,
    required double price,
    double? rushOrderPrice,
    required bool isActive,
    required DateTime createdAt,
    String? serviceName,
    String? itemTypeName,
  }) : super(
          id: id,
          serviceId: serviceId,
          itemTypeId: itemTypeId,
          price: price,
          rushOrderPrice: rushOrderPrice,
          isActive: isActive,
          createdAt: createdAt,
          serviceName: serviceName,
          itemTypeName: itemTypeName,
        );

  factory ServicePricingModel.fromJson(Map<String, dynamic> json) {
    return ServicePricingModel(
      id: json['id'] as int?,
      serviceId: json['service_id'] as int,
      itemTypeId: json['item_type_id'] as int,
      price: (json['price'] as num).toDouble(),
      rushOrderPrice: (json['rush_order_price'] as num?)?.toDouble(),
      isActive: (json['is_active'] as int?) == 1,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      serviceName: json['service_name'] as String?,
      itemTypeName: json['item_type_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'service_id': serviceId,
      'item_type_id': itemTypeId,
      'price': price,
      'rush_order_price': rushOrderPrice,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  ServicePricing toEntity() {
    return ServicePricing(
      id: id,
      serviceId: serviceId,
      itemTypeId: itemTypeId,
      price: price,
      rushOrderPrice: rushOrderPrice,
      isActive: isActive,
      createdAt: createdAt,
      serviceName: serviceName,
      itemTypeName: itemTypeName,
    );
  }

  factory ServicePricingModel.fromEntity(ServicePricing entity) {
    return ServicePricingModel(
      id: entity.id,
      serviceId: entity.serviceId,
      itemTypeId: entity.itemTypeId,
      price: entity.price,
      rushOrderPrice: entity.rushOrderPrice,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      serviceName: entity.serviceName,
      itemTypeName: entity.itemTypeName,
    );
  }

  ServicePricingModel copyWith({
    int? id,
    int? serviceId,
    int? itemTypeId,
    double? price,
    double? rushOrderPrice,
    bool? isActive,
    DateTime? createdAt,
    String? serviceName,
    String? itemTypeName,
  }) {
    return ServicePricingModel(
      id: id ?? this.id,
      serviceId: serviceId ?? this.serviceId,
      itemTypeId: itemTypeId ?? this.itemTypeId,
      price: price ?? this.price,
      rushOrderPrice: rushOrderPrice ?? this.rushOrderPrice,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      serviceName: serviceName ?? this.serviceName,
      itemTypeName: itemTypeName ?? this.itemTypeName,
    );
  }
}
