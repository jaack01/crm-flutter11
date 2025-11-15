import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/app_notification.dart';

abstract class NotificationRepository {
  /// Schedule a notification
  Future<Either<Failure, AppNotification>> scheduleNotification(
    AppNotification notification,
  );

  /// Cancel a scheduled notification
  Future<Either<Failure, void>> cancelNotification(int id);

  /// Get all notifications
  Future<Either<Failure, List<AppNotification>>> getAllNotifications();

  /// Get unread notifications
  Future<Either<Failure, List<AppNotification>>> getUnreadNotifications();

  /// Mark notification as read
  Future<Either<Failure, void>> markAsRead(int id);

  /// Mark all notifications as read
  Future<Either<Failure, void>> markAllAsRead();

  /// Delete notification
  Future<Either<Failure, void>> deleteNotification(int id);

  /// Clear all notifications
  Future<Either<Failure, void>> clearAllNotifications();

  /// Schedule order ready notification
  Future<Either<Failure, void>> scheduleOrderReadyNotification(
    int orderId,
    String customerName,
    DateTime scheduledTime,
  );

  /// Schedule payment reminder notification
  Future<Either<Failure, void>> schedulePaymentReminderNotification(
    int orderId,
    String customerName,
    double amount,
    DateTime scheduledTime,
  );

  /// Schedule delivery notification
  Future<Either<Failure, void>> scheduleDeliveryNotification(
    int orderId,
    String customerName,
    DateTime scheduledTime,
  );

  /// Notify low stock
  Future<Either<Failure, void>> notifyLowStock(
    String itemName,
    double currentStock,
  );
}
