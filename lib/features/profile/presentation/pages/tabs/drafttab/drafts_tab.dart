import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/core/widgets/node_error_state.dart';
import 'package:node_app/features/orders/presentation/providers/draft_order_providers.dart';
import 'widgets/draft_order_card.dart';

class DraftsTab extends ConsumerWidget {
  const DraftsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draftsAsync = ref.watch(draftOrdersProvider);
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return RefreshIndicator(
      onRefresh: () => ref.read(draftOrdersProvider.notifier).refresh(),
      child: draftsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => NodeErrorState(
          error: err,
          onRetry: () => ref.refresh(draftOrdersProvider),
        ),
        data: (drafts) {
          if (drafts.isEmpty) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(height: 500, child: _buildEmptyState(onSurface)),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: drafts.length,
            separatorBuilder: (context, _) =>
                Divider(height: 1.h, color: onSurface.withOpacity(0.05)),
            itemBuilder: (context, index) {
              final draft = drafts[index];
              return DraftOrderCard(draft: draft);
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(Color onSurface) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64.w,
            color: onSurface.withOpacity(0.1),
          ),
          SizedBox(height: 16.h),
          Text(
            'No Draft Orders',
            style: GoogleFonts.outfit(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: onSurface.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}
