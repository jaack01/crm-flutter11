import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/notification_settings.dart';
import '../../repositories/settings_repository.dart';

class UpdateNotificationSettings {
  final SettingsRepository repository;

  UpdateNotificationSettings(this.repository);

  Future<Either<Failure, NotificationSettings>> call(
    NotificationSettings settings,
  ) async {
    return await repository.updateNotificationSettings(settings);
  }
}
