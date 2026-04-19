import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:node_app/features/home/domain/entities/promo_campaign.dart';
import 'package:node_app/features/home/domain/entities/supplier.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/i_inventory_repository.dart';
import '../datasources/inventory_local_data_source.dart';
import '../datasources/inventory_remote_data_source.dart';
import '../models/product_model.dart';

class InventoryRepositoryImpl implements IInventoryRepository {
  final IInventoryRemoteDataSource remoteDataSource;
  final IInventoryLocalDataSource localDataSource;

  InventoryRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Stream<Either<Failure, List<Product>>> watchProducts() {
    return localDataSource.watchProducts().map(
      (models) => Right<Failure, List<Product>>(models.cast<Product>()),
    );
  }

  @override
  Future<Either<Failure, List<Product>>> getProducts({
    int limit = 20,
    int offset = 0,
    String? categoryId,
    String? supplierId,
    String? searchQuery,
    bool forceRefresh = false,
  }) async {
    try {
      final localProducts = await localDataSource.getProducts(
        limit: limit,
        offset: offset,
        categoryId: categoryId,
        supplierId: supplierId,
        searchQuery: searchQuery,
      );

      if (localProducts.isNotEmpty && !forceRefresh) {
        _refreshProductsInBackground(
          limit: limit,
          offset: offset,
          categoryId: categoryId,
          supplierId: supplierId,
          searchQuery: searchQuery,
        );
        return Right<Failure, List<Product>>(localProducts.cast<Product>());
      }

      final remoteProductsOrFailure = await _fetchAndCacheRemoteProducts(
        limit: limit,
        offset: offset,
        categoryId: categoryId,
        supplierId: supplierId,
        searchQuery: searchQuery,
      );

      // If remote fetch fails during a force refresh, fallback to local data if we have it!
      return remoteProductsOrFailure.fold(
        (failure) {
          if (localProducts.isNotEmpty) {
            debugPrint('🏢 [Repo] Remote refresh failed, falling back to local cache.');
            return Right<Failure, List<Product>>(localProducts.cast<Product>());
          }
          return Left(failure);
        },
        (products) {
          if (products.isEmpty && localProducts.isNotEmpty) {
            debugPrint('🏢 [Repo] Remote refresh returned 0 products. Retaining local cache data to prevent UI wipe.');
            return Right(localProducts.cast<Product>());
          }
          return Right(products);
        },
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  void _refreshProductsInBackground({
    required int limit,
    required int offset,
    String? categoryId,
    String? supplierId,
    String? searchQuery,
  }) {
    _fetchAndCacheRemoteProducts(
      limit: limit,
      offset: offset,
      categoryId: categoryId,
      supplierId: supplierId,
      searchQuery: searchQuery,
    ).catchError((e) {
      debugPrint('🏢 [Repo] Background refresh failed: $e');
    });
  }

  Future<Either<Failure, List<Product>>> _fetchAndCacheRemoteProducts({
    required int limit,
    required int offset,
    String? categoryId,
    String? supplierId,
    String? searchQuery,
  }) async {
    try {
      final remoteProducts = await remoteDataSource.getProducts(
        limit: limit,
        offset: offset,
        categoryId: categoryId,
        supplierId: supplierId,
        searchQuery: searchQuery,
      );

      if (remoteProducts.isNotEmpty) {
        await localDataSource.cacheProducts(remoteProducts);
      }
      return Right<Failure, List<Product>>(remoteProducts.cast<Product>());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }


  @override
  Future<Either<Failure, Product>> getProductById(String id) async {
    try {
      // Try local first
      final localProducts = await localDataSource.getProducts();
      final localProduct = localProducts.where((p) => p.id == id).firstOrNull;

      if (localProduct != null) return Right(localProduct);

      // Fallback to remote
      final remoteProduct = await remoteDataSource.getProductById(id);
      await localDataSource.cacheProduct(remoteProduct);
      return Right(remoteProduct);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Product>> addProduct(Product product) async {
    try {
      final model = ProductModel.fromEntity(product);
      final remoteProduct = await remoteDataSource.addProduct(model);
      await localDataSource.cacheProduct(remoteProduct);
      return Right(remoteProduct);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Product>> updateProduct(Product product) async {
    try {
      final model = ProductModel.fromEntity(product);
      final remoteProduct = await remoteDataSource.updateProduct(model);
      await localDataSource.cacheProduct(remoteProduct);
      return Right(remoteProduct);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteProduct(String id) async {
    try {
      await remoteDataSource.deleteProduct(id);
      await localDataSource.deleteProduct(id);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateStock(String id, int quantity) async {
    try {
      // Update remote first (source of truth for stock)
      await remoteDataSource.updateStock(id, quantity);

      // Fetch latest to update local cache
      final updatedProduct = await remoteDataSource.getProductById(id);
      await localDataSource.cacheProduct(updatedProduct);

      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsBySupplier(
    String supplierId,
  ) async {
    try {
      final localProducts = await localDataSource.getProducts();
      final filtered = localProducts
          .where((p) => p.supplierId == supplierId)
          .toList();

      if (filtered.isNotEmpty) {
        return Right(filtered.cast<Product>());
      }

      // If not in cache, we'd normally fetch from remote by supplier.
      // For now, let's fetch all and filter to ensure cache is warm.
      debugPrint('🏢 [Repo] Supplier products not in cache. Fetching all...');
      await _fetchAndCacheRemoteProducts(limit: 100, offset: 0);
      final freshLocal = await localDataSource.getProducts(
        limit: 100,
        offset: 0,
      );
      final freshFiltered = freshLocal
          .where((p) => p.supplierId == supplierId)
          .toList();

      if (freshFiltered.isEmpty) {
        debugPrint('🏢 [Repo] No products found for supplier $supplierId.');
        return Left(CacheFailure('No products found for this supplier.'));
      }
      debugPrint(
        '🏢 [Repo] Found ${freshFiltered.length} products for supplier $supplierId after fetch.',
      );
      return Right(freshFiltered.map((e) => e as Product).toList());
    } catch (e) {
      debugPrint('🏢 [Repo] Error in getProductsBySupplier: $e');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Supplier>>> getSuppliers({
    int limit = 20,
    int offset = 0,
    String? categoryId,
  }) async {
    try {
      final suppliers = await localDataSource.getSuppliers(
        limit: limit,
        offset: offset,
        categoryId: categoryId,
      );
      return Right(suppliers);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PromoCampaign>>> getPromotions({bool forceRefresh = false}) async {
    try {
      final localPromotions = await localDataSource.getPromotions();

      if (localPromotions.isNotEmpty && !forceRefresh) {
        // Fetch in background to keep cache warm
        _fetchAndCacheRemotePromotions().catchError((e) {
          debugPrint('🏢 [Repo] Background promo refresh failed: $e');
        });
        return Right(localPromotions);
      }

      final remotePromosOrFailure = await _fetchAndCacheRemotePromotions();
      
      return remotePromosOrFailure.fold(
        (failure) {
          if (localPromotions.isNotEmpty) {
            debugPrint('🏢 [Repo] Remote promo refresh failed, falling back to local cache.');
            return Right(localPromotions);
          }
          return Left(failure);
        },
        (promos) {
          if (promos.isEmpty && localPromotions.isNotEmpty) {
            debugPrint('🏢 [Repo] Remote promos returned empty. Retaining local cache data to prevent UI wipe.');
            return Right(localPromotions);
          }
          return Right(promos);
        },
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<PromoCampaign>>> _fetchAndCacheRemotePromotions() async {
    try {
      final remotePromotions = await remoteDataSource.getPromotions();
      if (remotePromotions.isNotEmpty) {
        await localDataSource.cachePromotions(remotePromotions);
      }
      return Right(remotePromotions.cast<PromoCampaign>());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
