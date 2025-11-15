import 'package:sqflite/sqflite.dart';
import '../../../core/database/database_helper.dart';
import '../../models/order_model.dart';
import '../../models/order_item_model.dart';

abstract class OrderLocalDataSource {
  Future<List<OrderModel>> getAllOrders();
  Future<OrderModel> getOrderById(int id);
  Future<List<OrderModel>> getOrdersByCustomer(int customerId);
  Future<List<OrderModel>> getOrdersByStatus(String status);
  Future<List<OrderModel>> searchOrders(String query);
  Future<OrderModel> addOrder(OrderModel order, List<OrderItemModel> items);
  Future<int> updateOrder(OrderModel order);
  Future<void> updateOrderStatus(int orderId, String status);
  Future<String> generateNextOrderNumber();
  Future<List<OrderItemModel>> getOrderItems(int orderId);
}

class OrderLocalDataSourceImpl implements OrderLocalDataSource {
  final DatabaseHelper databaseHelper;

  OrderLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<OrderModel>> getAllOrders() async {
    final Database db = await databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT o.*,
             c.first_name || ' ' || COALESCE(c.last_name, '') as customer_name,
             c.phone as customer_phone
      FROM orders o
      LEFT JOIN customers c ON o.customer_id = c.id
      ORDER BY o.order_date DESC
    ''');

    return List.generate(maps.length, (i) => OrderModel.fromJson(maps[i]));
  }

  @override
  Future<OrderModel> getOrderById(int id) async {
    final Database db = await databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT o.*,
             c.first_name || ' ' || COALESCE(c.last_name, '') as customer_name,
             c.phone as customer_phone
      FROM orders o
      LEFT JOIN customers c ON o.customer_id = c.id
      WHERE o.id = ?
    ''', [id]);

    if (maps.isEmpty) {
      throw Exception('Order not found');
    }

    return OrderModel.fromJson(maps.first);
  }

  @override
  Future<List<OrderModel>> getOrdersByCustomer(int customerId) async {
    final Database db = await databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT o.*,
             c.first_name || ' ' || COALESCE(c.last_name, '') as customer_name,
             c.phone as customer_phone
      FROM orders o
      LEFT JOIN customers c ON o.customer_id = c.id
      WHERE o.customer_id = ?
      ORDER BY o.order_date DESC
    ''', [customerId]);

    return List.generate(maps.length, (i) => OrderModel.fromJson(maps[i]));
  }

  @override
  Future<List<OrderModel>> getOrdersByStatus(String status) async {
    final Database db = await databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT o.*,
             c.first_name || ' ' || COALESCE(c.last_name, '') as customer_name,
             c.phone as customer_phone
      FROM orders o
      LEFT JOIN customers c ON o.customer_id = c.id
      WHERE o.status = ?
      ORDER BY o.order_date DESC
    ''', [status]);

    return List.generate(maps.length, (i) => OrderModel.fromJson(maps[i]));
  }

  @override
  Future<List<OrderModel>> searchOrders(String query) async {
    final Database db = await databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT o.*,
             c.first_name || ' ' || COALESCE(c.last_name, '') as customer_name,
             c.phone as customer_phone
      FROM orders o
      LEFT JOIN customers c ON o.customer_id = c.id
      WHERE o.order_number LIKE ?
         OR c.first_name LIKE ?
         OR c.last_name LIKE ?
         OR c.phone LIKE ?
      ORDER BY o.order_date DESC
    ''', ['%$query%', '%$query%', '%$query%', '%$query%']);

    return List.generate(maps.length, (i) => OrderModel.fromJson(maps[i]));
  }

  @override
  Future<OrderModel> addOrder(OrderModel order, List<OrderItemModel> items) async {
    final Database db = await databaseHelper.database;

    // Use transaction for atomic operation
    return await db.transaction((txn) async {
      // Insert order
      final int orderId = await txn.insert('orders', order.toJson());

      // Insert order items
      for (final OrderItemModel item in items) {
        await txn.insert(
          'order_items',
          item.copyWith(orderId: orderId).toJson(),
        );
      }

      // Get the created order with populated fields
      final List<Map<String, dynamic>> maps = await txn.rawQuery('''
        SELECT o.*,
               c.first_name || ' ' || COALESCE(c.last_name, '') as customer_name,
               c.phone as customer_phone
        FROM orders o
        LEFT JOIN customers c ON o.customer_id = c.id
        WHERE o.id = ?
      ''', [orderId]);

      return OrderModel.fromJson(maps.first);
    });
  }

  @override
  Future<int> updateOrder(OrderModel order) async {
    final Database db = await databaseHelper.database;

    return await db.update(
      'orders',
      order.toJson(),
      where: 'id = ?',
      whereArgs: [order.id],
    );
  }

  @override
  Future<void> updateOrderStatus(int orderId, String status) async {
    final Database db = await databaseHelper.database;

    await db.update(
      'orders',
      {
        'status': status,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [orderId],
    );
  }

  @override
  Future<String> generateNextOrderNumber() async {
    final Database db = await databaseHelper.database;

    final List<Map<String, dynamic>> result = await db.query(
      'settings',
      columns: ['setting_value'],
      where: 'setting_key = ?',
      whereArgs: ['next_order_number'],
    );

    int nextNumber = 1;
    if (result.isNotEmpty) {
      nextNumber = int.parse(result.first['setting_value'] as String);
    }

    final List<Map<String, dynamic>> prefixResult = await db.query(
      'settings',
      columns: ['setting_value'],
      where: 'setting_key = ?',
      whereArgs: ['order_number_prefix'],
    );

    final String prefix =
        prefixResult.isNotEmpty ? prefixResult.first['setting_value'] as String : 'ORD';

    final String orderNumber = '$prefix${nextNumber.toString().padLeft(6, '0')}';

    // Update next number
    await db.update(
      'settings',
      {'setting_value': (nextNumber + 1).toString()},
      where: 'setting_key = ?',
      whereArgs: ['next_order_number'],
    );

    return orderNumber;
  }

  @override
  Future<List<OrderItemModel>> getOrderItems(int orderId) async {
    final Database db = await databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT oi.*,
             s.service_name,
             it.item_name
      FROM order_items oi
      LEFT JOIN services s ON oi.service_id = s.id
      LEFT JOIN item_types it ON oi.item_type_id = it.id
      WHERE oi.order_id = ?
    ''', [orderId]);

    return List.generate(maps.length, (i) => OrderItemModel.fromJson(maps[i]));
  }
}
