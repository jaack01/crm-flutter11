import 'package:sqflite/sqflite.dart';
import '../../../core/database/database_helper.dart';
import '../../models/app_notification_model.dart';

abstract class NotificationLocalDataSource {
  /// Get all notifications
  Future<List<AppNotificationModel>> getAllNotifications();

  /// Get unread notifications
  Future<List<AppNotificationModel>> getUnreadNotifications();

  /// Get notification by ID
  Future<AppNotificationModel> getNotificationById(int id);

  /// Insert notification
  Future<int> insertNotification(AppNotificationModel notification);

  /// Update notification
  Future<int> updateNotification(AppNotificationModel notification);

  /// Delete notification
  Future<int> deleteNotification(int id);

  /// Mark notification as read
  Future<int> markAsRead(int id);

  /// Mark all notifications as read
  Future<void> markAllAsRead();

  /// Mark notification as delivered
  Future<int> markAsDelivered(int id);

  /// Clear all notifications
  Future<void> clearAllNotifications();

  /// Get pending notifications (scheduled but not delivered)
  Future<List<AppNotificationModel>> getPendingNotifications();
}

class NotificationLocalDataSourceImpl implements NotificationLocalDataSource {
  final DatabaseHelper databaseHelper;

  NotificationLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<AppNotificationModel>> getAllNotifications() async {
    final Database db = await databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'notifications',
      orderBy: 'scheduled_time DESC',
    );

    return List.generate(
      maps.length,
      (i) => AppNotificationModel.fromJson(maps[i]),
    );
  }

  @override
  Future<List<AppNotificationModel>> getUnreadNotifications() async {
    final Database db = await databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'notifications',
      where: 'is_read = ?',
      whereArgs: [0],
      orderBy: 'scheduled_time DESC',
    );

    return List.generate(
      maps.length,
      (i) => AppNotificationModel.fromJson(maps[i]),
    );
  }

  @override
  Future<AppNotificationModel> getNotificationById(int id) async {
    final Database db = await databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'notifications',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) {
      throw Exception('Notification not found');
    }

    return AppNotificationModel.fromJson(maps.first);
  }

  @override
  Future<int> insertNotification(AppNotificationModel notification) async {
    final Database db = await databaseHelper.database;
    return await db.insert('notifications', notification.toJson());
  }

  @override
  Future<int> updateNotification(AppNotificationModel notification) async {
    final Database db = await databaseHelper.database;

    return await db.update(
      'notifications',
      notification.toJson(),
      where: 'id = ?',
      whereArgs: [notification.id],
    );
  }

  @override
  Future<int> deleteNotification(int id) async {
    final Database db = await databaseHelper.database;

    return await db.delete(
      'notifications',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<int> markAsRead(int id) async {
    final Database db = await databaseHelper.database;

    return await db.update(
      'notifications',
      {'is_read': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> markAllAsRead() async {
    final Database db = await databaseHelper.database;

    await db.update(
      'notifications',
      {'is_read': 1},
      where: 'is_read = ?',
      whereArgs: [0],
    );
  }

  @override
  Future<int> markAsDelivered(int id) async {
    final Database db = await databaseHelper.database;

    return await db.update(
      'notifications',
      {'is_delivered': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> clearAllNotifications() async {
    final Database db = await databaseHelper.database;
    await db.delete('notifications');
  }

  @override
  Future<List<AppNotificationModel>> getPendingNotifications() async {
    final Database db = await databaseHelper.database;

    final List<Map<String, dynamic>> maps = await db.query(
      'notifications',
      where: 'is_delivered = ? AND scheduled_time <= ?',
      whereArgs: [0, DateTime.now().toIso8601String()],
      orderBy: 'scheduled_time ASC',
    );

    return List.generate(
      maps.length,
      (i) => AppNotificationModel.fromJson(maps[i]),
    );
  }
}
