import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node_app/features/saved_items/presentation/providers/saved_items_provider.dart';
import 'package:node_app/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:node_app/features/inventory/data/models/product_model.dart';
import 'package:node_app/features/profile/domain/entities/saved_product.dart';
import '../profile_tab_widgets.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/core/widgets/node_error_state.dart';

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

    // 🔒 AUTH CHECK: Ensure we have a user before fetching bag
    final authState = ref.watch(authStateProvider);
    final user = authState.value;

    if (user == null) {
      return ProfilePlaceholderView(
        title: 'Sign in to see your bag',
        subtitle: 'Your saved items will sync across all your devices.',
      );
    }

    // 💼 CLOUD SYNC: Watch the new persistent bag provider
    final savedItemsAsync = ref.watch(savedItemsProvider);

    return RefreshIndicator(
      onRefresh: () => ref.read(savedItemsProvider.notifier).refresh(),
      child: savedItemsAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: 500.h,
                child: ProfilePlaceholderView(
                  title: 'Your bag is empty',
                  subtitle: 'Items you save while browsing will appear here.',
                ),
              ),
            );
          }

          // Convert Cloud Entities (SavedItem) to UI Entities (SavedProduct)
          final savedProducts = items.map((item) {
            final product = ProductModel.fromJson(item.productSnapshot);
            return SavedProduct(
              id: item.id,
              product: product,
              quantity: item.quantity,
              selectedColor: item.selectedColor,
              selectedSize: item.selectedSize,
            );
          }).toList();

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

              // ── Cloud Product List ──────────────────────────────────────────
              Expanded(
                child: ProfileSavedProductList(
                  products: savedProducts,
                  selectedProductIds: _selectedIds,
                  onProductToggled: _toggleProduct,
                  onProductDeleted: (id) {
                    ref.read(savedItemsProvider.notifier).removeItem(id);
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => NodeErrorState(
          error: err,
          onRetry: () => ref.refresh(savedItemsProvider),
        ),
      ),
    );
  }
}
