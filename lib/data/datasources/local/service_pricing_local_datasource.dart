import 'package:sqflite/sqflite.dart';
import '../../../core/database/database_helper.dart';
import '../../models/service_pricing_model.dart';

abstract class ServicePricingLocalDataSource {
  Future<List<ServicePricingModel>> getAllServicePricing();
  Future<ServicePricingModel> getServicePricing(int serviceId, int itemTypeId);
  Future<List<ServicePricingModel>> getPricingByService(int serviceId);
  Future<List<ServicePricingModel>> getPricingByItemType(int itemTypeId);
  Future<ServicePricingModel> addServicePricing(ServicePricingModel pricing);
  Future<void> updateServicePricing(ServicePricingModel pricing);
  Future<void> deleteServicePricing(int id);
}

class ServicePricingLocalDataSourceImpl implements ServicePricingLocalDataSource {
  final DatabaseHelper databaseHelper;

  ServicePricingLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<ServicePricingModel>> getAllServicePricing() async {
    final Database db = await databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT
        sp.*,
        s.service_name,
        it.item_name as item_type_name
      FROM service_pricing sp
      LEFT JOIN services s ON sp.service_id = s.id
      LEFT JOIN item_types it ON sp.item_type_id = it.id
      WHERE sp.is_active = 1
      ORDER BY s.service_name ASC, it.item_name ASC
    ''');

    return List.generate(maps.length, (i) => ServicePricingModel.fromJson(maps[i]));
  }

  @override
  Future<ServicePricingModel> getServicePricing(int serviceId, int itemTypeId) async {
    final Database db = await databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT
        sp.*,
        s.service_name,
        it.item_name as item_type_name
      FROM service_pricing sp
      LEFT JOIN services s ON sp.service_id = s.id
      LEFT JOIN item_types it ON sp.item_type_id = it.id
      WHERE sp.service_id = ? AND sp.item_type_id = ?
      LIMIT 1
    ''', [serviceId, itemTypeId]);

    if (maps.isEmpty) {
      throw Exception('Service pricing not found for service: $serviceId, item type: $itemTypeId');
    }

    return ServicePricingModel.fromJson(maps.first);
  }

  @override
  Future<List<ServicePricingModel>> getPricingByService(int serviceId) async {
    final Database db = await databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT
        sp.*,
        s.service_name,
        it.item_name as item_type_name
      FROM service_pricing sp
      LEFT JOIN services s ON sp.service_id = s.id
      LEFT JOIN item_types it ON sp.item_type_id = it.id
      WHERE sp.service_id = ? AND sp.is_active = 1
      ORDER BY it.item_name ASC
    ''', [serviceId]);

    return List.generate(maps.length, (i) => ServicePricingModel.fromJson(maps[i]));
  }

  @override
  Future<List<ServicePricingModel>> getPricingByItemType(int itemTypeId) async {
    final Database db = await databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT
        sp.*,
        s.service_name,
        it.item_name as item_type_name
      FROM service_pricing sp
      LEFT JOIN services s ON sp.service_id = s.id
      LEFT JOIN item_types it ON sp.item_type_id = it.id
      WHERE sp.item_type_id = ? AND sp.is_active = 1
      ORDER BY s.service_name ASC
    ''', [itemTypeId]);

    return List.generate(maps.length, (i) => ServicePricingModel.fromJson(maps[i]));
  }

  @override
  Future<ServicePricingModel> addServicePricing(ServicePricingModel pricing) async {
    final Database db = await databaseHelper.database;

    // Check if pricing already exists for this combination
    final existing = await db.query(
      'service_pricing',
      where: 'service_id = ? AND item_type_id = ?',
      whereArgs: [pricing.serviceId, pricing.itemTypeId],
    );

    if (existing.isNotEmpty) {
      throw Exception('Pricing already exists for this service and item type combination');
    }

    final int id = await db.insert('service_pricing', pricing.toJson());
    return pricing.copyWith(id: id);
  }

  @override
  Future<void> updateServicePricing(ServicePricingModel pricing) async {
    final Database db = await databaseHelper.database;

    await db.update(
      'service_pricing',
      pricing.toJson(),
      where: 'id = ?',
      whereArgs: [pricing.id],
    );
  }

  @override
  Future<void> deleteServicePricing(int id) async {
    final Database db = await databaseHelper.database;

    // Soft delete by setting is_active to 0
    await db.update(
      'service_pricing',
      {'is_active': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
