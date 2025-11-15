import '../../domain/entities/app_notification.dart';

class AppNotificationModel extends AppNotification {
  const AppNotificationModel({
    super.id,
    required super.title,
    required super.body,
    required super.type,
    super.referenceId,
    required super.scheduledTime,
    super.isDelivered,
    super.isRead,
    super.payload,
    required super.createdAt,
  });

  factory AppNotificationModel.fromJson(Map<String, dynamic> json) {
    return AppNotificationModel(
      id: json['id'] as int?,
      title: json['title'] as String,
      body: json['body'] as String,
      type: json['type'] as String,
      referenceId: json['reference_id'] as int?,
      scheduledTime: DateTime.parse(json['scheduled_time'] as String),
      isDelivered: (json['is_delivered'] as int?) == 1,
      isRead: (json['is_read'] as int?) == 1,
      payload: json['payload'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'body': body,
      'type': type,
      'reference_id': referenceId,
      'scheduled_time': scheduledTime.toIso8601String(),
      'is_delivered': isDelivered ? 1 : 0,
      'is_read': isRead ? 1 : 0,
      'payload': payload,
      'created_at': createdAt.toIso8601String(),
    };
  }

  AppNotification toEntity() {
    return AppNotification(
      id: id,
      title: title,
      body: body,
      type: type,
      referenceId: referenceId,
      scheduledTime: scheduledTime,
      isDelivered: isDelivered,
      isRead: isRead,
      payload: payload,
      createdAt: createdAt,
    );
  }

  factory AppNotificationModel.fromEntity(AppNotification entity) {
    return AppNotificationModel(
      id: entity.id,
      title: entity.title,
      body: entity.body,
      type: entity.type,
      referenceId: entity.referenceId,
      scheduledTime: entity.scheduledTime,
      isDelivered: entity.isDelivered,
      isRead: entity.isRead,
      payload: entity.payload,
      createdAt: entity.createdAt,
    );
  }
}
