import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/shop_settings.dart';
import '../entities/notification_settings.dart';

abstract class SettingsRepository {
  /// Get shop settings
  Future<Either<Failure, ShopSettings>> getShopSettings();

  /// Update shop settings
  Future<Either<Failure, ShopSettings>> updateShopSettings(ShopSettings settings);

  /// Get notification settings
  Future<Either<Failure, NotificationSettings>> getNotificationSettings();

  /// Update notification settings
  Future<Either<Failure, NotificationSettings>> updateNotificationSettings(
    NotificationSettings settings,
  );

  /// Get app setting value by key
  Future<Either<Failure, String?>> getSettingValue(String key);

  /// Set app setting value
  Future<Either<Failure, void>> setSettingValue(String key, String value);

  /// Reset all settings to default
  Future<Either<Failure, void>> resetToDefaults();
}
