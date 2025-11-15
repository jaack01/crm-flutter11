import 'package:equatable/equatable.dart';

/// Application notification entity for scheduled notifications
class AppNotification extends Equatable {
  final int? id;
  final String title;
  final String body;
  final String type;
  final int? referenceId;
  final DateTime scheduledTime;
  final bool isDelivered;
  final bool isRead;
  final String? payload;
  final DateTime createdAt;

  const AppNotification({
    this.id,
    required this.title,
    required this.body,
    required this.type,
    this.referenceId,
    required this.scheduledTime,
    this.isDelivered = false,
    this.isRead = false,
    this.payload,
    required this.createdAt,
  });

  AppNotification copyWith({
    int? id,
    String? title,
    String? body,
    String? type,
    int? referenceId,
    DateTime? scheduledTime,
    bool? isDelivered,
    bool? isRead,
    String? payload,
    DateTime? createdAt,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      referenceId: referenceId ?? this.referenceId,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      isDelivered: isDelivered ?? this.isDelivered,
      isRead: isRead ?? this.isRead,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        body,
        type,
        referenceId,
        scheduledTime,
        isDelivered,
        isRead,
        payload,
        createdAt,
      ];
}

/// Notification types
class NotificationType {
  static const String orderReady = 'order_ready';
  static const String paymentDue = 'payment_due';
  static const String delivery = 'delivery';
  static const String lowStock = 'low_stock';
  static const String newOrder = 'new_order';
  static const String custom = 'custom';
}
