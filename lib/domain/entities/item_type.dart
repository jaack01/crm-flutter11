import 'package:equatable/equatable.dart';

class ItemType extends Equatable {
  final int? id;
  final String itemName;
  final String itemCode;
  final String? category;
  final bool isActive;
  final DateTime createdAt;

  const ItemType({
    this.id,
    required this.itemName,
    required this.itemCode,
    this.category,
    this.isActive = true,
    required this.createdAt,
  });

  ItemType copyWith({
    int? id,
    String? itemName,
    String? itemCode,
    String? category,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return ItemType(
      id: id ?? this.id,
      itemName: itemName ?? this.itemName,
      itemCode: itemCode ?? this.itemCode,
      category: category ?? this.category,
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
        isActive,
        createdAt,
      ];
}
