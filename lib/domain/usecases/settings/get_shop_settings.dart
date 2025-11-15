import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/shop_settings.dart';
import '../../repositories/settings_repository.dart';

class GetShopSettings {
  final SettingsRepository repository;

  GetShopSettings(this.repository);

  Future<Either<Failure, ShopSettings>> call() async {
    return await repository.getShopSettings();
  }
}
