import 'package:equatable/equatable.dart';

class Expense extends Equatable {
  final int? id;
  final DateTime expenseDate;
  final String category; // Rent, Electricity, Water, Salary, Supplies, Maintenance, Other
  final double amount;
  final String? paymentMethod;
  final String? description;
  final String? receiptPath;
  final DateTime createdAt;

  const Expense({
    this.id,
    required this.expenseDate,
    required this.category,
    required this.amount,
    this.paymentMethod,
    this.description,
    this.receiptPath,
    required this.createdAt,
  });

  Expense copyWith({
    int? id,
    DateTime? expenseDate,
    String? category,
    double? amount,
    String? paymentMethod,
    String? description,
    String? receiptPath,
    DateTime? createdAt,
  }) {
    return Expense(
      id: id ?? this.id,
      expenseDate: expenseDate ?? this.expenseDate,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      description: description ?? this.description,
      receiptPath: receiptPath ?? this.receiptPath,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        expenseDate,
        category,
        amount,
        paymentMethod,
        description,
        receiptPath,
        createdAt,
      ];
}
