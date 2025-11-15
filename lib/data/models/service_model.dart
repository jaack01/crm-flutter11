import '../../domain/entities/service.dart';

class ServiceModel extends Service {
  const ServiceModel({
    super.id,
    required super.serviceName,
    required super.serviceCode,
    super.description,
    super.basePrice,
    super.isActive,
    required super.createdAt,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] as int?,
      serviceName: json['service_name'] as String,
      serviceCode: json['service_code'] as String,
      description: json['description'] as String?,
      basePrice: (json['base_price'] as num?)?.toDouble() ?? 0.0,
      isActive: (json['is_active'] as int?) == 1,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'service_name': serviceName,
      'service_code': serviceCode,
      'description': description,
      'base_price': basePrice,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Service toEntity() {
    return Service(
      id: id,
      serviceName: serviceName,
      serviceCode: serviceCode,
      description: description,
      basePrice: basePrice,
      isActive: isActive,
      createdAt: createdAt,
    );
  }

  factory ServiceModel.fromEntity(Service entity) {
    return ServiceModel(
      id: entity.id,
      serviceName: entity.serviceName,
      serviceCode: entity.serviceCode,
      description: entity.description,
      basePrice: entity.basePrice,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
    );
  }
}
