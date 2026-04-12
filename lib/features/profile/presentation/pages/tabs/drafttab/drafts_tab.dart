import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/features/orders/presentation/providers/bulk_order_providers.dart';
import 'package:node_app/features/profile/domain/entities/draft_order.dart';
import 'widgets/draft_order_card.dart';

class DraftsTab extends ConsumerWidget {
  const DraftsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draftsAsync = ref.watch(userDraftsProvider);
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return draftsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (drafts) {
        if (drafts.isEmpty) {
          return _buildEmptyState(onSurface);
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

