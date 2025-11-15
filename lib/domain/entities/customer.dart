import 'package:equatable/equatable.dart';

class Customer extends Equatable {
  final int? id;
  final String customerCode;
  final String firstName;
  final String? lastName;
  final String phone;
  final String? email;
  final String? alternatePhone;
  final String? address;
  final String? city;
  final String? pincode;
  final String customerType; // New, Regular, VIP
  final int loyaltyPoints;
  final String? photoPath;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  const Customer({
    this.id,
    required this.customerCode,
    required this.firstName,
    this.lastName,
    required this.phone,
    this.email,
    this.alternatePhone,
    this.address,
    this.city,
    this.pincode,
    this.customerType = 'Regular',
    this.loyaltyPoints = 0,
    this.photoPath,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
  });

  /// Get full name
  String get fullName {
    if (lastName != null && lastName!.isNotEmpty) {
      return '$firstName $lastName';
    }
    return firstName;
  }

  /// Get display address
  String get displayAddress {
    final List<String> parts = [];
    if (address != null && address!.isNotEmpty) parts.add(address!);
    if (city != null && city!.isNotEmpty) parts.add(city!);
    if (pincode != null && pincode!.isNotEmpty) parts.add(pincode!);
    return parts.join(', ');
  }

  /// Copy with method
  Customer copyWith({
    int? id,
    String? customerCode,
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    String? alternatePhone,
    String? address,
    String? city,
    String? pincode,
    String? customerType,
    int? loyaltyPoints,
    String? photoPath,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return Customer(
      id: id ?? this.id,
      customerCode: customerCode ?? this.customerCode,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      alternatePhone: alternatePhone ?? this.alternatePhone,
      address: address ?? this.address,
      city: city ?? this.city,
      pincode: pincode ?? this.pincode,
      customerType: customerType ?? this.customerType,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      photoPath: photoPath ?? this.photoPath,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
        id,
        customerCode,
        firstName,
        lastName,
        phone,
        email,
        alternatePhone,
        address,
        city,
        pincode,
        customerType,
        loyaltyPoints,
        photoPath,
        notes,
        createdAt,
        updatedAt,
        isActive,
      ];
}
