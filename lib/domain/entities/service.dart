import 'package:equatable/equatable.dart';

class Service extends Equatable {
  final int? id;
  final String serviceName;
  final String serviceCode;
  final String? description;
  final double basePrice;
  final bool isActive;
  final DateTime createdAt;

  const Service({
    this.id,
    required this.serviceName,
    required this.serviceCode,
    this.description,
    this.basePrice = 0.0,
    this.isActive = true,
    required this.createdAt,
  });

  Service copyWith({
    int? id,
    String? serviceName,
    String? serviceCode,
    String? description,
    double? basePrice,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return Service(
      id: id ?? this.id,
      serviceName: serviceName ?? this.serviceName,
      serviceCode: serviceCode ?? this.serviceCode,
      description: description ?? this.description,
      basePrice: basePrice ?? this.basePrice,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        serviceName,
        serviceCode,
        description,
        basePrice,
        isActive,
        createdAt,
      ];
}
