import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';
import '../../domain/entities/analytics.dart';

class AnalyticsService {
  final DatabaseHelper databaseHelper;

  AnalyticsService({required this.databaseHelper});

  /// Get complete analytics report for a date range
  Future<AnalyticsReport> getAnalyticsReport({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final start = startDate ?? DateTime.now().subtract(const Duration(days: 30));
    final end = endDate ?? DateTime.now();

    final revenueAnalytics = await getRevenueAnalytics(startDate: start, endDate: end);
    final servicePopularity = await getServicePopularity(startDate: start, endDate: end);
    final orderStatusBreakdown = await getOrderStatusBreakdown(startDate: start, endDate: end);
    final paymentStatusBreakdown = await getPaymentStatusBreakdown(startDate: start, endDate: end);
    final customerAnalytics = await getCustomerAnalytics();
    final dailyRevenue = await getDailyRevenue(startDate: start, endDate: end);

    return AnalyticsReport(
      revenueAnalytics: revenueAnalytics,
      servicePopularity: servicePopularity,
      orderStatusBreakdown: orderStatusBreakdown,
      paymentStatusBreakdown: paymentStatusBreakdown,
      customerAnalytics: customerAnalytics,
      dailyRevenue: dailyRevenue,
      generatedAt: DateTime.now(),
    );
  }

  /// Get revenue analytics
  Future<RevenueAnalytics> getRevenueAnalytics({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final Database db = await databaseHelper.database;

    final result = await db.rawQuery('''
      SELECT
        COUNT(*) as total_orders,
        COALESCE(SUM(total_amount), 0) as total_revenue,
        COALESCE(SUM(advance_paid), 0) as paid_amount,
        COALESCE(SUM(balance_amount), 0) as pending_amount
      FROM orders
      WHERE order_date >= ? AND order_date <= ?
      AND status != 'Cancelled'
    ''', [startDate.toIso8601String(), endDate.toIso8601String()]);

    final row = result.first;
    final totalOrders = (row['total_orders'] as int?) ?? 0;
    final totalRevenue = (row['total_revenue'] as num?)?.toDouble() ?? 0.0;
    final paidAmount = (row['paid_amount'] as num?)?.toDouble() ?? 0.0;
    final pendingAmount = (row['pending_amount'] as num?)?.toDouble() ?? 0.0;

    return RevenueAnalytics(
      totalRevenue: totalRevenue,
      paidAmount: paidAmount,
      pendingAmount: pendingAmount,
      totalOrders: totalOrders,
      averageOrderValue: totalOrders > 0 ? totalRevenue / totalOrders : 0.0,
    );
  }

  /// Get service popularity
  Future<List<ServicePopularity>> getServicePopularity({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final Database db = await databaseHelper.database;

    final result = await db.rawQuery('''
      SELECT
        s.service_name,
        COUNT(DISTINCT o.id) as order_count,
        COALESCE(SUM(oi.total_price), 0) as revenue
      FROM order_items oi
      INNER JOIN orders o ON oi.order_id = o.id
      INNER JOIN services s ON oi.service_id = s.id
      WHERE o.order_date >= ? AND o.order_date <= ?
      AND o.status != 'Cancelled'
      GROUP BY s.id, s.service_name
      ORDER BY revenue DESC
    ''', [startDate.toIso8601String(), endDate.toIso8601String()]);

    final totalRevenue = result.fold<double>(
      0.0,
      (sum, row) => sum + ((row['revenue'] as num?)?.toDouble() ?? 0.0),
    );

    return result.map((row) {
      final revenue = (row['revenue'] as num?)?.toDouble() ?? 0.0;
      return ServicePopularity(
        serviceName: row['service_name'] as String,
        orderCount: (row['order_count'] as int?) ?? 0,
        revenue: revenue,
        percentage: totalRevenue > 0 ? (revenue / totalRevenue) * 100 : 0.0,
      );
    }).toList();
  }

  /// Get order status breakdown
  Future<List<OrderStatusBreakdown>> getOrderStatusBreakdown({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final Database db = await databaseHelper.database;

    final result = await db.rawQuery('''
      SELECT
        status,
        COUNT(*) as count
      FROM orders
      WHERE order_date >= ? AND order_date <= ?
      GROUP BY status
      ORDER BY count DESC
    ''', [startDate.toIso8601String(), endDate.toIso8601String()]);

    final totalOrders = result.fold<int>(0, (sum, row) => sum + ((row['count'] as int?) ?? 0));

    return result.map((row) {
      final count = (row['count'] as int?) ?? 0;
      return OrderStatusBreakdown(
        status: row['status'] as String,
        count: count,
        percentage: totalOrders > 0 ? (count / totalOrders) * 100 : 0.0,
      );
    }).toList();
  }

  /// Get payment status breakdown
  Future<List<PaymentStatusBreakdown>> getPaymentStatusBreakdown({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final Database db = await databaseHelper.database;

    final result = await db.rawQuery('''
      SELECT
        payment_status,
        COUNT(*) as count,
        COALESCE(SUM(total_amount), 0) as amount
      FROM orders
      WHERE order_date >= ? AND order_date <= ?
      AND status != 'Cancelled'
      GROUP BY payment_status
      ORDER BY count DESC
    ''', [startDate.toIso8601String(), endDate.toIso8601String()]);

    final totalOrders = result.fold<int>(0, (sum, row) => sum + ((row['count'] as int?) ?? 0));

    return result.map((row) {
      final count = (row['count'] as int?) ?? 0;
      return PaymentStatusBreakdown(
        status: row['payment_status'] as String,
        count: count,
        amount: (row['amount'] as num?)?.toDouble() ?? 0.0,
        percentage: totalOrders > 0 ? (count / totalOrders) * 100 : 0.0,
      );
    }).toList();
  }

  /// Get customer analytics
  Future<CustomerAnalytics> getCustomerAnalytics() async {
    final Database db = await databaseHelper.database;

    // Total customers
    final totalResult = await db.rawQuery(
      'SELECT COUNT(*) as count FROM customers WHERE is_active = 1',
    );
    final totalCustomers = (totalResult.first['count'] as int?) ?? 0;

    // Active customers (with at least one order)
    final activeResult = await db.rawQuery('''
      SELECT COUNT(DISTINCT customer_id) as count
      FROM orders
      WHERE status != 'Cancelled'
    ''');
    final activeCustomers = (activeResult.first['count'] as int?) ?? 0;

    // New customers (last 30 days)
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    final newResult = await db.rawQuery('''
      SELECT COUNT(*) as count
      FROM customers
      WHERE created_at >= ? AND is_active = 1
    ''', [thirtyDaysAgo.toIso8601String()]);
    final newCustomers = (newResult.first['count'] as int?) ?? 0;

    // VIP customers
    final vipResult = await db.rawQuery('''
      SELECT COUNT(*) as count
      FROM customers
      WHERE customer_type = 'VIP' AND is_active = 1
    ''');
    final vipCustomers = (vipResult.first['count'] as int?) ?? 0;

    // Customer types breakdown
    final typesResult = await db.rawQuery('''
      SELECT customer_type, COUNT(*) as count
      FROM customers
      WHERE is_active = 1
      GROUP BY customer_type
    ''');
    final customersByType = Map<String, int>.fromEntries(
      typesResult.map((row) => MapEntry(
            row['customer_type'] as String,
            (row['count'] as int?) ?? 0,
          )),
    );

    // Average customer value
    final revenueResult = await db.rawQuery('''
      SELECT
        COALESCE(SUM(o.total_amount), 0) as total_revenue,
        COUNT(DISTINCT o.customer_id) as customer_count
      FROM orders o
      WHERE o.status != 'Cancelled'
    ''');
    final totalRevenue = (revenueResult.first['total_revenue'] as num?)?.toDouble() ?? 0.0;
    final customerCount = (revenueResult.first['customer_count'] as int?) ?? 0;
    final averageCustomerValue = customerCount > 0 ? totalRevenue / customerCount : 0.0;

    return CustomerAnalytics(
      totalCustomers: totalCustomers,
      activeCustomers: activeCustomers,
      newCustomers: newCustomers,
      vipCustomers: vipCustomers,
      averageCustomerValue: averageCustomerValue,
      customersByType: customersByType,
    );
  }

  /// Get daily revenue for date range
  Future<List<DailyRevenue>> getDailyRevenue({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final Database db = await databaseHelper.database;

    final result = await db.rawQuery('''
      SELECT
        DATE(order_date) as date,
        COUNT(*) as order_count,
        COALESCE(SUM(total_amount), 0) as revenue
      FROM orders
      WHERE order_date >= ? AND order_date <= ?
      AND status != 'Cancelled'
      GROUP BY DATE(order_date)
      ORDER BY date ASC
    ''', [startDate.toIso8601String(), endDate.toIso8601String()]);

    return result.map((row) {
      return DailyRevenue(
        date: DateTime.parse(row['date'] as String),
        revenue: (row['revenue'] as num?)?.toDouble() ?? 0.0,
        orderCount: (row['order_count'] as int?) ?? 0,
      );
    }).toList();
  }

  /// Export report to CSV format
  Future<String> exportToCSV(AnalyticsReport report) async {
    final buffer = StringBuffer();

    // Header
    buffer.writeln('Laundry CRM Analytics Report');
    buffer.writeln('Generated: ${report.generatedAt}');
    buffer.writeln('');

    // Revenue Analytics
    buffer.writeln('REVENUE ANALYTICS');
    buffer.writeln('Total Revenue,${report.revenueAnalytics.totalRevenue.toStringAsFixed(2)}');
    buffer.writeln('Paid Amount,${report.revenueAnalytics.paidAmount.toStringAsFixed(2)}');
    buffer.writeln('Pending Amount,${report.revenueAnalytics.pendingAmount.toStringAsFixed(2)}');
    buffer.writeln('Total Orders,${report.revenueAnalytics.totalOrders}');
    buffer.writeln('Average Order Value,${report.revenueAnalytics.averageOrderValue.toStringAsFixed(2)}');
    buffer.writeln('');

    // Service Popularity
    buffer.writeln('SERVICE POPULARITY');
    buffer.writeln('Service Name,Order Count,Revenue,Percentage');
    for (final service in report.servicePopularity) {
      buffer.writeln('${service.serviceName},${service.orderCount},${service.revenue.toStringAsFixed(2)},${service.percentage.toStringAsFixed(1)}%');
    }
    buffer.writeln('');

    // Order Status
    buffer.writeln('ORDER STATUS BREAKDOWN');
    buffer.writeln('Status,Count,Percentage');
    for (final status in report.orderStatusBreakdown) {
      buffer.writeln('${status.status},${status.count},${status.percentage.toStringAsFixed(1)}%');
    }
    buffer.writeln('');

    // Payment Status
    buffer.writeln('PAYMENT STATUS BREAKDOWN');
    buffer.writeln('Status,Count,Amount,Percentage');
    for (final payment in report.paymentStatusBreakdown) {
      buffer.writeln('${payment.status},${payment.count},${payment.amount.toStringAsFixed(2)},${payment.percentage.toStringAsFixed(1)}%');
    }
    buffer.writeln('');

    // Customer Analytics
    buffer.writeln('CUSTOMER ANALYTICS');
    buffer.writeln('Total Customers,${report.customerAnalytics.totalCustomers}');
    buffer.writeln('Active Customers,${report.customerAnalytics.activeCustomers}');
    buffer.writeln('New Customers (30 days),${report.customerAnalytics.newCustomers}');
    buffer.writeln('VIP Customers,${report.customerAnalytics.vipCustomers}');
    buffer.writeln('Average Customer Value,${report.customerAnalytics.averageCustomerValue.toStringAsFixed(2)}');
    buffer.writeln('');

    // Daily Revenue
    buffer.writeln('DAILY REVENUE');
    buffer.writeln('Date,Order Count,Revenue');
    for (final daily in report.dailyRevenue) {
      buffer.writeln('${daily.date.toIso8601String().split('T')[0]},${daily.orderCount},${daily.revenue.toStringAsFixed(2)}');
    }

    return buffer.toString();
  }
}
