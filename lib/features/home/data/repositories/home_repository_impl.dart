import 'package:fpdart/fpdart.dart';
import 'package:node_app/features/inventory/domain/entities/product.dart';
import 'package:node_app/features/home/domain/entities/promo_campaign.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/supplier.dart';
import '../../domain/repositories/home_repository.dart';
import 'package:node_app/features/inventory/domain/repositories/i_inventory_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final IInventoryRepository inventoryRepository;

  HomeRepositoryImpl(this.inventoryRepository);

  @override
  Future<Either<Failure, List<Product>>> getExploreProducts({
    required int page,
    required int pageSize,
    String? supplierId,
    String? category,
  }) async {
    return await inventoryRepository.getProducts(
      limit: pageSize,
      offset: page * pageSize,
      supplierId: supplierId,
      categoryId: category,
    );
  }

  @override
  Future<Either<Failure, List<Supplier>>> getSuppliers({
    required int page,
    required int pageSize,
    String? category,
  }) async {
    return await inventoryRepository.getSuppliers(
      limit: pageSize,
      offset: page * pageSize,
      categoryId: category,
    );
  }
  @override
  Future<Either<Failure, List<PromoCampaign>>> getPromotions() async {
    return await inventoryRepository.getPromotions();
  }
}
