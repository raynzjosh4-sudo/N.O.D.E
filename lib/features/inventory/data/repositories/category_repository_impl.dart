import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/i_category_repository.dart';
import '../datasources/category_local_data_source.dart';
import '../datasources/category_remote_data_source.dart';

class CategoryRepositoryImpl implements ICategoryRepository {
  final ICategoryRemoteDataSource remoteDataSource;
  final ICategoryLocalDataSource localDataSource;

  CategoryRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Stream<Either<Failure, List<ProductCategory>>> watchCategories() {
    return localDataSource.watchCategories().map(
      (models) => Right<Failure, List<ProductCategory>>(models),
    );
  }

  @override
  Future<Either<Failure, List<ProductCategory>>> getCategories({
    int limit = 100,
    int offset = 0,
    bool forceRefresh = false,
  }) async {
    try {
      final localCategories = await localDataSource.getCategories(
        limit: limit,
        offset: offset,
      );

      // Return cached if available, refresh in background
      if (localCategories.isNotEmpty && !forceRefresh) {
        _refreshCategoriesInBackground(limit: limit, offset: offset);
        return Right<Failure, List<ProductCategory>>(localCategories);
      }

      final remoteCategoriesOrFailure = await _fetchAndCacheRemoteCategories(limit: limit, offset: offset);
      return remoteCategoriesOrFailure.fold(
        (failure) {
          if (localCategories.isNotEmpty) {
            debugPrint('🏢 [CategoryRepo] Remote refresh failed, falling back to local cache.');
            return Right(localCategories);
          }
          return Left(failure);
        },
        (categories) {
          if (categories.isEmpty && localCategories.isNotEmpty) {
            debugPrint('🏢 [CategoryRepo] Remote categories returned empty. Retaining local cache data to prevent UI wipe.');
            return Right(localCategories);
          }
          return Right(categories);
        },
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  void _refreshCategoriesInBackground({
    required int limit,
    required int offset,
  }) {
    _fetchAndCacheRemoteCategories(limit: limit, offset: offset).catchError((
      e,
    ) {
      debugPrint('🏢 [CategoryRepo] Background refresh failed: $e');
    });
  }

  Future<Either<Failure, List<ProductCategory>>>
  _fetchAndCacheRemoteCategories({
    required int limit,
    required int offset,
  }) async {
    try {
      final remoteCategories = await remoteDataSource.getCategories(
        limit: limit,
        offset: offset,
      );

      if (remoteCategories.isNotEmpty) {
        await localDataSource.cacheCategories(remoteCategories);
      }

      return Right<Failure, List<ProductCategory>>(remoteCategories);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProductCategory>>> getTopCategories() async {
    try {
      final categories = await localDataSource.getTopCategories();
      return Right(categories);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> incrementCategoryUsage(String id) async {
    try {
      await localDataSource.incrementCategoryUsage(id);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
