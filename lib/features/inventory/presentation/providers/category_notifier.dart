import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
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

class CategoryState {
  final List<CategoryItem> items;
  final bool isLoading;
  final bool hasMore;
  final String? parentId;

  CategoryState({
    required this.items,
    this.isLoading = false,
    this.hasMore = true,
    this.parentId,
  });

  CategoryState copyWith({
    List<CategoryItem>? items,
    bool? isLoading,
    bool? hasMore,
    String? parentId,
  }) {
    return CategoryState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      parentId: parentId ?? this.parentId,
    );
  }
}

class CategoryPaginatedNotifier extends StateNotifier<CategoryState> {
  final ICategoryRepository _repository;
  final String? parentId;
  static const int _pageSize = 20;

  CategoryPaginatedNotifier(this._repository, this.parentId)
    : super(CategoryState(items: [], parentId: parentId)) {
    fetch();
  }

  Future<void> fetch({bool isRefresh = false}) async {
    if (isRefresh) {
      state = state.copyWith(items: [], isLoading: true, hasMore: true);
    } else {
      state = state.copyWith(isLoading: true);
    }

    final result = await _repository.getCategories(
      parentId: parentId,
      limit: _pageSize,
      offset: 0,
      forceRefresh: isRefresh,
    );

    result.fold(
      (failure) => state = state.copyWith(isLoading: false, hasMore: false),
      (categories) {
        state = state.copyWith(
          items: categories.map((c) => _mapToItem(c)).toList(),
          isLoading: false,
          hasMore: categories.length >= _pageSize,
        );
      },
    );
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);
    final currentOffset = state.items.length;

    final result = await _repository.getCategories(
      parentId: parentId,
      limit: _pageSize,
      offset: currentOffset,
    );

    result.fold(
      (failure) => state = state.copyWith(isLoading: false, hasMore: false),
      (categories) {
        state = state.copyWith(
          items: [...state.items, ...categories.map((c) => _mapToItem(c))],
          isLoading: false,
          hasMore: categories.length >= _pageSize,
        );
      },
    );
  }

  CategoryItem _mapToItem(ProductCategory c) {
    return CategoryItem(
      id: c.id,
      name: c.name,
      imageUrl: c.imageUrl,
      itemCount: c.itemCount,
      subCategories: [], // Subcategories are loaded on-demand now
    );
  }
}

final categoryPaginatedProvider =
    StateNotifierProvider.family<CategoryPaginatedNotifier, CategoryState, String?>((
  ref,
  parentId,
) {
  return CategoryPaginatedNotifier(
    ref.watch(categoryRepositoryProvider),
    parentId,
  );
});

// Legacy support for parts of the app that expect a simple list of top categories
final categoryNotifierProvider = Provider<AsyncValue<List<CategoryItem>>>((ref) {
  final state = ref.watch(categoryPaginatedProvider(null));
  if (state.isLoading && state.items.isEmpty) return const AsyncValue.loading();
  return AsyncValue.data(state.items);
});

final topCategoriesProvider = FutureProvider<List<ProductCategory>>((
  ref,
) async {
  final repository = ref.watch(categoryRepositoryProvider);
  final result = await repository.getTopCategories();
  return result.fold((failure) => [], (categories) => categories);
});
