import 'package:sqflite/sqflite.dart';
import '../../../core/database/database_helper.dart';
import '../../models/service_model.dart';

abstract class ServiceLocalDataSource {
  Future<List<ServiceModel>> getAllServices();
  Future<ServiceModel> getServiceById(int id);
  Future<int> addService(ServiceModel service);
  Future<int> updateService(ServiceModel service);
}

class ServiceLocalDataSourceImpl implements ServiceLocalDataSource {
  final DatabaseHelper databaseHelper;

  ServiceLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<ServiceModel>> getAllServices() async {
    final Database db = await databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'services',
      where: 'is_active = ?',
      whereArgs: [1],
      orderBy: 'service_name ASC',
    );

    return List.generate(maps.length, (i) => ServiceModel.fromJson(maps[i]));
  }

  @override
  Future<ServiceModel> getServiceById(int id) async {
    final Database db = await databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'services',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) {
      throw Exception('Service not found');
    }

    return ServiceModel.fromJson(maps.first);
  }

  @override
  Future<int> addService(ServiceModel service) async {
    final Database db = await databaseHelper.database;
    return await db.insert('services', service.toJson());
  }

  @override
  Future<int> updateService(ServiceModel service) async {
    final Database db = await databaseHelper.database;

    return await db.update(
      'services',
      service.toJson(),
      where: 'id = ?',
      whereArgs: [service.id],
    );
  }
}
