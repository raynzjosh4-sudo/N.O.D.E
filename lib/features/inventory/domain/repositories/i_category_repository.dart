import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../entities/category.dart';

abstract class ICategoryRepository {
  Stream<Either<Failure, List<ProductCategory>>> watchCategories();
  Future<Either<Failure, List<ProductCategory>>> getCategories({
    String? parentId,
    int limit = 100,
    int offset = 0,
    bool forceRefresh = false,
  });
  Future<Either<Failure, List<ProductCategory>>> getTopCategories();
  Future<Either<Failure, Unit>> incrementCategoryUsage(String id);
}
