import '../../domain/entities/customer.dart';
import '../../core/utils/date_utils.dart' as app_date_utils;

class CustomerModel extends Customer {
  const CustomerModel({
    super.id,
    required super.customerCode,
    required super.firstName,
    super.lastName,
    required super.phone,
    super.email,
    super.alternatePhone,
    super.address,
    super.city,
    super.pincode,
    super.customerType,
    super.loyaltyPoints,
    super.photoPath,
    super.notes,
    required super.createdAt,
    required super.updatedAt,
    super.isActive,
  });

  factory CustomerModel.fromEntity(Customer customer) {
    return CustomerModel(
      id: customer.id,
      customerCode: customer.customerCode,
      firstName: customer.firstName,
      lastName: customer.lastName,
      phone: customer.phone,
      email: customer.email,
      alternatePhone: customer.alternatePhone,
      address: customer.address,
      city: customer.city,
      pincode: customer.pincode,
      customerType: customer.customerType,
      loyaltyPoints: customer.loyaltyPoints,
      photoPath: customer.photoPath,
      notes: customer.notes,
      createdAt: customer.createdAt,
      updatedAt: customer.updatedAt,
      isActive: customer.isActive,
    );
  }

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] as int?,
      customerCode: json['customer_code'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String?,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      alternatePhone: json['alternate_phone'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      pincode: json['pincode'] as String?,
      customerType: json['customer_type'] as String? ?? 'Regular',
      loyaltyPoints: json['loyalty_points'] as int? ?? 0,
      photoPath: json['photo_path'] as String?,
      notes: json['notes'] as String?,
      createdAt: app_date_utils.AppDateUtils.parseDatabaseDate(json['created_at'] as String?) ?? DateTime.now(),
      updatedAt: app_date_utils.AppDateUtils.parseDatabaseDate(json['updated_at'] as String?) ?? DateTime.now(),
      isActive: (json['is_active'] as int?) == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'customer_code': customerCode,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'email': email,
      'alternate_phone': alternatePhone,
      'address': address,
      'city': city,
      'pincode': pincode,
      'customer_type': customerType,
      'loyalty_points': loyaltyPoints,
      'photo_path': photoPath,
      'notes': notes,
      'created_at': app_date_utils.AppDateUtils.formatDateForDatabase(createdAt),
      'updated_at': app_date_utils.AppDateUtils.formatDateForDatabase(updatedAt),
      'is_active': isActive ? 1 : 0,
    };
  }

  Customer toEntity() {
    return Customer(
      id: id,
      customerCode: customerCode,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      email: email,
      alternatePhone: alternatePhone,
      address: address,
      city: city,
      pincode: pincode,
      customerType: customerType,
      loyaltyPoints: loyaltyPoints,
      photoPath: photoPath,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isActive: isActive,
    );
  }
}
