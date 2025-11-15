import 'package:equatable/equatable.dart';
import '../../../domain/entities/shop_settings.dart';
import '../../../domain/entities/notification_settings.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

/// Load shop settings
class LoadShopSettings extends SettingsEvent {
  const LoadShopSettings();
}

/// Update shop settings
class UpdateShopSettingsEvent extends SettingsEvent {
  final ShopSettings settings;

  const UpdateShopSettingsEvent(this.settings);

  @override
  List<Object?> get props => [settings];
}

/// Load notification settings
class LoadNotificationSettings extends SettingsEvent {
  const LoadNotificationSettings();
}

/// Update notification settings
class UpdateNotificationSettingsEvent extends SettingsEvent {
  final NotificationSettings settings;

  const UpdateNotificationSettingsEvent(this.settings);

  @override
  List<Object?> get props => [settings];
}

/// Reset settings to defaults
class ResetSettingsToDefaults extends SettingsEvent {
  const ResetSettingsToDefaults();
}
