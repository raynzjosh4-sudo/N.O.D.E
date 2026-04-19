import 'package:dartz/dartz.dart' hide Text;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:node_app/core/error/failure.dart';
import 'package:node_app/features/saved_items/data/repositories/saved_item_repository_impl.dart';
import 'package:node_app/features/saved_items/domain/entities/saved_item.dart';
import 'package:node_app/features/saved_items/domain/repositories/i_saved_item_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:node_app/features/inventory/domain/entities/product.dart';
import 'package:node_app/features/inventory/data/models/product_model.dart';
import 'package:uuid/uuid.dart';

final savedItemRepositoryProvider = Provider<ISavedItemRepository>((ref) {
  return SavedItemRepositoryImpl(Supabase.instance.client);
});

final savedItemsProvider =
    StateNotifierProvider<SavedItemsNotifier, AsyncValue<List<SavedItem>>>((
      ref,
    ) {
      return SavedItemsNotifier(ref.watch(savedItemRepositoryProvider));
    });

class SavedItemsNotifier extends StateNotifier<AsyncValue<List<SavedItem>>> {
  final ISavedItemRepository _repository;

  SavedItemsNotifier(this._repository) : super(const AsyncValue.loading()) {
    // 🚀 AUTO-INITIALIZE: Fetch items immediately if a user is available
    final userId = Supabase.instance.client.auth.currentSession?.user.id;
    if (userId != null) {
      fetchSavedItems(userId);
    } else {
      // If guest, we are effectively 'empty' not 'loading'
      state = const AsyncValue.data([]);
    }
  }

  Future<void> fetchSavedItems(String userId) async {
    // Avoid double-loading if we already have data (optional)
    // state = const AsyncValue.loading(); 
    
    final result = await _repository.getSavedItems(userId);
    if (!mounted) return;
    
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (items) => state = AsyncValue.data(items),
    );
  }

  Future<void> refresh() async {
    final userId = Supabase.instance.client.auth.currentSession?.user.id;
    if (userId != null) {
      await fetchSavedItems(userId);
    }
  }

  Future<Either<Failure, Unit>> saveItem({
    required Product product,
    int quantity = 1,
    String? color,
    String? size,
  }) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      return const Left(ServerFailure('Please sign in to save items.'));
    }

    // Create the snapshot from the Product entity
    final productModel = ProductModel.fromEntity(product);
    final snapshot = productModel.toJson();

    final item = SavedItem(
      id: const Uuid().v4(),
      userId: user.id,
      productId: product.id,
      quantity: quantity,
      selectedColor: color,
      selectedSize: size,
      productSnapshot: snapshot,
    );

    final result = await _repository.saveItem(item);

    // Refresh local list if successful
    if (result.isRight()) {
      fetchSavedItems(user.id);
    }

    return result;
  }

  Future<Either<Failure, Unit>> removeItem(String id) async {
    final result = await _repository.removeSavedItem(id);

    // Refresh local list if successful to reflect deletion
    if (result.isRight()) {
      final user = Supabase.instance.client.auth.currentSession?.user;
      if (user != null) {
        fetchSavedItems(user.id);
      }
    }

    return result;
  }
}
