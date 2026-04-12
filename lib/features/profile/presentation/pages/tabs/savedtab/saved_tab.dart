import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node_app/features/orders/presentation/providers/bulk_order_providers.dart';
import 'package:node_app/features/showcase/presentation/services/node_toast_manager.dart';
import 'package:node_app/features/showcase/presentation/widgets/node_toast.dart';
import '../profile_tab_widgets.dart';
import 'package:node_app/core/utils/responsive_size.dart';

class SavedTab extends ConsumerStatefulWidget {
  final ValueNotifier<Set<String>> selectedIdsNotifier;

  SavedTab({super.key, required this.selectedIdsNotifier});

  @override
  ConsumerState<SavedTab> createState() => _SavedTabState();
}

class _SavedTabState extends ConsumerState<SavedTab> {
  Set<String> get _selectedIds => widget.selectedIdsNotifier.value;

  void _toggleProduct(String id) {
    setState(() {
      final newSelected = Set<String>.from(_selectedIds);
      if (newSelected.contains(id)) {
        newSelected.remove(id);
      } else {
        newSelected.add(id);
      }
      widget.selectedIdsNotifier.value = newSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final primary = theme.primaryColor;
    final hasSelection = _selectedIds.isNotEmpty;

    final savedOrdersAsync = ref.watch(savedBulkOrdersProvider);

    return savedOrdersAsync.when(
      data: (savedItems) {
        if (savedItems.isEmpty) {
          return ProfilePlaceholderView(title: 'No saved items yet');
        }

        return Column(
          children: [
            // ── Selection Banner ──────────────────────────────────────────────
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: hasSelection ? null : 0,
              decoration: const BoxDecoration(),
              clipBehavior: Clip.antiAlias,
              child: hasSelection
                  ? Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.08),
                        border: Border(
                          bottom: BorderSide(
                            color: primary.withOpacity(0.15),
                            width: 1.w,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: primary,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Text(
                              '${_selectedIds.length} selected',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              'Tap the Order button above to place your bulk order',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: primary.withOpacity(0.7),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                widget.selectedIdsNotifier.value = {};
                              });
                            },
                            child: Icon(
                              Icons.close_rounded,
                              size: 16.w,
                              color: onSurface.withOpacity(0.4),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),

            // ── Product List ──────────────────────────────────────────────────
            Expanded(
              child: ProfileSavedBulkOrderList(
                orders: savedItems,
                selectedOrderIds: _selectedIds,
                onOrderToggled: _toggleProduct,
                onDelete: (id) async {
                  final result = await ref
                      .read(bulkOrderRepositoryProvider)
                      .deleteBulkOrder(id);
                  result.fold(
                    (failure) {
                      if (context.mounted) {
                        NodeToastManager.show(
                          context,
                          title: 'Action Error',
                          message: 'Delete failed: ${failure.message}',
                          status: NodeToastStatus.error,
                        );
                      }
                    },
                    (_) {
                      ref.invalidate(savedBulkOrdersProvider);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
