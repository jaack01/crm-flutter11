import 'package:sqflite/sqflite.dart';
import '../../../core/database/database_helper.dart';
import '../../models/payment_model.dart';

abstract class PaymentLocalDataSource {
  Future<List<PaymentModel>> getAllPayments();
  Future<List<PaymentModel>> getPaymentsByOrder(int orderId);
  Future<PaymentModel> addPayment(PaymentModel payment);
  Future<double> getTotalPaymentsForOrder(int orderId);
}

class PaymentLocalDataSourceImpl implements PaymentLocalDataSource {
  final DatabaseHelper databaseHelper;

  PaymentLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<PaymentModel>> getAllPayments() async {
    final Database db = await databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT p.*,
             o.order_number,
             c.first_name || ' ' || COALESCE(c.last_name, '') as customer_name
      FROM payments p
      LEFT JOIN orders o ON p.order_id = o.id
      LEFT JOIN customers c ON o.customer_id = c.id
      ORDER BY p.payment_date DESC
    ''');

    return List.generate(maps.length, (i) => PaymentModel.fromJson(maps[i]));
  }

  @override
  Future<List<PaymentModel>> getPaymentsByOrder(int orderId) async {
    final Database db = await databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT p.*,
             o.order_number,
             c.first_name || ' ' || COALESCE(c.last_name, '') as customer_name
      FROM payments p
      LEFT JOIN orders o ON p.order_id = o.id
      LEFT JOIN customers c ON o.customer_id = c.id
      WHERE p.order_id = ?
      ORDER BY p.payment_date DESC
    ''', [orderId]);

    return List.generate(maps.length, (i) => PaymentModel.fromJson(maps[i]));
  }

  @override
  Future<PaymentModel> addPayment(PaymentModel payment) async {
    final Database db = await databaseHelper.database;

    return await db.transaction((txn) async {
      // Insert payment
      final int paymentId = await txn.insert('payments', payment.toJson());

      // Update order payment status
      final List<Map<String, dynamic>> totalResult = await txn.rawQuery('''
        SELECT SUM(amount) as total_paid
        FROM payments
        WHERE order_id = ?
      ''', [payment.orderId]);

      final double totalPaid = (totalResult.first['total_paid'] as num?)?.toDouble() ?? 0.0;

      final List<Map<String, dynamic>> orderResult = await txn.query(
        'orders',
        columns: ['total_amount'],
        where: 'id = ?',
        whereArgs: [payment.orderId],
      );

      if (orderResult.isNotEmpty) {
        final double totalAmount = (orderResult.first['total_amount'] as num).toDouble();
        final double balance = totalAmount - totalPaid;

        String paymentStatus;
        if (totalPaid == 0) {
          paymentStatus = 'Pending';
        } else if (totalPaid >= totalAmount) {
          paymentStatus = 'Paid';
        } else {
          paymentStatus = 'Partial';
        }

        await txn.update(
          'orders',
          {
            'advance_paid': totalPaid,
            'balance_amount': balance,
            'payment_status': paymentStatus,
            'updated_at': DateTime.now().toIso8601String(),
          },
          where: 'id = ?',
          whereArgs: [payment.orderId],
        );
      }

      // Get created payment with populated fields
      final List<Map<String, dynamic>> maps = await txn.rawQuery('''
        SELECT p.*,
               o.order_number,
               c.first_name || ' ' || COALESCE(c.last_name, '') as customer_name
        FROM payments p
        LEFT JOIN orders o ON p.order_id = o.id
        LEFT JOIN customers c ON o.customer_id = c.id
        WHERE p.id = ?
      ''', [paymentId]);

      return PaymentModel.fromJson(maps.first);
    });
  }

  @override
  Future<double> getTotalPaymentsForOrder(int orderId) async {
    final Database db = await databaseHelper.database;

    final List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT SUM(amount) as total
      FROM payments
      WHERE order_id = ?
    ''', [orderId]);

    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }
}
