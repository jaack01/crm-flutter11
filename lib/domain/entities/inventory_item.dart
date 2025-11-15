import 'package:equatable/equatable.dart';

class InventoryItem extends Equatable {
  final int? id;
  final String itemName;
  final String itemCode;
  final String? category;
  final String unit; // kg, liter, piece, bottle, packet
  final double currentStock;
  final double minStockLevel;
  final double? unitPrice;
  final bool isActive;
  final DateTime createdAt;

  const InventoryItem({
    this.id,
    required this.itemName,
    required this.itemCode,
    this.category,
    required this.unit,
    this.currentStock = 0.0,
    this.minStockLevel = 0.0,
    this.unitPrice,
    this.isActive = true,
    required this.createdAt,
  });

  /// Check if stock is low
  bool get isLowStock => currentStock <= minStockLevel;

  /// Check if out of stock
  bool get isOutOfStock => currentStock <= 0;

  /// Get stock status
  String get stockStatus {
    if (isOutOfStock) return 'Out of Stock';
    if (isLowStock) return 'Low Stock';
    return 'In Stock';
  }

  InventoryItem copyWith({
    int? id,
    String? itemName,
    String? itemCode,
    String? category,
    String? unit,
    double? currentStock,
    double? minStockLevel,
    double? unitPrice,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      itemName: itemName ?? this.itemName,
      itemCode: itemCode ?? this.itemCode,
      category: category ?? this.category,
      unit: unit ?? this.unit,
      currentStock: currentStock ?? this.currentStock,
      minStockLevel: minStockLevel ?? this.minStockLevel,
      unitPrice: unitPrice ?? this.unitPrice,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        itemName,
        itemCode,
        category,
        unit,
        currentStock,
        minStockLevel,
        unitPrice,
        isActive,
        createdAt,
      ];
}
