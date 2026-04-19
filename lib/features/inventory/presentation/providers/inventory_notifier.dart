import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/i_inventory_repository.dart';
import '../../data/datasources/inventory_local_data_source.dart';
import '../../data/datasources/inventory_remote_data_source.dart';
import '../../data/repositories/inventory_repository_impl.dart';
import '../../../home/presentation/providers/home_providers.dart';

// Providers for Data Sources and Repository
final databaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

final remoteDataSourceProvider = Provider<IInventoryRemoteDataSource>((ref) {
  return InventoryRemoteDataSourceImpl(Supabase.instance.client);
});

final localDataSourceProvider = Provider<IInventoryLocalDataSource>((ref) {
  final db = ref.watch(databaseProvider);
  return InventoryLocalDataSourceImpl(db);
});

final inventoryRepositoryProvider = Provider<IInventoryRepository>((ref) {
  return InventoryRepositoryImpl(
    remoteDataSource: ref.watch(remoteDataSourceProvider),
    localDataSource: ref.watch(localDataSourceProvider),
  );
});

// The Notifier for Product List
class InventoryNotifier extends AsyncNotifier<List<Product>> {
  int _currentOffset = 0;
  static const int _pageSize = 20;
  bool _hasReachedMax = false;

  @override
  FutureOr<List<Product>> build() async {
    final categoryId = ref.watch(selectedCategoryProvider);
    final searchQuery = ref.watch(inventorySearchQueryProvider);

    _currentOffset = 0;
    _hasReachedMax = false;

    // ⏲️ DEBOUNCE LOGIC (Simulated via ref.cacheFor or a manual delay if needed)
    // For build(), Riverpod handles the reactive rebuild.
    // To avoid rapid-fire builds during typing, we debounce the UI input.

    return _fetchProducts(
      offset: _currentOffset,
      categoryId: categoryId,
      searchQuery: searchQuery,
    );
  }

  Future<List<Product>> _fetchProducts({
    int offset = 0,
    String? categoryId,
    String? searchQuery,
    bool forceRefresh = false,
  }) async {
    final repository = ref.read(inventoryRepositoryProvider);
    final result = await repository.getProducts(
      limit: _pageSize,
      offset: offset,
      categoryId: categoryId,
      searchQuery: searchQuery,
      forceRefresh: forceRefresh,
    );

    return result.fold((failure) => throw failure.message, (products) {
      if (products.length < _pageSize) {
        _hasReachedMax = true;
      }
      return products;
    });
  }

  Future<void> loadMore() async {
    if (_hasReachedMax || state.isLoading || state.isRefreshing) return;

    final currentProducts = state.value ?? [];
    final categoryId = ref.read(selectedCategoryProvider);
    final searchQuery = ref.read(inventorySearchQueryProvider);
    _currentOffset += _pageSize;

    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final nextProducts = await _fetchProducts(
        offset: _currentOffset,
        categoryId: categoryId,
        searchQuery: searchQuery,
      );
      return [...currentProducts, ...nextProducts];
    });
  }

  Future<void> refresh() async {
    final categoryId = ref.read(selectedCategoryProvider);
    final searchQuery = ref.read(inventorySearchQueryProvider);
    _currentOffset = 0;
    _hasReachedMax = false;
    
    // We do NOT set state = AsyncValue.loading() here because RefreshIndicator 
    // provides its own UI spinner, and manually resetting state wipes the list
    // from the screen, causing a harsh flicker or empty blackout state.
    final result = await AsyncValue.guard(
      () => _fetchProducts(
        offset: 0,
        categoryId: categoryId,
        searchQuery: searchQuery,
        forceRefresh: true,
      ),
    );
    state = result;
  }

  Future<void> addProduct(Product product) async {
    final repository = ref.read(inventoryRepositoryProvider);
    final result = await repository.addProduct(product);

    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (newProduct) {
        state = AsyncValue.data([...state.value ?? [], newProduct]);
      },
    );
  }

  Future<void> deleteProduct(String id) async {
    final repository = ref.read(inventoryRepositoryProvider);
    final result = await repository.deleteProduct(id);

    result.fold(
      (failure) =>
          state = AsyncValue.error(failure.message, StackTrace.current),
      (_) {
        state = AsyncValue.data(
          (state.value ?? []).where((p) => p.id != id).toList(),
        );
      },
    );
  }
}

final inventoryNotifierProvider =
    AsyncNotifierProvider<InventoryNotifier, List<Product>>(
      InventoryNotifier.new,
    );

// Search/Filter Providers
class SearchQuery extends Notifier<String> {
  @override
  String build() => '';
  void set(String query) => state = query;
}

final inventorySearchQueryProvider = NotifierProvider<SearchQuery, String>(
  SearchQuery.new,
);

/// 🔍 Similar Products Provider
/// Fetches products from the same category, excluding the current product.
final similarProductsProvider =
    FutureProvider.family<List<Product>, ({String categoryId, String excludedProductId})>(
  (ref, params) async {
    final repository = ref.watch(inventoryRepositoryProvider);
    
    // Fetch products from the same category
    final result = await repository.getProducts(
      limit: 6, // Show a small subset for "Similar"
      offset: 0,
      categoryId: params.categoryId,
    );

    return result.fold(
      (failure) => [], // Return empty on failure to avoid UI crashes
      (products) {
        // Exclude the current product and limit to 5 actual items
        return products
            .where((p) => p.id != params.excludedProductId)
            .take(5)
            .toList();
      },
    );
  },
);
