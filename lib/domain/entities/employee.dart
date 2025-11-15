import 'package:equatable/equatable.dart';

class Employee extends Equatable {
  final int? id;
  final String employeeCode;
  final String firstName;
  final String? lastName;
  final String phone;
  final String? email;
  final String role; // Manager, Cashier, Operator, Delivery
  final double? salary;
  final double? commissionRate;
  final DateTime? joiningDate;
  final bool isActive;
  final DateTime createdAt;

  const Employee({
    this.id,
    required this.employeeCode,
    required this.firstName,
    this.lastName,
    required this.phone,
    this.email,
    required this.role,
    this.salary,
    this.commissionRate,
    this.joiningDate,
    this.isActive = true,
    required this.createdAt,
  });

  /// Get full name
  String get fullName {
    if (lastName != null && lastName!.isNotEmpty) {
      return '$firstName $lastName';
    }
    return firstName;
  }

  Employee copyWith({
    int? id,
    String? employeeCode,
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    String? role,
    double? salary,
    double? commissionRate,
    DateTime? joiningDate,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return Employee(
      id: id ?? this.id,
      employeeCode: employeeCode ?? this.employeeCode,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      role: role ?? this.role,
      salary: salary ?? this.salary,
      commissionRate: commissionRate ?? this.commissionRate,
      joiningDate: joiningDate ?? this.joiningDate,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        employeeCode,
        firstName,
        lastName,
        phone,
        email,
        role,
        salary,
        commissionRate,
        joiningDate,
        isActive,
        createdAt,
      ];
}
