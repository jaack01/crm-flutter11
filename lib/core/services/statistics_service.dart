import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';

class StatisticsService {
  final DatabaseHelper databaseHelper;

  StatisticsService({required this.databaseHelper});

  Future<Map<String, dynamic>> getDashboardStatistics() async {
    final Database db = await databaseHelper.database;

    // Get total customers
    final customerCount = await db.rawQuery('SELECT COUNT(*) as count FROM customers WHERE is_active = 1');
    final totalCustomers = (customerCount.first['count'] as int?) ?? 0;

    // Get total orders
    final orderCount = await db.rawQuery('SELECT COUNT(*) as count FROM orders');
    final totalOrders = (orderCount.first['count'] as int?) ?? 0;

    // Get pending orders (not delivered/cancelled)
    final pendingCount = await db.rawQuery(
      "SELECT COUNT(*) as count FROM orders WHERE status NOT IN ('Delivered', 'Cancelled')"
    );
    final pendingOrders = (pendingCount.first['count'] as int?) ?? 0;

    // Get today's orders
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day).toIso8601String();
    final todayEnd = DateTime(today.year, today.month, today.day, 23, 59, 59).toIso8601String();

    final todayOrdersResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM orders WHERE order_date >= ? AND order_date <= ?',
      [todayStart, todayEnd]
    );
    final todayOrders = (todayOrdersResult.first['count'] as int?) ?? 0;

    // Get today's revenue
    final todayRevenueResult = await db.rawQuery(
      "SELECT SUM(total_amount) as revenue FROM orders WHERE order_date >= ? AND order_date <= ? AND status != 'Cancelled'",
      [todayStart, todayEnd]
    );
    final todayRevenue = (todayRevenueResult.first['revenue'] as num?)?.toDouble() ?? 0.0;

    // Get total outstanding (balance amount for non-cancelled orders)
    final outstandingResult = await db.rawQuery(
      "SELECT SUM(balance_amount) as outstanding FROM orders WHERE status != 'Cancelled' AND payment_status != 'Paid'"
    );
    final totalOutstanding = (outstandingResult.first['outstanding'] as num?)?.toDouble() ?? 0.0;

    // Get orders by status
    final receivedCount = await db.rawQuery("SELECT COUNT(*) as count FROM orders WHERE status = 'Received'");
    final processingCount = await db.rawQuery("SELECT COUNT(*) as count FROM orders WHERE status = 'Processing'");
    final readyCount = await db.rawQuery("SELECT COUNT(*) as count FROM orders WHERE status = 'Ready'");

    return {
      'total_customers': totalCustomers,
      'total_orders': totalOrders,
      'pending_orders': pendingOrders,
      'today_orders': todayOrders,
      'today_revenue': todayRevenue,
      'total_outstanding': totalOutstanding,
      'received_orders': (receivedCount.first['count'] as int?) ?? 0,
      'processing_orders': (processingCount.first['count'] as int?) ?? 0,
      'ready_orders': (readyCount.first['count'] as int?) ?? 0,
    };
  }
}
