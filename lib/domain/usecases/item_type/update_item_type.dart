import 'package:dartz/dartz.dart';
import '../../entities/item_type.dart';
import '../../repositories/service_repository.dart';
import '../../../core/error/failures.dart';

class UpdateItemType {
  final ServiceRepository repository;

  UpdateItemType(this.repository);

  Future<Either<Failure, ItemType>> call(ItemType itemType) async {
    return await repository.updateItemType(itemType);
  }
}
