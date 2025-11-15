import 'package:equatable/equatable.dart';

/// Notification settings entity for configuring app notifications
class NotificationSettings extends Equatable {
  final int? id;
  final bool enableNotifications;
  final bool notifyOrderReady;
  final bool notifyPaymentDue;
  final bool notifyDelivery;
  final bool notifyLowStock;
  final bool notifyNewOrder;
  final int paymentReminderDays;
  final String notificationSound;
  final bool vibrate;
  final String quietHoursStart;
  final String quietHoursEnd;
  final DateTime? updatedAt;

  const NotificationSettings({
    this.id,
    this.enableNotifications = true,
    this.notifyOrderReady = true,
    this.notifyPaymentDue = true,
    this.notifyDelivery = true,
    this.notifyLowStock = true,
    this.notifyNewOrder = true,
    this.paymentReminderDays = 3,
    this.notificationSound = 'default',
    this.vibrate = true,
    this.quietHoursStart = '22:00',
    this.quietHoursEnd = '08:00',
    this.updatedAt,
  });

  /// Check if currently in quiet hours
  bool get isQuietHours {
    final now = DateTime.now();
    final start = _parseTime(quietHoursStart);
    final end = _parseTime(quietHoursEnd);
    final current = TimeOfDay.fromDateTime(now);

    if (start.hour < end.hour) {
      return current.hour >= start.hour && current.hour < end.hour;
    } else {
      return current.hour >= start.hour || current.hour < end.hour;
    }
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  NotificationSettings copyWith({
    int? id,
    bool? enableNotifications,
    bool? notifyOrderReady,
    bool? notifyPaymentDue,
    bool? notifyDelivery,
    bool? notifyLowStock,
    bool? notifyNewOrder,
    int? paymentReminderDays,
    String? notificationSound,
    bool? vibrate,
    String? quietHoursStart,
    String? quietHoursEnd,
    DateTime? updatedAt,
  }) {
    return NotificationSettings(
      id: id ?? this.id,
      enableNotifications: enableNotifications ?? this.enableNotifications,
      notifyOrderReady: notifyOrderReady ?? this.notifyOrderReady,
      notifyPaymentDue: notifyPaymentDue ?? this.notifyPaymentDue,
      notifyDelivery: notifyDelivery ?? this.notifyDelivery,
      notifyLowStock: notifyLowStock ?? this.notifyLowStock,
      notifyNewOrder: notifyNewOrder ?? this.notifyNewOrder,
      paymentReminderDays: paymentReminderDays ?? this.paymentReminderDays,
      notificationSound: notificationSound ?? this.notificationSound,
      vibrate: vibrate ?? this.vibrate,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        enableNotifications,
        notifyOrderReady,
        notifyPaymentDue,
        notifyDelivery,
        notifyLowStock,
        notifyNewOrder,
        paymentReminderDays,
        notificationSound,
        vibrate,
        quietHoursStart,
        quietHoursEnd,
        updatedAt,
      ];
}

/// TimeOfDay helper class (simplified)
class TimeOfDay {
  final int hour;
  final int minute;

  const TimeOfDay({required this.hour, required this.minute});

  factory TimeOfDay.fromDateTime(DateTime dateTime) {
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }
}
