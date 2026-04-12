import 'package:fpdart/fpdart.dart';
import 'package:node_app/features/home/domain/entities/supplier.dart';
import '../../../../core/error/failure.dart';
import 'package:node_app/features/inventory/domain/entities/product.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<Product>>> getExploreProducts({
    required int page,
    required int pageSize,
    String? supplierId,
    String? category,
  });

  Future<Either<Failure, List<Supplier>>> getSuppliers({
    required int page,
    required int pageSize,
    String? category,
  });
}
