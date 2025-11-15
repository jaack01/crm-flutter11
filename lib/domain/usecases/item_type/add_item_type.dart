import 'package:dartz/dartz.dart';
import '../../entities/item_type.dart';
import '../../repositories/service_repository.dart';
import '../../../core/error/failures.dart';

class AddItemType {
  final ServiceRepository repository;

  AddItemType(this.repository);

  Future<Either<Failure, ItemType>> call(ItemType itemType) async {
    return await repository.addItemType(itemType);
  }
}
