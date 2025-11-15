import 'package:dartz/dartz.dart';
import '../../entities/item_type.dart';
import '../../repositories/service_repository.dart';
import '../../../core/error/failures.dart';

class GetAllItemTypes {
  final ServiceRepository repository;

  GetAllItemTypes(this.repository);

  Future<Either<Failure, List<ItemType>>> call() async {
    return await repository.getAllItemTypes();
  }
}
