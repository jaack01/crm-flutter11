import '../../domain/entities/item_type.dart';

class ItemTypeModel extends ItemType {
  const ItemTypeModel({
    int? id,
    required String itemName,
    required String category,
    String? description,
    required bool isActive,
    required DateTime createdAt,
  }) : super(
          id: id,
          itemName: itemName,
          category: category,
          description: description,
          isActive: isActive,
          createdAt: createdAt,
        );

  factory ItemTypeModel.fromJson(Map<String, dynamic> json) {
    return ItemTypeModel(
      id: json['id'] as int?,
      itemName: json['item_name'] as String,
      category: json['category'] as String,
      description: json['description'] as String?,
      isActive: (json['is_active'] as int?) == 1,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'item_name': itemName,
      'category': category,
      'description': description,
      'is_active': isActive ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
    };
  }

  ItemType toEntity() {
    return ItemType(
      id: id,
      itemName: itemName,
      category: category,
      description: description,
      isActive: isActive,
      createdAt: createdAt,
    );
  }

  factory ItemTypeModel.fromEntity(ItemType entity) {
    return ItemTypeModel(
      id: entity.id,
      itemName: entity.itemName,
      category: entity.category,
      description: entity.description,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
    );
  }
}
