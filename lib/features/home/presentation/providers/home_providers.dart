import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:node_app/features/home/domain/entities/promo_campaign.dart';
import 'package:node_app/features/inventory/domain/entities/product.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/repositories/home_repository.dart';
import 'package:node_app/features/inventory/presentation/providers/inventory_notifier.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  final inventoryRepo = ref.watch(inventoryRepositoryProvider);
  return HomeRepositoryImpl(inventoryRepo);
});

final selectedCategoryProvider = StateProvider<String?>((ref) => null);

final popularProductsProvider = FutureProvider.family<List<Product>, String?>((
  ref,
  categoryId,
) async {
  final repo = ref.watch(homeRepositoryProvider);
  final res = await repo.getExploreProducts(
    page: 0,
    pageSize: 15,
    category: categoryId,
  );
  return res.fold((l) => [], (r) => r);
});

final activePromotionsProvider = FutureProvider<List<PromoCampaign>>((
  ref,
) async {
  final repo = ref.watch(homeRepositoryProvider);
  final res = await repo.getPromotions();
  return res.fold((l) => [], (r) => r);
});
