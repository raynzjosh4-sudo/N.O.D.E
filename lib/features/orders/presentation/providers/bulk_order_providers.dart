import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node_app/core/database/app_database.dart';
import 'package:node_app/features/profile/domain/entities/saved_product.dart';
import '../../data/repositories/bulk_order_repository_impl.dart';
import '../../domain/repositories/bulk_order_repository.dart';
import '../../data/repositories/order_repository_impl.dart';
import '../../domain/repositories/order_repository.dart';
import '../../../auth/presentation/providers/user_providers.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../../../profile/domain/entities/wholesale_order.dart';
import '../../../profile/domain/entities/draft_order.dart';
import '../../../inventory/presentation/providers/inventory_notifier.dart';

final bulkOrderRepositoryProvider = Provider<BulkOrderRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return BulkOrderRepositoryImpl(database);
});

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final database = ref.watch(databaseProvider);
  return OrderRepositoryImpl(database);
});

final savedBulkOrdersProvider = FutureProvider<List<BulkOrderEntry>>((
  ref,
) async {
  final repository = ref.watch(bulkOrderRepositoryProvider);
  final result = await repository.getBulkOrders();
  return result.fold((failure) => [], (orders) => orders);
});

final userSavedItemsProvider = FutureProvider<List<SavedProduct>>((ref) async {
  // This would ideally fetch SavedProduct domain entities directly
  return [];
});

final userOrdersProvider = FutureProvider<List<WholesaleOrder>>((ref) async {
  final user = await ref.watch(userProfileProvider.future);
  if (user == null) return [];

  final repository = ref.watch(orderRepositoryProvider);
  final result = await repository.getOrders(user.id);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (orders) => orders,
  );
});

final userDraftsProvider = FutureProvider<List<DraftOrder>>((ref) async {
  final user = await ref.watch(userProfileProvider.future);
  if (user == null) return [];

  final repository = ref.watch(orderRepositoryProvider);
  final result = await repository.getDrafts(user.id);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (drafts) => drafts,
  );
});
