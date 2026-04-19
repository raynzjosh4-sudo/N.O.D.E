import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:node_app/core/error/failure.dart';
import 'package:node_app/features/orders/data/repositories/draft_order_repository_impl.dart';
import 'package:node_app/features/profile/domain/entities/draft_order.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fpdart/fpdart.dart';

// ── Repository Provider ──────────────────────────────────────────────────────

final draftOrderRepositoryProvider = Provider<DraftOrderRepositoryImpl>((ref) {
  return DraftOrderRepositoryImpl(Supabase.instance.client);
});

// ── Notifier ─────────────────────────────────────────────────────────────────

final draftOrdersProvider =
    StateNotifierProvider<DraftOrdersNotifier, AsyncValue<List<DraftOrder>>>(
      (ref) => DraftOrdersNotifier(ref.watch(draftOrderRepositoryProvider)),
    );

class DraftOrdersNotifier extends StateNotifier<AsyncValue<List<DraftOrder>>> {
  final DraftOrderRepositoryImpl _repository;

  DraftOrdersNotifier(this._repository) : super(const AsyncValue.loading()) {
    // 🚀 Auto-initialize: fetch immediately when a user session exists
    final userId = Supabase.instance.client.auth.currentSession?.user.id;
    if (userId != null) {
      fetchDrafts(userId);
    } else {
      state = const AsyncValue.data([]);
    }
  }

  Future<void> fetchDrafts(String userId) async {
    final result = await _repository.getDrafts(userId);
    if (!mounted) return;
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (drafts) => state = AsyncValue.data(drafts),
    );
  }

  Future<void> refresh() async {
    final userId = Supabase.instance.client.auth.currentSession?.user.id;
    if (userId != null) await fetchDrafts(userId);
  }

  Future<Either<Failure, Unit>> saveDraft(DraftOrder draft) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      return const Left(ServerFailure('Please sign in to save drafts.'));
    }

    final result = await _repository.saveDraft(draft, user.id);

    // Optimistically update local state on success
    if (result.isRight()) {
      final currentList = state.value ?? [];
      final updatedList = <DraftOrder>[
        draft,
        ...currentList.where((d) => d.id != draft.id),
      ];
      state = AsyncValue.data(updatedList);
    }

    return result;
  }

  Future<Either<Failure, Unit>> deleteDraft(String id) async {
    final result = await _repository.deleteDraft(id);

    if (result.isRight()) {
      final currentList = state.value ?? [];
      state = AsyncValue.data(currentList.where((d) => d.id != id).toList());
    }

    return result;
  }
}
