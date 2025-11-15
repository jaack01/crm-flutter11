import 'package:dartz/dartz.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/local/notification_local_datasource.dart';
import '../models/app_notification_model.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationLocalDataSource localDataSource;
  final FlutterLocalNotificationsPlugin? notificationsPlugin;

  NotificationRepositoryImpl({
    required this.localDataSource,
    this.notificationsPlugin,
  });

  @override
  Future<Either<Failure, AppNotification>> scheduleNotification(
    AppNotification notification,
  ) async {
    try {
      final model = AppNotificationModel.fromEntity(notification);
      final int id = await localDataSource.insertNotification(model);

      // Schedule system notification if plugin is available
      if (notificationsPlugin != null) {
        await _scheduleSystemNotification(id, notification);
      }

      final created = await localDataSource.getNotificationById(id);
      return Right(created.toEntity());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelNotification(int id) async {
    try {
      await localDataSource.deleteNotification(id);

      // Cancel system notification if plugin is available
      if (notificationsPlugin != null) {
        await notificationsPlugin!.cancel(id);
      }

      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AppNotification>>> getAllNotifications() async {
    try {
      final result = await localDataSource.getAllNotifications();
      return Right(result.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AppNotification>>> getUnreadNotifications() async {
    try {
      final result = await localDataSource.getUnreadNotifications();
      return Right(result.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(int id) async {
    try {
      await localDataSource.markAsRead(id);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead() async {
    try {
      await localDataSource.markAllAsRead();
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNotification(int id) async {
    try {
      await localDataSource.deleteNotification(id);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearAllNotifications() async {
    try {
      await localDataSource.clearAllNotifications();
      if (notificationsPlugin != null) {
        await notificationsPlugin!.cancelAll();
      }
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> scheduleOrderReadyNotification(
    int orderId,
    String customerName,
    DateTime scheduledTime,
  ) async {
    final notification = AppNotification(
      title: 'Order Ready',
      body: 'Order for $customerName is ready for delivery!',
      type: NotificationType.orderReady,
      referenceId: orderId,
      scheduledTime: scheduledTime,
      createdAt: DateTime.now(),
    );

    final result = await scheduleNotification(notification);
    return result.fold(
      (failure) => Left(failure),
      (_) => const Right(null),
    );
  }

  @override
  Future<Either<Failure, void>> schedulePaymentReminderNotification(
    int orderId,
    String customerName,
    double amount,
    DateTime scheduledTime,
  ) async {
    final notification = AppNotification(
      title: 'Payment Reminder',
      body: 'Payment of ₹$amount pending for $customerName',
      type: NotificationType.paymentDue,
      referenceId: orderId,
      scheduledTime: scheduledTime,
      createdAt: DateTime.now(),
    );

    final result = await scheduleNotification(notification);
    return result.fold(
      (failure) => Left(failure),
      (_) => const Right(null),
    );
  }

  @override
  Future<Either<Failure, void>> scheduleDeliveryNotification(
    int orderId,
    String customerName,
    DateTime scheduledTime,
  ) async {
    final notification = AppNotification(
      title: 'Delivery Due',
      body: 'Order for $customerName is due for delivery today!',
      type: NotificationType.delivery,
      referenceId: orderId,
      scheduledTime: scheduledTime,
      createdAt: DateTime.now(),
    );

    final result = await scheduleNotification(notification);
    return result.fold(
      (failure) => Left(failure),
      (_) => const Right(null),
    );
  }

  @override
  Future<Either<Failure, void>> notifyLowStock(
    String itemName,
    double currentStock,
  ) async {
    final notification = AppNotification(
      title: 'Low Stock Alert',
      body: '$itemName is running low! Current stock: $currentStock',
      type: NotificationType.lowStock,
      scheduledTime: DateTime.now(),
      createdAt: DateTime.now(),
    );

    final result = await scheduleNotification(notification);
    return result.fold(
      (failure) => Left(failure),
      (_) => const Right(null),
    );
  }

  /// Helper method to schedule system notification
  Future<void> _scheduleSystemNotification(
    int id,
    AppNotification notification,
  ) async {
    if (notificationsPlugin == null) return;

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'laundry_crm_channel',
      'Laundry CRM',
      channelDescription: 'Notifications for Laundry CRM',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    // Calculate delay
    final Duration delay = notification.scheduledTime.difference(DateTime.now());

    if (delay.isNegative) {
      // Show immediately if scheduled time is in the past
      await notificationsPlugin!.show(
        id,
        notification.title,
        notification.body,
        platformDetails,
      );
    } else {
      // Schedule for future
      await notificationsPlugin!.zonedSchedule(
        id,
        notification.title,
        notification.body,
        TZDateTime.from(notification.scheduledTime, getLocation('UTC')),
        platformDetails,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }
}

// Timezone imports for scheduling
import 'package:timezone/timezone.dart' as tz;
typedef TZDateTime = tz.TZDateTime;
tz.Location getLocation(String locationName) => tz.getLocation(locationName);
