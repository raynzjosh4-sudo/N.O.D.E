import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/features/home/data/repositories/search_history_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchHistoryView extends ConsumerWidget {
  final VoidCallback onCancel;
  final ValueChanged<String>? onSelect;

  const SearchHistoryView({super.key, required this.onCancel, this.onSelect});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final recentSearchesAsync = ref.watch(recentSearchesProvider);
    final repository = ref.read(searchHistoryRepositoryProvider);

    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Column(
        children: [
          // ── Header ─────────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Searches',
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: onSurface.withValues(alpha: 0.5),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    final userId =
                        Supabase.instance.client.auth.currentSession?.user.id ??
                        'guest';
                    repository.clearAll(userId);
                  },
                  child: Text(
                    'Clear all',
                    style: GoogleFonts.outfit(
                      fontSize: 12.sp,
                      color: theme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Search History List ────────────────────────────────────────
          Expanded(
            child: recentSearchesAsync.when(
              data: (searches) {
                if (searches.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 48.w,
                          color: onSurface.withValues(alpha: 0.1),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'No recent searches',
                          style: GoogleFonts.outfit(
                            fontSize: 15.sp,
                            color: onSurface.withValues(alpha: 0.3),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: searches.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1.h,
                    thickness: 1,
                    color: onSurface.withValues(alpha: 0.05),
                  ),
                  itemBuilder: (context, index) {
                    final entry = searches[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: onSurface.withValues(alpha: 0.05),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.history_rounded,
                          size: 16.w,
                          color: onSurface.withValues(alpha: 0.4),
                        ),
                      ),
                      title: Text(
                        entry.query,
                        style: GoogleFonts.outfit(
                          fontSize: 15.sp,
                          color: onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.close_rounded,
                          size: 18.w,
                          color: onSurface.withValues(alpha: 0.3),
                        ),
                        onPressed: () => repository.deleteSearch(entry.id),
                      ),
                      onTap: () => onSelect?.call(entry.query),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),

          // ── Back to Home Button ───────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: GestureDetector(
              onTap: onCancel,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: onSurface.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Text(
                  'Back to Explore',
                  style: GoogleFonts.outfit(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
