import 'package:sqflite/sqflite.dart';
import '../../../core/database/database_helper.dart';
import '../../models/customer_model.dart';

abstract class CustomerLocalDataSource {
  Future<List<CustomerModel>> getAllCustomers();
  Future<CustomerModel> getCustomerById(int id);
  Future<CustomerModel?> getCustomerByPhone(String phone);
  Future<List<CustomerModel>> searchCustomers(String query);
  Future<List<CustomerModel>> getCustomersByType(String type);
  Future<int> insertCustomer(CustomerModel customer);
  Future<int> updateCustomer(CustomerModel customer);
  Future<int> deleteCustomer(int id);
  Future<int> getCustomerCount();
  Future<String> generateNextCustomerCode();
}

class CustomerLocalDataSourceImpl implements CustomerLocalDataSource {
  final DatabaseHelper databaseHelper;

  CustomerLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<CustomerModel>> getAllCustomers() async {
    try {
      final Database db = await databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'customers',
        where: 'is_active = ?',
        whereArgs: [1],
        orderBy: 'created_at DESC',
      );
      return List.generate(maps.length, (i) => CustomerModel.fromJson(maps[i]));
    } catch (e) {
      throw Exception('Failed to get customers: $e');
    }
  }

  @override
  Future<CustomerModel> getCustomerById(int id) async {
    try {
      final Database db = await databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'customers',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (maps.isEmpty) {
        throw Exception('Customer not found');
      }
      return CustomerModel.fromJson(maps.first);
    } catch (e) {
      throw Exception('Failed to get customer: $e');
    }
  }

  @override
  Future<CustomerModel?> getCustomerByPhone(String phone) async {
    try {
      final Database db = await databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'customers',
        where: 'phone = ?',
        whereArgs: [phone],
        limit: 1,
      );
      if (maps.isEmpty) {
        return null;
      }
      return CustomerModel.fromJson(maps.first);
    } catch (e) {
      throw Exception('Failed to get customer by phone: $e');
    }
  }

  @override
  Future<List<CustomerModel>> searchCustomers(String query) async {
    try {
      final Database db = await databaseHelper.database;
      final String searchQuery = '%$query%';
      final List<Map<String, dynamic>> maps = await db.query(
        'customers',
        where: 'is_active = ? AND (first_name LIKE ? OR last_name LIKE ? OR phone LIKE ? OR customer_code LIKE ?)',
        whereArgs: [1, searchQuery, searchQuery, searchQuery, searchQuery],
        orderBy: 'first_name ASC',
      );
      return List.generate(maps.length, (i) => CustomerModel.fromJson(maps[i]));
    } catch (e) {
      throw Exception('Failed to search customers: $e');
    }
  }

  @override
  Future<List<CustomerModel>> getCustomersByType(String type) async {
    try {
      final Database db = await databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'customers',
        where: 'is_active = ? AND customer_type = ?',
        whereArgs: [1, type],
        orderBy: 'created_at DESC',
      );
      return List.generate(maps.length, (i) => CustomerModel.fromJson(maps[i]));
    } catch (e) {
      throw Exception('Failed to get customers by type: $e');
    }
  }

  @override
  Future<int> insertCustomer(CustomerModel customer) async {
    try {
      final Database db = await databaseHelper.database;
      return await db.insert('customers', customer.toJson());
    } catch (e) {
      throw Exception('Failed to insert customer: $e');
    }
  }

  @override
  Future<int> updateCustomer(CustomerModel customer) async {
    try {
      final Database db = await databaseHelper.database;
      return await db.update(
        'customers',
        customer.toJson(),
        where: 'id = ?',
        whereArgs: [customer.id],
      );
    } catch (e) {
      throw Exception('Failed to update customer: $e');
    }
  }

  @override
  Future<int> deleteCustomer(int id) async {
    try {
      final Database db = await databaseHelper.database;
      // Soft delete
      return await db.update(
        'customers',
        {'is_active': 0},
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Failed to delete customer: $e');
    }
  }

  @override
  Future<int> getCustomerCount() async {
    try {
      final Database db = await databaseHelper.database;
      final List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM customers WHERE is_active = 1',
      );
      return Sqflite.firstIntValue(result) ?? 0;
    } catch (e) {
      throw Exception('Failed to get customer count: $e');
    }
  }

  @override
  Future<String> generateNextCustomerCode() async {
    try {
      final Database db = await databaseHelper.database;

      // Get next customer number from settings
      final List<Map<String, dynamic>> settings = await db.query(
        'settings',
        where: 'setting_key = ?',
        whereArgs: ['next_customer_number'],
      );

      int nextNumber = 1;
      if (settings.isNotEmpty) {
        nextNumber = int.parse(settings.first['setting_value'] as String);
      }

      // Get prefix from settings
      final List<Map<String, dynamic>> prefixSettings = await db.query(
        'settings',
        where: 'setting_key = ?',
        whereArgs: ['customer_number_prefix'],
      );

      String prefix = 'CUST';
      if (prefixSettings.isNotEmpty) {
        prefix = prefixSettings.first['setting_value'] as String;
      }

      final String customerCode = '$prefix${nextNumber.toString().padLeft(5, '0')}';

      // Update next customer number
      await db.update(
        'settings',
        {'setting_value': (nextNumber + 1).toString()},
        where: 'setting_key = ?',
        whereArgs: ['next_customer_number'],
      );

      return customerCode;
    } catch (e) {
      throw Exception('Failed to generate customer code: $e');
    }
  }
}
