import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/i_category_repository.dart';
import '../../data/datasources/category_local_data_source.dart';
import '../../data/datasources/category_remote_data_source.dart';
import '../../data/repositories/category_repository_impl.dart';
import '../../../home/presentation/pages/categories/models/category_model.dart';
import 'inventory_notifier.dart';

final categoryRemoteDataSourceProvider = Provider<ICategoryRemoteDataSource>((
  ref,
) {
  return CategoryRemoteDataSourceImpl(Supabase.instance.client);
});

final categoryLocalDataSourceProvider = Provider<ICategoryLocalDataSource>((
  ref,
) {
  final db = ref.watch(databaseProvider);
  return CategoryLocalDataSourceImpl(db);
});

final categoryRepositoryProvider = Provider<ICategoryRepository>((ref) {
  return CategoryRepositoryImpl(
    remoteDataSource: ref.watch(categoryRemoteDataSourceProvider),
    localDataSource: ref.watch(categoryLocalDataSourceProvider),
  );
});

class CategoryNotifier extends AsyncNotifier<List<CategoryItem>> {
  @override
  FutureOr<List<CategoryItem>> build() async {
    final repository = ref.read(categoryRepositoryProvider);

    // 1. Subscribe to the local Drift stream so any DB write (including
    //    background refreshes from Supabase) auto-rebuilds the UI.
    final sub = ref
        .read(categoryLocalDataSourceProvider)
        .watchCategories()
        .listen((localCategories) {
          if (localCategories.isNotEmpty) {
            state = AsyncValue.data(_buildTree(localCategories));
          }
        });
    ref.onDispose(sub.cancel);

    // 2. Fetch categories (cache-first) to populate the DB on first run.
    final result = await repository.getCategories();
    return result.fold(
      (failure) => throw failure.message,
      (categories) => _buildTree(categories),
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    final repository = ref.read(categoryRepositoryProvider);
    state = await AsyncValue.guard(() async {
      final result = await repository.getCategories(forceRefresh: true);
      return result.fold(
        (failure) => throw failure.message,
        (categories) => _buildTree(categories),
      );
    });
  }

  List<CategoryItem> _buildTree(
    List<ProductCategory> flatData, {
    String? parentId,
  }) {
    final filtered = flatData.where((c) => c.parentId == parentId).toList();

    // Sort by priority descending
    filtered.sort((a, b) => b.priority.compareTo(a.priority));

    return filtered
        .map(
          (c) => CategoryItem(
            id: c.id,
            name: c.name,
            imageUrl: c.imageUrl.isNotEmpty ? c.imageUrl : '',
            itemCount: c.itemCount,
            subCategories: _buildTree(flatData, parentId: c.id),
          ),
        )
        .toList();
  }
}

final categoryNotifierProvider =
    AsyncNotifierProvider<CategoryNotifier, List<CategoryItem>>(
      CategoryNotifier.new,
    );

final topCategoriesProvider = FutureProvider<List<ProductCategory>>((
  ref,
) async {
  final repository = ref.watch(categoryRepositoryProvider);
  final result = await repository.getTopCategories();

  return result.fold((failure) => [], (categories) => categories);
});
