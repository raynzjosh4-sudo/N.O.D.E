import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../entities/product.dart';

abstract class IInventoryRepository {
  Stream<Either<Failure, List<Product>>> watchProducts();
  Future<Either<Failure, List<Product>>> getProducts({bool forceRefresh = false});
  Future<Either<Failure, Product>> getProductById(String id);
  Future<Either<Failure, Product>> addProduct(Product product);
  Future<Either<Failure, Product>> updateProduct(Product product);
  Future<Either<Failure, Unit>> deleteProduct(String id);
  Future<Either<Failure, Unit>> updateStock(String id, int quantity);
  Future<Either<Failure, List<Product>>> getProductsBySupplier(String supplierId);
}
