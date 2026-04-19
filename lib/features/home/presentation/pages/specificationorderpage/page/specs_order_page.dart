import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/core/domain/entities/location.dart';
import 'package:node_app/core/pdf/order_pdf_service.dart';
import 'package:node_app/features/inventory/domain/entities/trading_terms.dart';
import 'package:node_app/features/profile/domain/entities/draft_order.dart';
import 'package:node_app/features/profile/presentation/providers/pdf_providers.dart';
import '../../../../../orders/presentation/providers/bulk_order_providers.dart';
import '../../../../../orders/presentation/providers/draft_order_providers.dart';
import '../../../../../orders/presentation/providers/wholesale_order_providers.dart';
import '../order_models.dart';
import '../widgets/order_group_builder.dart';
import '../widgets/order_summary_table.dart';
import '../widgets/saved_item_picker.dart';
import '../widgets/order_confirmation_sheet.dart';
import '../widgets/pdf_naming_sheet.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/features/profile/presentation/pages/tabs/settingstab/pages/profile_info_page.dart';
import 'package:node_app/features/profile/presentation/providers/profile_providers.dart';
import 'package:node_app/features/profile/domain/entities/wholesale_order.dart';
import 'package:node_app/features/auth/data/models/business_model.dart';
import 'package:node_app/features/profile/domain/entities/order_status.dart';
import 'package:node_app/features/profile/domain/entities/saved_product.dart';
import 'package:node_app/features/inventory/domain/entities/product.dart';
import 'package:node_app/features/home/domain/entities/supplier.dart';
import 'package:node_app/features/inventory/domain/entities/product_attributes.dart';
import 'package:uuid/uuid.dart';
import 'package:node_app/core/utils/color_utils.dart';
import '../../../../../showcase/presentation/services/node_toast_manager.dart';
import '../../../../../showcase/presentation/widgets/node_toast.dart';
import '../widgets/specs_order_header.dart';
import '../widgets/specs_order_summary_header.dart';
import '../widgets/specs_confirmed_groups_list.dart';
import '../widgets/specs_order_actions.dart';
import 'package:node_app/features/saved_items/presentation/providers/saved_items_provider.dart';
import 'package:node_app/core/services/notification_service.dart';
import 'package:node_app/core/error/failure.dart';

class SpecsOrderSheet extends ConsumerStatefulWidget {
  final String productName;
  final String brand;
  final String category;
  final String subCategory;
  final String? imageUrl;
  final List<ColorVariant> availableColors;
  final List<String> availableSizes;
  final String variantLabel;
  final Product? product;

  const SpecsOrderSheet({
    super.key,
    required this.productName,
    required this.brand,
    required this.category,
    required this.subCategory,
    this.imageUrl,
    required this.availableColors,
    required this.availableSizes,
    this.variantLabel = 'Size',
    this.product,
  });

  static Future<List<ColorGroup>?> show(
    BuildContext context, {
    required String productName,
    required String brand,
    required String category,
    required String subCategory,
    String? imageUrl,
    required List<Map<String, dynamic>> availableColors,
    required List<String> availableSizes,
    String variantLabel = 'Size',
    Product? product,
  }) {
    return Navigator.of(context).push<List<ColorGroup>?>(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, __, ___) => SpecsOrderSheet(
          productName: productName,
          brand: brand,
          category: category,
          subCategory: subCategory,
          imageUrl: imageUrl,
          availableColors: availableColors
              .map(
                (c) => ColorVariant(
                  label: c['label'] as String,
                  color: c['color'] as Color,
                ),
              )
              .toList(),
          availableSizes: availableSizes,
          variantLabel: variantLabel,
          product: product,
        ),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                .animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                ),
            child: child,
          );
        },
      ),
    );
  }

  @override
  ConsumerState<SpecsOrderSheet> createState() => _SpecsOrderSheetState();
}

class _SpecsOrderSheetState extends ConsumerState<SpecsOrderSheet> {
  final List<ColorGroup> _confirmedGroups = [];
  ColorGroup? _editingGroup;
  final _bulkNameController = TextEditingController();
  bool _isNamingBulk = false;

  List<String> get _usedColors =>
      _confirmedGroups.map((g) => g.color.label).toList();

  int get _totalUnits => _confirmedGroups.fold(
    0,
    (sum, g) => sum + g.sizeQtys.values.fold(0, (s, q) => s + q),
  );

  @override
  void dispose() {
    _bulkNameController.dispose();
    super.dispose();
  }

  /// Saves the current configuration as a Bulk Order (Draft Template).
  /// This skips the PDF generation and just persists the structured data.
  Future<void> _saveAsBulkDraft() async {
    if (_confirmedGroups.isEmpty) return;

    final name = _bulkNameController.text.trim();
    if (name.isEmpty) {
      NodeToastManager.show(
        context,
        title: 'Selection Needed',
        message: 'Name this bulk configuration to save it.',
        status: NodeToastStatus.warning,
      );
      return;
    }

    final user = await ref.read(userProfileProvider.future);
    if (user == null) {
      if (!mounted) return;
      NodeToastManager.show(
        context,
        title: 'Profile Error',
        message: 'Cannot save draft without active user session.',
        status: NodeToastStatus.error,
      );
      return;
    }

    final dummyProduct = Product(
      id: widget.product?.id ?? const Uuid().v4(),
      sku:
          widget.product?.sku ??
          'DRAFT-${DateTime.now().millisecondsSinceEpoch}',
      name: widget.productName,
      brand: widget.brand,
      imageUrl: widget.imageUrl ?? '',
      priceTiers: widget.product?.priceTiers ?? const [],
      srp: widget.product?.srp ?? 0,
      hsCode: '',
      weightKg: 0,
      volumeCbm: 0,
      originCountry: '',
      unbsNumber: '',
      denier: '',
      material: '',
      supplier: const Supplier(
        id: '',
        name: '',
        imageUrl: '',
        category: '',
        location: Location(latitude: 0, longitude: 0, addressName: ''),
      ),
      categoryId: widget.category,
      currentStock: widget.product?.currentStock ?? 0,
      leadTimeDays: widget.product?.leadTimeDays ?? 0,
      warehouseLoc: '',
      seoTitle: '',
      seoDescription: widget.product?.seoDescription ?? '',
      searchKeywords: const [],
      slug: '',
      support: const ProductSupport(whatsapp: '', phone: '', email: ''),
      tradingTerms:
          widget.product?.tradingTerms ??
          const TradingTerms(id: '', content: ''),
    );

    final savedProduct = SavedProduct(
      product: dummyProduct,
      quantity: _totalUnits,
    );

    final orderEntry = ProductOrderEntry(
      savedProduct: savedProduct,
      confirmedGroups: _confirmedGroups
          .map(
            (g) => ColorGroup(color: g.color, sizeQtys: Map.from(g.sizeQtys)),
          )
          .toList(),
    );

    final draftOrder = DraftOrder(
      id: const Uuid().v4(), // UUID required by Supabase — name shown in toast
      entries: [orderEntry],
      lastModified: DateTime.now(),
    );

    final result = await ref
        .read(draftOrdersProvider.notifier)
        .saveDraft(draftOrder);

    if (!mounted) return;
    result.fold(
      (failure) => NodeToastManager.show(
        context,
        title: 'Registry Error',
        message: failure.toFriendlyMessage(),
        status: NodeToastStatus.error,
      ),
      (_) {
        NodeToastManager.show(
          context,
          title: 'Draft Saved',
          message: '"$name" is now available in your Drafts tab.',
          status: NodeToastStatus.success,
        );
        setState(() {
          _isNamingBulk = false;
          _bulkNameController.clear();
        });
        ref.invalidate(draftOrdersProvider);
      },
    );
  }

  Future<void> _handleBulkButton() async {
    if (_confirmedGroups.isEmpty) return;

    final drafts = ref.read(draftOrdersProvider).value ?? [];

    if (drafts.isEmpty) {
      // No existing drafts -> show naming field in sheet
      setState(() => _isNamingBulk = true);
    } else {
      // Existing drafts found -> open picker
      _pickFromSaved();
    }
  }

  Future<void> _saveToBulkOrders(String groupName) async {
    if (_confirmedGroups.isEmpty) return;

    final repository = ref.read(bulkOrderRepositoryProvider);

    final result = await repository.saveBulkOrder(
      groupName: groupName,
      productName: widget.productName,
      brand: widget.brand,
      category: widget.category,
      subCategory: widget.subCategory,
      imageUrl: widget.imageUrl,
      availableColors: widget.availableColors
          .map(
            (c) =>
                ProductColor(name: c.label, hexCode: ColorUtils.toHex(c.color)),
          )
          .toList(),
      availableSizes: widget.availableSizes
          .map((s) => ProductSize(name: s, abbreviation: s))
          .toList(),
      availableMaterials: widget.product?.availableMaterials,
      srp: widget.product?.srp,
      priceTiersJson: widget.product != null
          ? jsonEncode(
              widget.product!.priceTiers.map((t) => t.toJson()).toList(),
            )
          : null,
      currentStock: widget.product?.currentStock,
      leadTimeDays: widget.product?.leadTimeDays,
      seoDescription: widget.product?.seoDescription,
      tradingTermsJson: widget.product != null
          ? jsonEncode(widget.product!.tradingTerms.toJson())
          : null,
      variantLabel: widget.variantLabel,
      confirmedGroups: _confirmedGroups,
    );

    result.fold(
      (failure) {
        if (!mounted) return;
        NodeToastManager.show(
          context,
          title: 'Storage Error',
          message: failure.toFriendlyMessage(),
          status: NodeToastStatus.error,
        );
      },
      (_) {
        if (!mounted) return;
        NodeToastManager.show(
          context,
          title: 'Archive Updated',
          message: 'Success! Added $_totalUnits unit(s) to Bulk DB.',
          status: NodeToastStatus.success,
        );
      },
    );
  }

  Future<void> _pickFromSaved() async {
    final pickerResult = await SavedItemPicker.show(context);
    if (pickerResult == null) return;

    final user = await ref.read(userProfileProvider.future);
    if (user == null) return;

    final dummyProduct = Product(
      id: widget.product?.id ?? const Uuid().v4(),
      sku:
          widget.product?.sku ??
          'DRAFT-${DateTime.now().millisecondsSinceEpoch}',
      name: widget.productName,
      brand: widget.brand,
      imageUrl: widget.imageUrl ?? '',
      priceTiers: widget.product?.priceTiers ?? const [],
      srp: widget.product?.srp ?? 0,
      hsCode: '',
      weightKg: 0,
      volumeCbm: 0,
      originCountry: '',
      unbsNumber: '',
      denier: '',
      material: '',
      supplier: const Supplier(
        id: '',
        name: '',
        imageUrl: '',
        category: '',
        location: Location(latitude: 0, longitude: 0, addressName: ''),
      ),
      categoryId: widget.category,
      currentStock: widget.product?.currentStock ?? 0,
      leadTimeDays: widget.product?.leadTimeDays ?? 0,
      warehouseLoc: '',
      seoTitle: '',
      seoDescription: widget.product?.seoDescription ?? '',
      searchKeywords: const [],
      slug: '',
      support: const ProductSupport(whatsapp: '', phone: '', email: ''),
      tradingTerms:
          widget.product?.tradingTerms ??
          const TradingTerms(id: '', content: ''),
    );

    final savedProduct = SavedProduct(
      product: dummyProduct,
      quantity: _totalUnits,
    );

    final currentOrderEntry = ProductOrderEntry(
      savedProduct: savedProduct,
      confirmedGroups: _confirmedGroups
          .map(
            (g) => ColorGroup(color: g.color, sizeQtys: Map.from(g.sizeQtys)),
          )
          .toList(),
    );

    final notifier = ref.read(draftOrdersProvider.notifier);
    bool hasError = false;

    if (pickerResult.newDraftName != null) {
      // Case 1: Create a brand new named draft
      _bulkNameController.text = pickerResult.newDraftName!;
      await _saveAsBulkDraft();
      return;
    }

    if (pickerResult.selectedDrafts == null ||
        pickerResult.selectedDrafts!.isEmpty)
      return;
    final picked = pickerResult.selectedDrafts!;

    for (final existingDraft in picked) {
      // Create an updated draft containing the previous entries + the newly configured one
      final updatedDraft = DraftOrder(
        id: existingDraft.id,
        entries: [...existingDraft.entries, currentOrderEntry],
        lastModified: DateTime.now(),
      );

      final result = await notifier.saveDraft(updatedDraft);

      result.fold((failure) {
        hasError = true;
        if (mounted) {
          NodeToastManager.show(
            context,
            title: 'Registry Error',
            message: failure.toFriendlyMessage(),
            status: NodeToastStatus.error,
          );
        }
      }, (_) {});
    }

    if (!hasError && mounted) {
      NodeToastManager.show(
        context,
        title: 'Appended to Draft',
        message: 'Configuration successfully added to selected draft(s).',
        status: NodeToastStatus.success,
      );
      ref.invalidate(draftOrdersProvider);
    }
  }

  Future<void> _saveDirectly() async {
    if (_confirmedGroups.isEmpty) return;

    // 💼 CLOUD SYNC: Persist all configured variants to Supabase saved_items
    if (widget.product != null) {
      final notifier = ref.read(savedItemsProvider.notifier);
      int saveCount = 0;
      bool hasError = false;

      for (final group in _confirmedGroups) {
        for (final entry in group.sizeQtys.entries) {
          if (entry.value > 0) {
            final result = await notifier.saveItem(
              product: widget.product!,
              quantity: entry.value,
              color: group.color.label,
              size: entry.key,
            );

            result.fold((_) => hasError = true, (_) => saveCount++);
          }
        }
      }

      if (mounted) {
        if (hasError) {
          NodeToastManager.show(
            context,
            title: 'Partial Save',
            message: 'Some items could not be synced to the cloud.',
            status: NodeToastStatus.warning,
          );
        } else if (saveCount > 0) {
          NodeToastManager.show(
            context,
            title: 'Saved to Bag',
            message:
                'Successfully synced $saveCount variants to your cloud inventory.',
            status: NodeToastStatus.success,
          );
        }
      }
    }

    final dateTag = DateFormat('MMM d').format(DateTime.now());
    final autoName = '${widget.productName} · $dateTag';
    await _saveToBulkOrders(autoName);
  }

  Future<void> _handleDownloadPdf() async {
    if (_confirmedGroups.isEmpty) return;

    final user = await ref.read(userProfileProvider.future);
    if (user == null) {
      if (!mounted) return;
      NodeToastManager.show(
        context,
        title: 'Profile Incomplete',
        message: 'Complete your identity in Profile to generate PDFs.',
        status: NodeToastStatus.warning,
      );
      return;
    }

    final now = DateTime.now();
    final dateStr = DateFormat('yyyyMMdd').format(now);
    final fallbackName = 'NODE_${widget.productName}_$dateStr';

    if (!mounted) return;
    final chosenName = await PdfNamingSheet.show(
      context,
      fallbackName: fallbackName,
    );

    if (chosenName == null || !mounted) return;

    final business = ref.read(userBusinessProvider).value;
    if (business == null) return;

    final businessProfile = BusinessModel.fromDrift(business);

    final orderEntry = ProductOrderEntry(
      savedProduct: SavedProduct(
        product: widget.product ?? _createProductShell(user),
        quantity: _totalUnits,
      ),
      confirmedGroups: _confirmedGroups,
    );

    if (!mounted) return;
    NodeToastManager.show(
      context,
      title: 'Architecting PDF',
      message: 'Compiling specification sheet...',
      status: NodeToastStatus.info,
    );

    try {
      final result = await OrderPdfService.generate(
        orderId: const Uuid().v4(),
        title: chosenName,
        user: user,
        businessProfile: businessProfile,
        entries: [orderEntry],
        date: now,
      );

      final pdfId = const Uuid().v4();
      await ref
          .read(pdfRepositoryProvider)
          .savePdfMetadata(
            id: pdfId,
            userId: user.id,
            title: chosenName,
            filePath: result.filePath,
            fileSize: result.fileSize,
          );

      ref.invalidate(userPdfsProvider);

      if (!mounted) return;
      NodeToastManager.show(
        context,
        title: 'Draft Stored',
        message: 'Spec sheet saved to Profile/PDFs.',
        status: NodeToastStatus.success,
      );
    } catch (e) {
      if (!mounted) return;
      NodeToastManager.show(
        context,
        title: 'Archive Failure',
        message: Failure.fromException(e).toFriendlyMessage(),
        status: NodeToastStatus.error,
      );
    }
  }

  Product _createProductShell(user) {
    return Product(
      id: 'prod_${widget.productName.hashCode}',
      sku: 'SKU_${widget.productName.hashCode}',
      name: widget.productName,
      brand: widget.brand,
      priceTiers: widget.product?.priceTiers ?? const [],
      srp: widget.product?.srp ?? 0,
      hsCode: '',
      weightKg: 0,
      volumeCbm: 0,
      originCountry: '',
      unbsNumber: '',
      denier: '',
      material: '',
      supplier: const Supplier(
        id: '',
        name: '',
        imageUrl: '',
        category: '',
        location: Location(latitude: 0, longitude: 0, addressName: ''),
      ),
      categoryId: widget.category,
      currentStock: widget.product?.currentStock ?? 0,
      leadTimeDays: widget.product?.leadTimeDays ?? 0,
      warehouseLoc: '',
      seoTitle: '',
      seoDescription: widget.product?.seoDescription ?? '',
      searchKeywords: const [],
      slug: widget.productName.toLowerCase().replaceAll(' ', '-'),
      imageUrl: widget.imageUrl ?? '',
      availableColors: widget.availableColors
          .map(
            (c) =>
                ProductColor(name: c.label, hexCode: ColorUtils.toHex(c.color)),
          )
          .toList(),
      availableSizes: widget.availableSizes
          .map((s) => ProductSize(name: s, abbreviation: s))
          .toList(),
      variantLabel: widget.variantLabel,
      support: const ProductSupport(whatsapp: '', phone: '', email: ''),
      tradingTerms:
          widget.product?.tradingTerms ??
          const TradingTerms(id: '', content: ''),
    );
  }

  Future<void> _handleConfirm() async {
    if (_confirmedGroups.isEmpty) return;

    final user = await ref.read(userProfileProvider.future);

    final business = ref.read(userBusinessProvider).value;

    if (user == null ||
        business == null ||
        user.fullName.trim().isEmpty ||
        business.phoneNumber?.trim().isEmpty == true ||
        business.city?.trim().isEmpty == true ||
        business.physicalAddress?.trim().isEmpty == true) {
      if (!mounted) return;
      ProfileInfoPage.show(
        context,
        isRequired: true,
        message:
            'Complete your business identity (Name, Phone, City, Address) to create this order.',
      );
      return;
    }

    if (!mounted) return;
    OrderConfirmationSheet.show(
      context,
      productName: widget.productName,
      totalUnits: _totalUnits,
      userName: user.fullName,
      onConfirm: () async {
        final orderNotifier = ref.read(wholesaleOrdersProvider.notifier);
        final orderId = const Uuid().v4();
        final now = DateTime.now();
        final autoPdfName =
            'ORDER_${orderId.substring(0, 8)}_${widget.productName.replaceAll(' ', '_')}';

        if (!mounted) return;
        NodeToastManager.show(
          context,
          title: 'Packaging Order',
          message: 'Generating official spec sheet...',
          status: NodeToastStatus.info,
        );

        try {
          final businessEntry = ref.read(userBusinessProvider).value;
          if (businessEntry == null) return;

          final businessProfile = BusinessModel.fromDrift(businessEntry);

          final productEntity = widget.product ?? _createProductShell(user);
          final orderEntry = ProductOrderEntry(
            savedProduct: SavedProduct(
              product: productEntity,
              quantity: _totalUnits,
            ),
            confirmedGroups: _confirmedGroups,
          );

          final pdfResult = await OrderPdfService.generate(
            orderId: orderId,
            title: autoPdfName,
            user: user,
            businessProfile: businessProfile,
            entries: [orderEntry],
            date: now,
          );

          final pdfId = const Uuid().v4();
          await ref
              .read(pdfRepositoryProvider)
              .savePdfMetadata(
                id: pdfId,
                userId: user.id,
                title: autoPdfName,
                filePath: pdfResult.filePath,
                fileSize: pdfResult.fileSize,
              );

          final wholesaleOrder = WholesaleOrder(
            id: orderId,
            date: now,
            status: OrderStatus.pending,
            entries: [orderEntry],
            pdfId: pdfId,
            productId: widget.product?.id,
            supplierId: widget.product?.supplier.id,
            updatedAt: now,
          );

          final result = await orderNotifier.saveOrder(
            wholesaleOrder,
          );

          if (!mounted) return;
          result.fold(
            (failure) => NodeToastManager.show(
              context,
              title: 'Order Interrupted',
              message: failure.toFriendlyMessage(),
              status: NodeToastStatus.error,
            ),
            (_) {
              // 🔔 Trigger Local Notification
              NotificationService.showConfirmationAlert(
                title: 'Wholesale Order Created',
                body:
                    'Your order for ${widget.productName} has been archived to Profile/Orders.',
                payload: orderId,
              );

              NodeToastManager.show(
                context,
                title: 'Order Created',
                message:
                    'Successfully generated and archived to Profile/Orders.',
                status: NodeToastStatus.success,
              );
              ref.invalidate(userPdfsProvider);
              ref.invalidate(wholesaleOrdersProvider);
              Navigator.of(context).pop();
            },
          );
        } catch (e) {
          if (!mounted) return;
          NodeToastManager.show(
            context,
            title: 'Generation Failed',
            message: Failure.fromException(e).toFriendlyMessage(),
            status: NodeToastStatus.error,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SpecsOrderHeader(
              productName: widget.productName,
              totalUnits: _totalUnits,
              onBack: () => Navigator.of(context).pop(),
            ),

            if (_confirmedGroups.isNotEmpty) ...[
              SpecsOrderSummaryHeader(onDownloadPdf: _handleDownloadPdf),
              SizedBox(height: 10.h),
              OrderSummaryTable(
                groups: _confirmedGroups,
                productName: widget.productName,
                category: widget.category,
                subCategory: widget.subCategory,
                imageUrl: widget.imageUrl,
                variantLabel: widget.variantLabel,
              ),
              SizedBox(height: 10.h),
              SpecsConfirmedGroupsList(
                confirmedGroups: _confirmedGroups,
                onEdit: (g) {
                  setState(() {
                    _editingGroup = g;
                    _confirmedGroups.remove(g);
                  });
                },
                onDelete: (g) => setState(() => _confirmedGroups.remove(g)),
              ),
              SizedBox(height: 24.h),
            ],

            OrderGroupBuilder(
              colors: widget.availableColors,
              sizes: widget.availableSizes,
              variantLabel: widget.variantLabel,
              usedColorLabels: _usedColors,
              editGroup: _editingGroup,
              onGroupAdded: (group) {
                setState(() {
                  _confirmedGroups.add(group);
                  _editingGroup = null;
                });
              },
            ),

            SizedBox(height: 16.h),

            if (_isNamingBulk)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _bulkNameController,
                          autofocus: true,
                          style: GoogleFonts.outfit(
                            fontSize: 13.sp,
                            color: theme.colorScheme.onSurface,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Name this bulk draft...',
                            hintStyle: TextStyle(
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.3,
                              ),
                              fontSize: 12.sp,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: _saveAsBulkDraft,
                        icon: Icon(
                          Icons.arrow_forward_rounded,
                          color: theme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            if (_confirmedGroups.isNotEmpty)
              SpecsOrderActions(
                totalUnits: _totalUnits,
                onSaveDirectly: _saveDirectly,
                onPickFromSaved: _handleBulkButton,
                onConfirm: _handleConfirm,
              ),
          ],
        ),
      ),
    );
  }
}
