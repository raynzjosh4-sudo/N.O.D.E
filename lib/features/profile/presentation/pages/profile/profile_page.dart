import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node_app/features/profile/presentation/providers/profile_providers.dart';
import 'package:node_app/features/orders/presentation/providers/wholesale_order_providers.dart';
import 'package:node_app/features/profile/domain/entities/wholesale_order.dart';
import 'package:node_app/features/profile/presentation/providers/pdf_providers.dart';
import 'package:node_app/features/records/presentation/records/pages/edit_record_page.dart';
import 'package:node_app/features/records/data/models/main_record_model.dart';
import 'package:node_app/features/records/data/models/record_detail_model.dart';
import 'package:node_app/features/records/domain/types/record_types.dart';
import 'package:node_app/features/saved_items/domain/entities/saved_item.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/features/inventory/data/models/product_model.dart';
import 'package:node_app/features/profile/domain/entities/saved_product.dart';
import 'package:node_app/features/saved_items/presentation/providers/saved_items_provider.dart';
import '../tabs/savedtab/saved_tab.dart';
import '../tabs/drafttab/drafts_tab.dart';
import '../tabs/ordertab/pending_orders_tab.dart';
import '../tabs/ordertab/sent_orders_tab.dart';
import '../tabs/ordertab/widgets/delete_confirmation_sheet.dart';
import '../tabs/pdftab/pdf_tab.dart';
import '../../../../records/presentation/records/pages/records_tab.dart';
import '../../../../showcase/presentation/services/node_toast_manager.dart';
import '../../../../showcase/presentation/widgets/node_toast.dart';
import '../tabs/settingstab/settings_tab.dart';
import '../../../../home/presentation/pages/specificationorderpage/widgets/multiorderpage/multi_product_order_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/features/records/presentation/providers/records_provider.dart';
import 'package:uuid/uuid.dart';

// Subpages
import 'subpages/profile_header.dart';
import 'subpages/profile_tabs.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final ValueNotifier<Set<String>> _selectedSavedIds = ValueNotifier({});
  final ValueNotifier<Set<String>> _selectedOrderIds = ValueNotifier({});

  @override
  void dispose() {
    _selectedSavedIds.dispose();
    _selectedOrderIds.dispose();
    super.dispose();
  }

  void _startOrderFromSaved(List<SavedItem> allSavedItems) {
    final selected = _selectedSavedIds.value;
    final selectedItems = allSavedItems
        .where((e) => selected.contains(e.productId))
        .toList();

    if (selectedItems.isEmpty) return;

    final products = selectedItems.map((item) {
      final product = ProductModel.fromJson(item.productSnapshot);
      return SavedProduct(
        product: product,
        quantity: item.quantity,
        selectedColor: item.selectedColor,
        selectedSize: item.selectedSize,
      );
    }).toList();

    MultiProductOrderPage.show(context, products);
  }

  Future<void> _handleOrderDeletion() async {
    final selectedIds = _selectedOrderIds.value;
    if (selectedIds.isEmpty) return;

    final pendingOrdersAsync = ref.read(wholesaleOrdersProvider);
    final sentOrdersAsync = ref.read(sentOrdersProvider);

    final allOrders = [...pendingOrdersAsync.items, ...sentOrdersAsync.items];

    final orders = allOrders
        .where((order) => selectedIds.contains(order.id))
        .toList();

    if (orders.isEmpty) return;

    final hasPdfs = orders.any((o) => o.pdfId != null);

    final result = await NodeDeleteConfirmationSheet.show(
      context,
      orderCount: orders.length,
      hasPdfs: hasPdfs,
      itemCount: 0, // Placeholder
    );

    if (result == null || !result.confirmDelete) return;

    final orderRepo = ref.read(wholesaleOrderRepositoryProvider);
    final pdfRepo = ref.read(pdfRepositoryProvider);

    int deletedOrders = 0;
    int deletedPdfs = 0;

    for (final order in orders) {
      if (result.deletePdfs && order.pdfId != null) {
        await pdfRepo.deletePdf(order.pdfId!);
        deletedPdfs++;
      }

      final deleteResult = await orderRepo.deleteOrder(order.id);
      deleteResult.fold((failure) {
        if (mounted) {
          NodeToastManager.show(
            context,
            title: 'Registry Error',
            message: failure.toFriendlyMessage(),
            status: NodeToastStatus.error,
          );
        }
      }, (_) => deletedOrders++);
    }

    if (mounted) {
      _selectedOrderIds.value = {};
      ref.invalidate(wholesaleOrdersProvider);
      ref.invalidate(sentOrdersProvider);
      ref.invalidate(userPdfsProvider);

      NodeToastManager.show(
        context,
        title: 'Registry Updated',
        message: deletedPdfs > 0
            ? 'Removed $deletedOrders orders and cleared $deletedPdfs PDF manifests.'
            : 'Successfully removed $deletedOrders orders from your registry.',
        status: NodeToastStatus.success,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userProfile = ref.watch(userProfileProvider).value;
    final userBusiness = ref.watch(userBusinessProvider).value;

    return DefaultTabController(
      length: 7,
      child: Builder(
        builder: (context) {
          final tabController = DefaultTabController.of(context);

          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            body: SafeArea(
              child: Stack(
                children: [
                  // ── BASE LAYER: Profile Header & Navigation ────────────────
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListenableBuilder(
                        listenable: Listenable.merge([
                          tabController,
                          _selectedSavedIds,
                          _selectedOrderIds,
                        ]),
                        builder: (context, _) {
                          IconData? actionIcon;
                          VoidCallback? onActionTap;

                          final index = tabController.index;
                          final hasSavedSelection =
                              _selectedSavedIds.value.isNotEmpty;
                          final hasOrderSelection =
                              _selectedOrderIds.value.isNotEmpty;

                          if (index == 1 && hasSavedSelection) {
                            actionIcon = Icons.shopping_bag_rounded;
                            onActionTap = () => _startOrderFromSaved(
                              ref.read(savedItemsProvider).value ?? [],
                            );
                          } else if ((index == 3 || index == 4) &&
                              hasOrderSelection) {
                            actionIcon = Icons.delete_outline_rounded;
                            onActionTap = _handleOrderDeletion;
                          }

                          return ProfileHeader(
                            profilePicUrl: userProfile?.profilePicUrl,
                            fullName: userProfile?.fullName ?? 'Anonymous User',
                            legalName:
                                userBusiness?.legalName ?? 'Standard Account',
                            actionIcon: actionIcon,
                            onActionTap: onActionTap,
                          );
                        },
                      ),
                      const ProfileTabBar(),
                      SizedBox(height: 12.h),

                      // Tab View Content
                      Expanded(
                        child: TabBarView(
                          children: [
                            // 🌌 Records Dashboard (Background content for Index 0)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    20.w,
                                    40.h,
                                    20.w,
                                    0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        () {
                                          final hour = DateTime.now().hour;
                                          if (hour < 12) return 'GOOD MORNING,';
                                          if (hour < 17)
                                            return 'GOOD AFTERNOON,';
                                          return 'GOOD EVENING,';
                                        }(),
                                        style: GoogleFonts.outfit(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w900,
                                          color: theme.colorScheme.primary,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                      Text(
                                        (userProfile?.fullName ??
                                                'Anonymous User')
                                            .toUpperCase(),
                                        style: GoogleFonts.outfit(
                                          fontSize: 32.sp,
                                          fontWeight: FontWeight.w900,
                                          height: 1.1,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: Consumer(
                                              builder: (context, ref, _) {
                                                final rCount = ref
                                                    .watch(recordsProvider)
                                                    .items
                                                    .length;
                                                return Text(
                                                  'You are currently tracking\n$rCount active records.',
                                                  style:
                                                      GoogleFonts.plusJakartaSans(
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: theme
                                                            .colorScheme
                                                            .onSurface
                                                            .withOpacity(0.4),
                                                        height: 1.5,
                                                      ),
                                                );
                                              },
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () => EditRecordPage.show(
                                              context,
                                              MainRecordModel(
                                                id: const Uuid().v4(),
                                                updatedAt: DateTime.now(),
                                                records: [],
                                                detail: RecordDetailModel(
                                                  contactName: '',
                                                  itemName: '',
                                                  type: RecordType.standard,
                                                ),
                                              ),
                                              isNew: true,
                                            ),
                                            child: Container(
                                              width: 56.w,
                                              height: 56.w,
                                              margin: EdgeInsets.only(
                                                bottom: 4.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color:
                                                    theme.colorScheme.primary,
                                                borderRadius:
                                                    BorderRadius.circular(16.r),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: theme
                                                        .colorScheme
                                                        .primary
                                                        .withOpacity(0.3),
                                                    blurRadius: 15,
                                                    offset: const Offset(0, 8),
                                                  ),
                                                ],
                                              ),
                                              child: Icon(
                                                Icons.add_rounded,
                                                color: Colors.black,
                                                size: 28.w,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SavedTab(selectedIdsNotifier: _selectedSavedIds),
                            DraftsTab(),
                            PendingOrdersTab(
                              selectedIdsNotifier: _selectedOrderIds,
                            ),
                            SentOrdersTab(
                              selectedIdsNotifier: _selectedOrderIds,
                            ),
                            PdfTab(),
                            SettingsTab(),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // ── OVERLAY LAYER: Immersive Records View ──────────────────
                  ListenableBuilder(
                    listenable: tabController,
                    builder: (context, _) {
                      if (tabController.index != 0)
                        return const SizedBox.shrink();
                      return const RecordsTab();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
