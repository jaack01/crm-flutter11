import 'package:equatable/equatable.dart';
import '../../../domain/entities/shop_settings.dart';
import '../../../domain/entities/notification_settings.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

/// Loading state
class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

/// Shop settings loaded
class ShopSettingsLoaded extends SettingsState {
  final ShopSettings settings;

  const ShopSettingsLoaded(this.settings);

  @override
  List<Object?> get props => [settings];
}

/// Notification settings loaded
class NotificationSettingsLoaded extends SettingsState {
  final NotificationSettings settings;

  const NotificationSettingsLoaded(this.settings);

  @override
  List<Object?> get props => [settings];
}

/// Settings operation success
class SettingsOperationSuccess extends SettingsState {
  final String message;

  const SettingsOperationSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

/// Settings error
class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object?> get props => [message];
}
