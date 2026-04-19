import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../entities/product.dart';
import 'package:node_app/features/home/domain/entities/supplier.dart';
import 'package:node_app/features/home/domain/entities/promo_campaign.dart';

abstract class IInventoryRepository {
  Stream<Either<Failure, List<Product>>> watchProducts();
  Future<Either<Failure, List<Product>>> getProducts({
    int limit = 20,
    int offset = 0,
    String? categoryId,
    String? supplierId,
    String? searchQuery,
    bool forceRefresh = false,
  });
  Future<Either<Failure, Product>> getProductById(String id);
  Future<Either<Failure, Product>> addProduct(Product product);
  Future<Either<Failure, Product>> updateProduct(Product product);
  Future<Either<Failure, Unit>> deleteProduct(String id);
  Future<Either<Failure, Unit>> updateStock(String id, int quantity);
  Future<Either<Failure, List<Product>>> getProductsBySupplier(
    String supplierId,
  );
  Future<Either<Failure, List<Supplier>>> getSuppliers({
    int limit = 20,
    int offset = 0,
    String? categoryId,
  });
  Future<Either<Failure, List<PromoCampaign>>> getPromotions({bool forceRefresh = false});
}
