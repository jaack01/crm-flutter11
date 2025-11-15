import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/shop_settings.dart';
import '../../repositories/settings_repository.dart';

class UpdateShopSettings {
  final SettingsRepository repository;

  UpdateShopSettings(this.repository);

  Future<Either<Failure, ShopSettings>> call(ShopSettings settings) async {
    return await repository.updateShopSettings(settings);
  }
}
