import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/i_inventory_repository.dart';
import '../../data/datasources/inventory_local_data_source.dart';
import '../../data/datasources/inventory_remote_data_source.dart';
import '../../data/repositories/inventory_repository_impl.dart';

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
  @override
  FutureOr<List<Product>> build() async {
    // 👑 REACTIVE BRAIN: We listen to the repository's stream.
    // This allows the UI to update "secretly" in the background 
    // when the Supabase sync finishes.
    final repository = ref.watch(inventoryRepositoryProvider);

    repository.watchProducts().listen((result) {
      result.fold(
        (failure) => state = AsyncValue.error(failure.message, StackTrace.current),
        (products) => state = AsyncValue.data(products),
      );
    });

    return _fetchProducts();
  }

  Future<List<Product>> _fetchProducts({bool forceRefresh = false}) async {
    final repository = ref.read(inventoryRepositoryProvider);
    final result = await repository.getProducts(forceRefresh: forceRefresh);
    
    return result.fold(
      (failure) => throw failure.message,
      (products) => products,
    );
  }

  Future<void> refresh() async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchProducts(forceRefresh: true));
  }

  Future<void> addProduct(Product product) async {
    final repository = ref.read(inventoryRepositoryProvider);
    final result = await repository.addProduct(product);
    
    result.fold(
      (failure) => state = AsyncValue.error(failure.message, StackTrace.current),
      (newProduct) {
        state = AsyncValue.data([...state.value ?? [], newProduct]);
      },
    );
  }

  Future<void> deleteProduct(String id) async {
    final repository = ref.read(inventoryRepositoryProvider);
    final result = await repository.deleteProduct(id);
    
    result.fold(
      (failure) => state = AsyncValue.error(failure.message, StackTrace.current),
      (_) {
        state = AsyncValue.data(
          (state.value ?? []).where((p) => p.id != id).toList(),
        );
      },
    );
  }
}

final inventoryNotifierProvider =
    AsyncNotifierProvider<InventoryNotifier, List<Product>>(InventoryNotifier.new);
    
// Search/Filter Providers
class SearchQuery extends Notifier<String> {
  @override
  String build() => '';
  void set(String query) => state = query;
}

final inventorySearchQueryProvider = NotifierProvider<SearchQuery, String>(SearchQuery.new);

final filteredInventoryProvider = Provider<List<Product>>((ref) {
  final products = ref.watch(inventoryNotifierProvider).value ?? [];
  final query = ref.watch(inventorySearchQueryProvider).toLowerCase();
  
  if (query.isEmpty) return products;
  
  return products.where((p) {
    return p.name.toLowerCase().contains(query) || 
           p.sku.toLowerCase().contains(query) ||
           p.brand.toLowerCase().contains(query);
  }).toList();
});
