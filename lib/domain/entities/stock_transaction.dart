import 'package:equatable/equatable.dart';

class StockTransaction extends Equatable {
  final int? id;
  final int inventoryItemId;
  final String transactionType; // Purchase, Usage, Adjustment
  final double quantity;
  final DateTime transactionDate;
  final int? referenceId; // order_id or purchase_id
  final String? notes;

  // Optional populated fields
  final String? itemName;
  final String? itemCode;

  const StockTransaction({
    this.id,
    required this.inventoryItemId,
    required this.transactionType,
    required this.quantity,
    required this.transactionDate,
    this.referenceId,
    this.notes,
    this.itemName,
    this.itemCode,
  });

  StockTransaction copyWith({
    int? id,
    int? inventoryItemId,
    String? transactionType,
    double? quantity,
    DateTime? transactionDate,
    int? referenceId,
    String? notes,
    String? itemName,
    String? itemCode,
  }) {
    return StockTransaction(
      id: id ?? this.id,
      inventoryItemId: inventoryItemId ?? this.inventoryItemId,
      transactionType: transactionType ?? this.transactionType,
      quantity: quantity ?? this.quantity,
      transactionDate: transactionDate ?? this.transactionDate,
      referenceId: referenceId ?? this.referenceId,
      notes: notes ?? this.notes,
      itemName: itemName ?? this.itemName,
      itemCode: itemCode ?? this.itemCode,
    );
  }

  @override
  List<Object?> get props => [
        id,
        inventoryItemId,
        transactionType,
        quantity,
        transactionDate,
        referenceId,
        notes,
        itemName,
        itemCode,
      ];
}
