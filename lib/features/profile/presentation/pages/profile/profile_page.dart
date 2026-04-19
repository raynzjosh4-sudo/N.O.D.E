import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node_app/core/database/app_database.dart';
import 'package:node_app/core/domain/entities/location.dart';
import 'package:node_app/features/profile/presentation/providers/profile_providers.dart';
import 'package:node_app/features/home/domain/entities/supplier.dart';
import 'package:node_app/features/inventory/domain/entities/price_tier.dart';
import 'package:node_app/features/inventory/domain/entities/product.dart';
import 'package:node_app/features/inventory/domain/entities/product_attributes.dart';
import 'package:node_app/features/inventory/domain/entities/trading_terms.dart';
import 'package:node_app/features/orders/presentation/providers/bulk_order_providers.dart';
import 'package:node_app/features/orders/presentation/providers/wholesale_order_providers.dart';
import 'package:node_app/features/profile/domain/entities/saved_product.dart';
import 'package:node_app/features/profile/domain/entities/wholesale_order.dart';
import 'package:node_app/features/profile/presentation/providers/pdf_providers.dart';
import 'package:node_app/features/saved_items/domain/entities/saved_item.dart';
import 'package:node_app/features/saved_items/presentation/providers/saved_items_provider.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/features/inventory/data/models/product_model.dart';
import 'package:node_app/features/profile/presentation/providers/profile_providers.dart'
    hide userProfileProvider;
import '../tabs/savedtab/saved_tab.dart';
import '../tabs/drafttab/drafts_tab.dart';
import '../tabs/ordertab/pending_orders_tab.dart';
import '../tabs/ordertab/sent_orders_tab.dart';
import '../tabs/ordertab/widgets/delete_confirmation_sheet.dart';
import '../tabs/pdftab/pdf_tab.dart';
import '../../../../showcase/presentation/services/node_toast_manager.dart';
import '../../../../showcase/presentation/widgets/node_toast.dart';
import '../tabs/settingstab/settings_tab.dart';
import '../../../../home/presentation/pages/specificationorderpage/widgets/multiorderpage/multi_product_order_page.dart';
import 'package:node_app/features/inventory/presentation/providers/inventory_notifier.dart';
import 'package:node_app/core/error/failure.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Converts a persisted BulkOrderEntry (from Drift DB) into a SavedProduct
// so MultiProductOrderPage can display and edit its configuration.
// ─────────────────────────────────────────────────────────────────────────────
SavedProduct _bulkEntryToSavedProduct(BulkOrderEntry entry) {
  // Decode color config from configJson: [{ colorName, hexCode, sizeQtys }]
  final List<dynamic> config = _safeJsonList(entry.configJson);

  // Build a fallback map of color names to hex codes from the actual configuration
  final Map<String, String> hexFallbackMap = {};
  for (final g in config) {
    if (g is Map<String, dynamic>) {
      final name = g['colorName'] as String?;
      final hex = g['hexCode'] as String?;
      if (name != null && hex != null) {
        hexFallbackMap[name.toLowerCase()] = hex.startsWith('#')
            ? hex
            : '#$hex';
      }
    }
  }

  // Decode available colors from stored rich JSON
  final List<dynamic> rawColors = _safeJsonList(entry.availableColorsJson);
  List<ProductColor> colors = rawColors.map<ProductColor>((c) {
    if (c is String) {
      // Recovery logic for legacy data
      final fallbackHex = hexFallbackMap[c.toLowerCase()];
      return ProductColor(name: c, hexCode: fallbackHex ?? '#808080');
    }
    final map = c as Map<String, dynamic>;
    final name = (map['name'] ?? map['colorName']) as String? ?? 'Default';
    final hex =
        (map['hexCode'] ?? map['hex']) as String? ??
        hexFallbackMap[name.toLowerCase()] ??
        '#808080';
    return ProductColor(name: name, hexCode: hex);
  }).toList();

  // If we have no available colors list, at least show the colors currently in the config
  if (colors.isEmpty && hexFallbackMap.isNotEmpty) {
    colors = hexFallbackMap.entries.map((e) {
      return ProductColor(name: e.key, hexCode: e.value);
    }).toList();
  }

  // Decode available sizes from stored rich JSON
  final List<dynamic> rawSizes = _safeJsonList(entry.availableSizesJson);
  final List<ProductSize> sizes = rawSizes.map<ProductSize>((s) {
    if (s is String) return ProductSize(name: s, abbreviation: s);
    final map = s as Map<String, dynamic>;
    return ProductSize(
      name: map['name'] as String? ?? '',
      abbreviation: map['abbreviation'] as String? ?? '',
    );
  }).toList();

  // Decode available materials from stored rich JSON
  final List<dynamic> rawMaterials = _safeJsonList(
    entry.availableMaterialsJson,
  );
  final List<ProductMaterial> materials = rawMaterials.map<ProductMaterial>((
    m,
  ) {
    if (m is String) return ProductMaterial(name: m);
    final map = m as Map<String, dynamic>;
    return ProductMaterial(
      name: map['name'] as String? ?? '',
      imageUrl: map['imageUrl'] as String?,
    );
  }).toList();

  // Pull first color + first size from config for the pre-selected state
  String? firstColor;
  String? firstSize;
  int firstQty = 1;
  if (config.isNotEmpty) {
    final firstGroup = config.first as Map<String, dynamic>;
    firstColor = firstGroup['colorName'] as String?;
    final sizeQtys = firstGroup['sizeQtys'];
    if (sizeQtys is Map && sizeQtys.isNotEmpty) {
      firstSize = sizeQtys.keys.first as String?;
      firstQty = (sizeQtys.values.first as num?)?.toInt() ?? 1;
    }
  }

  // Build a minimal shell Product — only fields required by MultiProductOrderPage
  const _emptySupplier = Supplier(
    id: '',
    name: '',
    imageUrl: '',
    category: '',
    location: Location(latitude: 0, longitude: 0, addressName: ''),
  );

  // Decode price tiers ["minQuantity", "price"]
  final List<dynamic> rawTiers = _safeJsonList(entry.priceTiersJson);
  final List<PriceTier> priceTiers = rawTiers.map((t) {
    final map = t as Map<String, dynamic>;
    return PriceTier(
      price: (map['price'] as num).toDouble(),
      minQuantity: (map['minQuantity'] as num).toInt(),
    );
  }).toList();

  // Decode trading terms
  TradingTerms tradingTerms = const TradingTerms(
    id: 'tt_saved',
    content: 'Standard trading terms apply for saved items.',
  );
  if (entry.tradingTermsJson != null && entry.tradingTermsJson!.isNotEmpty) {
    try {
      tradingTerms = TradingTerms.fromJson(jsonDecode(entry.tradingTermsJson!));
    } catch (_) {}
  }

  final product = Product(
    id: entry.id,
    sku: entry.id,
    name: entry.productName,
    brand: entry.brand ?? '',
    priceTiers: priceTiers,
    srp: entry.srp,
    hsCode: '',
    weightKg: 0,
    volumeCbm: 0,
    originCountry: '',
    unbsNumber: '',
    denier: '',
    material: '',
    supplier: _emptySupplier,
    categoryId: entry.category,
    currentStock: entry.currentStock,
    leadTimeDays: entry.leadTimeDays,
    warehouseLoc: '',
    seoTitle: '',
    seoDescription: entry.seoDescription ?? '',
    searchKeywords: const [],
    slug: entry.id,
    imageUrl: entry.imageUrl ?? '',
    availableColors: colors,
    availableSizes: sizes,
    availableMaterials: materials,
    variantLabel: entry.variantLabel,
    support: const ProductSupport(
      whatsapp: '+256 700 000 000',
      phone: '+256 000 000 000',
      email: 'support@node.app',
    ),
    tradingTerms: tradingTerms,
  );

  return SavedProduct(
    product: product,
    quantity: firstQty,
    selectedColor: firstColor,
    selectedSize: firstSize,
  );
}

List<dynamic> _safeJsonList(String? json) {
  if (json == null || json.isEmpty) return [];
  try {
    final decoded = jsonDecode(json);
    return decoded is List ? decoded : [];
  } catch (_) {
    return [];
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  // Removed merchantInventoryDummyData usage

  final ValueNotifier<Set<String>> _selectedSavedIds = ValueNotifier({});
  final ValueNotifier<Set<String>> _selectedOrderIds = ValueNotifier({});

  @override
  void dispose() {
    _selectedSavedIds.dispose();
    _selectedOrderIds.dispose();
    super.dispose();
  }

  /// Maps selected SavedItem IDs → SavedProduct list for MultiProductOrderPage.
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

    final allOrders = [
      ...pendingOrdersAsync.maybeWhen(
        data: (o) => o,
        orElse: () => <WholesaleOrder>[],
      ),
      ...sentOrdersAsync.maybeWhen(
        data: (o) => o,
        orElse: () => <WholesaleOrder>[],
      ),
    ];

    final orders = allOrders
        .where((order) => selectedIds.contains(order.id))
        .toList();

    if (orders.isEmpty) return;

    final hasPdfs = orders.any((o) => o.pdfId != null);

    final result = await NodeDeleteConfirmationSheet.show(
      context,
      orderCount: orders.length,
      hasPdfs: hasPdfs,
      itemCount: int.fromEnvironment(AutofillHints.birthdayYear),
    );

    if (result == null || !result.confirmDelete) return;

    final orderRepo = ref.read(wholesaleOrderRepositoryProvider);
    final pdfRepo = ref.read(pdfRepositoryProvider);

    int deletedOrders = 0;
    int deletedPdfs = 0;

    for (final order in orders) {
      // 1. Delete PDFs if requested
      if (result.deletePdfs && order.pdfId != null) {
        await pdfRepo.deletePdf(order.pdfId!);
        deletedPdfs++;
      }

      // 2. Delete Order
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
    final onSurface = theme.colorScheme.onSurface;

    // Real Inventory from Notifier
    final inventoryAsync = ref.watch(inventoryNotifierProvider);
    final merchantInventory = inventoryAsync.maybeWhen(
      data: (products) => products,
      orElse: () => <Product>[],
    );

    // Watch saved items from the persistent cloud bag
    final savedItemsAsync = ref.watch(savedItemsProvider);
    final allSavedEntries = savedItemsAsync.maybeWhen(
      data: (items) => items,
      orElse: () => <SavedItem>[],
    );

    // 👤 Profile & Business Data from Drift
    final userProfileAsync = ref.watch(userProfileProvider);
    final userBusinessAsync = ref.watch(userBusinessProvider);

    final userProfile = userProfileAsync.value;
    final userBusiness = userBusinessAsync.value;

    return DefaultTabController(
      length: 6,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top Header Bar ──────────────────────────────────────────
              Padding(
                padding: EdgeInsets.all(20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Avatar (Top Left)
                    Container(
                      width: 38.w,
                      height: 38.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.primaryColor,
                          width: 1.5.w,
                        ),
                        image: userProfile?.profilePicUrl != null
                            ? DecorationImage(
                                image: NetworkImage(
                                  userProfile!.profilePicUrl!,
                                ),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: userProfile?.profilePicUrl == null
                          ? Icon(
                              Icons.person_rounded,
                              size: 20.w,
                              color: onSurface.withOpacity(0.3),
                            )
                          : null,
                    ),

                    // Name (Top Center)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          userProfile?.fullName ?? 'Anonymous User',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          userBusiness?.legalName ?? 'Standard Account',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),

                    // Action Button (Top Right)
                    ListenableBuilder(
                      listenable: Listenable.merge([
                        _selectedSavedIds,
                        _selectedOrderIds,
                      ]),
                      builder: (context, _) {
                        final selectedSaved = _selectedSavedIds.value;
                        final selectedOrders = _selectedOrderIds.value;

                        final hasOrdersSelected = selectedOrders.isNotEmpty;
                        final hasSavedSelected = selectedSaved.isNotEmpty;

                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: hasOrdersSelected
                              ? GestureDetector(
                                  key: const ValueKey('delete_orders'),
                                  onTap: _handleOrderDeletion,
                                  child: Container(
                                    padding: EdgeInsets.all(8.w),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.delete_outline_rounded,
                                      size: 21.w,
                                      color: Colors.red,
                                    ),
                                  ),
                                )
                              : hasSavedSelected
                              ? GestureDetector(
                                  key: const ValueKey('checkout_saved'),
                                  onTap: () =>
                                      _startOrderFromSaved(allSavedEntries),
                                  child: Container(
                                    padding: EdgeInsets.all(8.w),
                                    decoration: BoxDecoration(
                                      color: theme.primaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.shopping_cart_checkout_rounded,
                                      size: 24.w,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : GestureDetector(
                                  key: const ValueKey('close_page'),
                                  onTap: () => context.pop(),
                                  child: Container(
                                    padding: EdgeInsets.all(8.w),
                                    decoration: BoxDecoration(
                                      color: onSurface.withOpacity(0.05),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.close_rounded,
                                      size: 24.w,
                                      color: onSurface,
                                    ),
                                  ),
                                ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              // ── Premium Top TabBar ───────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: SizedBox(
                  height: 28.h,
                  child: TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    padding: EdgeInsets.zero,
                    indicatorPadding: EdgeInsets.zero,
                    labelPadding: EdgeInsets.symmetric(horizontal: 12.w),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      color: theme.primaryColor,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    unselectedLabelColor: onSurface.withOpacity(0.4),
                    labelColor: Colors.white,
                    labelStyle: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    unselectedLabelStyle: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    dividerColor: Colors.transparent,
                    tabs: const [
                      Tab(text: 'Saved'),
                      Tab(text: 'Drafts'),
                      Tab(text: 'Pending'),
                      Tab(text: 'Sent'),
                      Tab(text: 'PDF'),
                      Tab(text: 'Settings'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12.h),

              // ── Tab View Content ─────────────────────────────────────────
              Expanded(
                child: TabBarView(
                  children: [
                    SavedTab(selectedIdsNotifier: _selectedSavedIds),
                    DraftsTab(),
                    PendingOrdersTab(selectedIdsNotifier: _selectedOrderIds),
                    SentOrdersTab(selectedIdsNotifier: _selectedOrderIds),
                    PdfTab(),
                    SettingsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
