import 'package:fpdart/fpdart.dart';
import 'package:node_app/features/inventory/domain/entities/product.dart';
import 'package:node_app/features/home/data/product_dummy_data.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/supplier.dart';
import '../../domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  @override
  Future<Either<Failure, List<Product>>> getExploreProducts({
    required int page,
    required int pageSize,
    String? supplierId,
    String? category,
  }) async {
    try {
      // ⏱️ Simulate minimal delay
      await Future.delayed(const Duration(milliseconds: 300));

      final allProducts = ProductDummyData.products;

      var filtered = allProducts.where((p) {
        if (category != null && p.categoryId != category) return false;
        if (supplierId != null && p.supplier.id != supplierId) return false;
        return true;
      }).toList();

      // If no perfect match (supplier + category), fallback to just category
      if (filtered.isEmpty && category != null) {
        filtered = allProducts.where((p) => p.categoryId == category).toList();
      }

      // If still empty or very few, just show some default products
      if (filtered.length < 2) {
        filtered = allProducts.take(10).toList();
      }

      final startIndex = page * pageSize;
      if (startIndex >= filtered.length) return const Right([]);

      final paginated = filtered.skip(startIndex).take(pageSize).toList();

      return Right(paginated);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Supplier>>> getSuppliers({
    required int page,
    required int pageSize,
    String? category,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      return const Right([]);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
