import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/shop_settings.dart';
import '../../domain/entities/notification_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/local/settings_local_datasource.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, ShopSettings>> getShopSettings() async {
    try {
      final result = await localDataSource.getShopSettings();
      return Right(result.toEntity());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ShopSettings>> updateShopSettings(ShopSettings settings) async {
    try {
      final model = ShopSettingsModel.fromEntity(settings);
      await localDataSource.updateShopSettings(model);
      final updated = await localDataSource.getShopSettings();
      return Right(updated.toEntity());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NotificationSettings>> getNotificationSettings() async {
    try {
      final result = await localDataSource.getNotificationSettings();
      return Right(result.toEntity());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, NotificationSettings>> updateNotificationSettings(
    NotificationSettings settings,
  ) async {
    try {
      final model = NotificationSettingsModel.fromEntity(settings);
      await localDataSource.updateNotificationSettings(model);
      final updated = await localDataSource.getNotificationSettings();
      return Right(updated.toEntity());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String?>> getSettingValue(String key) async {
    try {
      final result = await localDataSource.getSettingValue(key);
      return Right(result);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setSettingValue(String key, String value) async {
    try {
      await localDataSource.setSettingValue(key, value);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetToDefaults() async {
    try {
      await localDataSource.resetToDefaults();
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}

// Import statement needed for ShopSettingsModel
import '../models/shop_settings_model.dart';
import '../models/notification_settings_model.dart';
