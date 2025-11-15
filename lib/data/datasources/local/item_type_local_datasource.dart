import 'package:sqflite/sqflite.dart';
import '../../../core/database/database_helper.dart';
import '../../models/item_type_model.dart';

abstract class ItemTypeLocalDataSource {
  Future<List<ItemTypeModel>> getAllItemTypes();
  Future<ItemTypeModel> getItemTypeById(int id);
  Future<List<ItemTypeModel>> getItemTypesByCategory(String category);
  Future<ItemTypeModel> addItemType(ItemTypeModel itemType);
  Future<void> updateItemType(ItemTypeModel itemType);
}

class ItemTypeLocalDataSourceImpl implements ItemTypeLocalDataSource {
  final DatabaseHelper databaseHelper;

  ItemTypeLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<ItemTypeModel>> getAllItemTypes() async {
    final Database db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'item_types',
      where: 'is_active = ?',
      whereArgs: [1],
      orderBy: 'category ASC, item_name ASC',
    );

    return List.generate(maps.length, (i) => ItemTypeModel.fromJson(maps[i]));
  }

  @override
  Future<ItemTypeModel> getItemTypeById(int id) async {
    final Database db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'item_types',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) {
      throw Exception('Item type not found with id: $id');
    }

    return ItemTypeModel.fromJson(maps.first);
  }

  @override
  Future<List<ItemTypeModel>> getItemTypesByCategory(String category) async {
    final Database db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'item_types',
      where: 'category = ? AND is_active = ?',
      whereArgs: [category, 1],
      orderBy: 'item_name ASC',
    );

    return List.generate(maps.length, (i) => ItemTypeModel.fromJson(maps[i]));
  }

  @override
  Future<ItemTypeModel> addItemType(ItemTypeModel itemType) async {
    final Database db = await databaseHelper.database;
    final int id = await db.insert('item_types', itemType.toJson());

    return itemType.copyWith(id: id);
  }

  @override
  Future<void> updateItemType(ItemTypeModel itemType) async {
    final Database db = await databaseHelper.database;
    await db.update(
      'item_types',
      itemType.toJson(),
      where: 'id = ?',
      whereArgs: [itemType.id],
    );
  }
}

extension on ItemTypeModel {
  ItemTypeModel copyWith({
    int? id,
    String? itemName,
    String? category,
    String? description,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return ItemTypeModel(
      id: id ?? this.id,
      itemName: itemName ?? this.itemName,
      category: category ?? this.category,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
