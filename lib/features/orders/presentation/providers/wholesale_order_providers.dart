import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:node_app/features/orders/data/repositories/wholesale_order_repository_impl.dart';
import 'package:node_app/features/profile/domain/entities/order_status.dart';
import 'package:node_app/features/profile/domain/entities/wholesale_order.dart';
import 'package:node_app/core/error/failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fpdart/fpdart.dart';
import 'package:node_app/features/auth/domain/entities/business_profile.dart';

import 'package:node_app/core/database/database_provider.dart';

import 'package:node_app/features/home/presentation/pages/notifications/presentation/providers/notification_providers.dart';

import 'package:node_app/features/profile/presentation/providers/pdf_providers.dart';
import 'package:node_app/features/profile/domain/repositories/pdf_repository.dart';
import 'package:node_app/features/auth/presentation/providers/auth_state_provider.dart';

final wholesaleOrderRepositoryProvider = Provider<WholesaleOrderRepositoryImpl>(
  (ref) {
    return WholesaleOrderRepositoryImpl(
      Supabase.instance.client,
      ref.watch(databaseProvider),
      ref.watch(notificationRepositoryProvider),
    );
  },
);

/// 🆔 Reactive User ID Provider
final userIdProvider = Provider<String?>((ref) {
  final authState = ref.watch(authStateProvider).value;
  return authState?.session?.user.id ??
      Supabase.instance.client.auth.currentSession?.user.id;
});

final wholesaleOrdersProvider =
    StateNotifierProvider<
      WholesaleOrdersNotifier,
      AsyncValue<List<WholesaleOrder>>
    >((ref) {
      final userId = ref.watch(userIdProvider);
      return WholesaleOrdersNotifier(
        ref.watch(wholesaleOrderRepositoryProvider),
        ref.watch(pdfRepositoryProvider),
        userId,
      );
    });

/// 📦 Sent Orders Provider (Successfully Submitted)
final sentOrdersProvider =
    StateNotifierProvider<SentOrdersNotifier, AsyncValue<List<WholesaleOrder>>>(
      (ref) {
        final userId = ref.watch(userIdProvider);
        return SentOrdersNotifier(
          ref.watch(wholesaleOrderRepositoryProvider),
          userId,
        );
      },
    );

final pendingOrderForProductProvider = Provider.family<WholesaleOrder?, String>(
  (ref, productId) {
    final ordersAsync = ref.watch(wholesaleOrdersProvider);
    return ordersAsync.maybeWhen(
      data: (orders) => orders.cast<WholesaleOrder?>().firstWhere(
        (o) => o?.productId == productId && o?.status == OrderStatus.pending,
        orElse: () => null,
      ),
      orElse: () => null,
    );
  },
);

class WholesaleOrdersNotifier
    extends StateNotifier<AsyncValue<List<WholesaleOrder>>> {
  final WholesaleOrderRepositoryImpl _repository;
  final PdfRepository _pdfRepository;
  final String? _userId;

  WholesaleOrdersNotifier(this._repository, this._pdfRepository, this._userId)
    : super(const AsyncValue.loading()) {
    if (_userId != null) {
      fetchOrders(_userId);
    } else {
      state = const AsyncValue.data([]);
    }
  }

  Future<void> fetchOrders(String userId) async {
    state = const AsyncValue.loading();
    final result = await _repository.getOrders(userId);
    if (!mounted) return;
    result.fold(
      (failure) => state = AsyncValue.error(
        failure.toFriendlyMessage(),
        StackTrace.current,
      ),
      (orders) => state = AsyncValue.data(orders),
    );
  }

  Future<void> refresh() async {
    final userId = Supabase.instance.client.auth.currentSession?.user.id;
    if (userId != null) await fetchOrders(userId);
  }

  Future<Either<Failure, Unit>> saveOrder(WholesaleOrder order) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      return const Left(ServerFailure('Please sign in to save orders.'));
    }

    final result = await _repository.saveOrder(order, user.id);

    // Optimistically update local state on success
    if (result.isRight()) {
      final currentList = state.value ?? [];
      final updatedList = <WholesaleOrder>[
        order,
        ...currentList.where((o) => o.id != order.id),
      ];
      state = AsyncValue.data(updatedList);
    }

    return result;
  }

  Future<Either<Failure, Unit>> sendOrderToSupplier(
    WholesaleOrder order,
    BusinessProfile business,
  ) async {
    String? pdfUrl;

    // 📄 Fetch PDF URL if order has a linked PDF
    if (order.pdfId != null) {
      final pdfResult = await _pdfRepository.getPdfById(order.pdfId!);
      pdfUrl = pdfResult.fold((_) => null, (doc) => doc.fileUrl);
    }

    final result = await _repository.sendToSupplier(
      order: order,
      business: business,
      pdfUrl: pdfUrl,
    );

    if (result.isRight()) {
      // 🚀 Optimistic Status Update: Remove from this list immediately
      final currentList = state.value ?? [];
      state = AsyncValue.data(
        currentList.where((o) => o.id != order.id).toList(),
      );

      // 🔄 Refresh both providers so the order officially moves from Pending to Sent
      await refresh();
    }

    return result;
  }

  Future<Either<Failure, Unit>> cancelOrderSubmission(String orderId) async {
    final result = await _repository.cancelSubmission(orderId);

    if (result.isRight()) {
      await refresh();
    }

    return result;
  }

  Future<Either<Failure, Unit>> deleteOrder(String id) async {
    final result = await _repository.deleteOrder(id);

    if (result.isRight()) {
      final currentList = state.value ?? [];
      state = AsyncValue.data(currentList.where((o) => o.id != id).toList());
    }

    return result;
  }
}

class SentOrdersNotifier
    extends StateNotifier<AsyncValue<List<WholesaleOrder>>> {
  final WholesaleOrderRepositoryImpl _repository;
  final String? _userId;

  SentOrdersNotifier(this._repository, this._userId)
    : super(const AsyncValue.loading()) {
    if (_userId != null) {
      fetchSentOrders(_userId);
    } else {
      state = const AsyncValue.data([]);
    }
  }

  Future<void> fetchSentOrders(String userId) async {
    state = const AsyncValue.loading();
    final result = await _repository.getSentOrders(userId);
    result.fold(
      (failure) => state = AsyncValue.error(
        failure.toFriendlyMessage(),
        StackTrace.current,
      ),
      (orders) => state = AsyncValue.data(orders),
    );
  }

  Future<void> refresh() async {
    if (_userId != null) await fetchSentOrders(_userId);
  }
}
