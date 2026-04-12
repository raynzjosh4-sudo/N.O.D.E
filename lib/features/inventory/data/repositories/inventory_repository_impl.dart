import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:node_app/features/home/data/product_dummy_data.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/i_inventory_repository.dart';
import '../datasources/inventory_local_data_source.dart';
import '../datasources/inventory_remote_data_source.dart';
import '../models/product_model.dart';
import 'package:node_app/features/home/data/product_dummy_data.dart';

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
    bool forceRefresh = false,
  }) async {
    try {
      final localProducts = await localDataSource.getProducts();

      // 🏗️ DEMO FALLBACK: If local is empty, use dummy data
      if (localProducts.isEmpty && !forceRefresh) {
        return Right<Failure, List<Product>>(
          List.from(ProductDummyData.products),
        );
      }

      // 👑 SMART SYNC: If we have local data and it's not a forced refresh, 
      // return it instantly but trigger a background fetch to keep things fresh.
      if (localProducts.isNotEmpty && !forceRefresh) {
        _refreshProductsInBackground();
        return Right<Failure, List<Product>>(localProducts.cast<Product>());
      }

      // If no local data or forced refresh, we wait for the remote data.
      return await _fetchAndCacheRemoteProducts();
    } catch (e) {
      // Fallback to local if remote fails during a forced refresh
      final localProducts = await localDataSource.getProducts();
      if (localProducts.isNotEmpty) {
        return Right<Failure, List<Product>>(localProducts.cast<Product>());
      }

      // Final fallback to dummy data if everything else fails
      return Right<Failure, List<Product>>(
        List.from(ProductDummyData.products),
      );
    }
  }

  void _refreshProductsInBackground() {
    _fetchAndCacheRemoteProducts()
        .then((_) {
          debugPrint('☁️ [R2/Supabase] Background sync complete.');
        })
        .catchError((e) {
          debugPrint('⚠️ [Sync] Background refresh failed: $e');
        });
  }

  Future<Either<Failure, List<Product>>> _fetchAndCacheRemoteProducts() async {
    final remoteProducts = await remoteDataSource.getProducts();
    await localDataSource.cacheProducts(remoteProducts);
    return Right<Failure, List<Product>>(remoteProducts.cast<Product>());
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
      await _fetchAndCacheRemoteProducts();
      final freshLocal = await localDataSource.getProducts();
      final freshFiltered = freshLocal
          .where((p) => p.supplierId == supplierId)
          .toList();

      return Right(freshFiltered.cast<Product>());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
