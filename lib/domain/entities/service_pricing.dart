import 'package:equatable/equatable.dart';

class ServicePricing extends Equatable {
  final int? id;
  final int serviceId;
  final int itemTypeId;
  final double price;
  final double? rushPrice;

  // Optional populated fields
  final String? serviceName;
  final String? itemTypeName;

  const ServicePricing({
    this.id,
    required this.serviceId,
    required this.itemTypeId,
    required this.price,
    this.rushPrice,
    this.serviceName,
    this.itemTypeName,
  });

  ServicePricing copyWith({
    int? id,
    int? serviceId,
    int? itemTypeId,
    double? price,
    double? rushPrice,
    String? serviceName,
    String? itemTypeName,
  }) {
    return ServicePricing(
      id: id ?? this.id,
      serviceId: serviceId ?? this.serviceId,
      itemTypeId: itemTypeId ?? this.itemTypeId,
      price: price ?? this.price,
      rushPrice: rushPrice ?? this.rushPrice,
      serviceName: serviceName ?? this.serviceName,
      itemTypeName: itemTypeName ?? this.itemTypeName,
    );
  }

  @override
  List<Object?> get props => [
        id,
        serviceId,
        itemTypeId,
        price,
        rushPrice,
        serviceName,
        itemTypeName,
      ];
}
