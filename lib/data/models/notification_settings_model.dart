import '../../domain/entities/notification_settings.dart';

class NotificationSettingsModel extends NotificationSettings {
  const NotificationSettingsModel({
    super.id,
    super.enableNotifications,
    super.notifyOrderReady,
    super.notifyPaymentDue,
    super.notifyDelivery,
    super.notifyLowStock,
    super.notifyNewOrder,
    super.paymentReminderDays,
    super.notificationSound,
    super.vibrate,
    super.quietHoursStart,
    super.quietHoursEnd,
    super.updatedAt,
  });

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) {
    return NotificationSettingsModel(
      id: json['id'] as int?,
      enableNotifications: (json['enable_notifications'] as int?) == 1,
      notifyOrderReady: (json['notify_order_ready'] as int?) == 1,
      notifyPaymentDue: (json['notify_payment_due'] as int?) == 1,
      notifyDelivery: (json['notify_delivery'] as int?) == 1,
      notifyLowStock: (json['notify_low_stock'] as int?) == 1,
      notifyNewOrder: (json['notify_new_order'] as int?) == 1,
      paymentReminderDays: json['payment_reminder_days'] as int? ?? 3,
      notificationSound: json['notification_sound'] as String? ?? 'default',
      vibrate: (json['vibrate'] as int?) == 1,
      quietHoursStart: json['quiet_hours_start'] as String? ?? '22:00',
      quietHoursEnd: json['quiet_hours_end'] as String? ?? '08:00',
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'enable_notifications': enableNotifications ? 1 : 0,
      'notify_order_ready': notifyOrderReady ? 1 : 0,
      'notify_payment_due': notifyPaymentDue ? 1 : 0,
      'notify_delivery': notifyDelivery ? 1 : 0,
      'notify_low_stock': notifyLowStock ? 1 : 0,
      'notify_new_order': notifyNewOrder ? 1 : 0,
      'payment_reminder_days': paymentReminderDays,
      'notification_sound': notificationSound,
      'vibrate': vibrate ? 1 : 0,
      'quiet_hours_start': quietHoursStart,
      'quiet_hours_end': quietHoursEnd,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  NotificationSettings toEntity() {
    return NotificationSettings(
      id: id,
      enableNotifications: enableNotifications,
      notifyOrderReady: notifyOrderReady,
      notifyPaymentDue: notifyPaymentDue,
      notifyDelivery: notifyDelivery,
      notifyLowStock: notifyLowStock,
      notifyNewOrder: notifyNewOrder,
      paymentReminderDays: paymentReminderDays,
      notificationSound: notificationSound,
      vibrate: vibrate,
      quietHoursStart: quietHoursStart,
      quietHoursEnd: quietHoursEnd,
      updatedAt: updatedAt,
    );
  }

  factory NotificationSettingsModel.fromEntity(NotificationSettings entity) {
    return NotificationSettingsModel(
      id: entity.id,
      enableNotifications: entity.enableNotifications,
      notifyOrderReady: entity.notifyOrderReady,
      notifyPaymentDue: entity.notifyPaymentDue,
      notifyDelivery: entity.notifyDelivery,
      notifyLowStock: entity.notifyLowStock,
      notifyNewOrder: entity.notifyNewOrder,
      paymentReminderDays: entity.paymentReminderDays,
      notificationSound: entity.notificationSound,
      vibrate: entity.vibrate,
      quietHoursStart: entity.quietHoursStart,
      quietHoursEnd: entity.quietHoursEnd,
      updatedAt: entity.updatedAt,
    );
  }
}
