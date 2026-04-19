import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/saved_item.dart';

abstract class ISavedItemRepository {
  Future<Either<Failure, Unit>> saveItem(SavedItem item);
  Future<Either<Failure, List<SavedItem>>> getSavedItems(String userId);
  Future<Either<Failure, Unit>> removeSavedItem(String id);
}
