import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/notification_settings.dart';
import '../../repositories/settings_repository.dart';

class GetNotificationSettings {
  final SettingsRepository repository;

  GetNotificationSettings(this.repository);

  Future<Either<Failure, NotificationSettings>> call() async {
    return await repository.getNotificationSettings();
  }
}
