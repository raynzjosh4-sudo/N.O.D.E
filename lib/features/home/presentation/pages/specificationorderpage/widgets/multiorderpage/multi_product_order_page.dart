import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/features/inventory/domain/entities/product_attributes.dart';
import 'package:node_app/features/profile/domain/entities/draft_order.dart';
import 'package:node_app/features/profile/domain/entities/saved_product.dart';
import 'package:node_app/features/showcase/presentation/services/node_toast_manager.dart';
import 'package:node_app/features/showcase/presentation/widgets/node_toast.dart';
import '../../order_models.dart';
import 'package:node_app/features/profile/domain/entities/wholesale_order.dart';
import '../order_group_builder.dart';
import '../order_section_label.dart';
import '../order_summary_table.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import '../saved_item_picker.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:node_app/features/orders/presentation/providers/bulk_order_providers.dart';
import 'package:node_app/features/auth/presentation/providers/user_providers.dart';
import 'package:node_app/features/profile/domain/entities/order_status.dart';
import 'package:node_app/core/utils/color_utils.dart';

class MultiProductOrderPage extends ConsumerStatefulWidget {
  final List<SavedProduct> selectedProducts;
  final bool showProductStats;

  const MultiProductOrderPage({
    super.key,
    required this.selectedProducts,
    this.showProductStats = true,
  });

  static void show(
    BuildContext context,
    List<SavedProduct> selectedProducts, {
    bool showProductStats = true,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MultiProductOrderPage(
          selectedProducts: selectedProducts,
          showProductStats: showProductStats,
        ),
      ),
    );
  }

  @override
  ConsumerState<MultiProductOrderPage> createState() =>
      _MultiProductOrderPageState();
}

class _MultiProductOrderPageState extends ConsumerState<MultiProductOrderPage> {
  int _currentStepIndex = 0;
  bool _showingSummary = false;

  // Track configurations for each product
  final List<ProductOrderEntry> _completedEntries = [];

  // Current step state
  List<ColorGroup> _currentProductGroups = [];
  ColorGroup? _editingGroup;

  @override
  void initState() {
    super.initState();
    _prepareCurrentStep();
  }

  void _prepareCurrentStep() {
    if (_currentStepIndex < widget.selectedProducts.length) {
      final product = widget.selectedProducts[_currentStepIndex];
      _currentProductGroups = [];
      _editingGroup = null;

      // Pre-fill if product has a saved spec
      if (product.selectedColor != null && product.selectedSize != null) {
        // Find the color variant in product's available list
        final matchedColor = product.product.availableColors.firstWhere(
          (c) => c.name.toLowerCase() == product.selectedColor!.toLowerCase(),
          orElse: () => product.product.availableColors.isNotEmpty
              ? product.product.availableColors.first
              : ProductColor(name: product.selectedColor!, hexCode: '#808080'),
        );

        final variant = ColorVariant(
          label: matchedColor.name,
          color: ColorUtils.fromHex(matchedColor.hexCode),
        );

        _currentProductGroups.add(
          ColorGroup(
            color: variant,
            sizeQtys: {product.selectedSize!: product.quantity},
          ),
        );
      }
    }
  }

  void _nextStep() {
    final currentProduct = widget.selectedProducts[_currentStepIndex];

    setState(() {
      // Save current configuration
      _completedEntries.add(
        ProductOrderEntry(
          savedProduct: currentProduct,
          confirmedGroups: List.from(_currentProductGroups),
        ),
      );

      if (_currentStepIndex < widget.selectedProducts.length - 1) {
        _currentStepIndex++;
        _prepareCurrentStep();
      } else {
        _showingSummary = true;
      }
    });
  }

  void _previousStep() {
    if (_currentStepIndex > 0) {
      setState(() {
        _currentStepIndex--;
        // Pop last entry to re-edit
        final last = _completedEntries.removeLast();
        _currentProductGroups = last.confirmedGroups;
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final primary = theme.primaryColor;

    if (_showingSummary) {
      return _buildSummaryView(context);
    }

    if (widget.selectedProducts.isEmpty) {
      return Scaffold(
        body: Center(child: Text('No products selected for ordering.')),
      );
    }
    final currentProduct = widget.selectedProducts[_currentStepIndex];
    final totalSteps = widget.selectedProducts.length;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header Stepper ──────────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _previousStep,
                    child: Container(
                      width: 32.w,
                      height: 32.h,
                      decoration: BoxDecoration(
                        color: onSurface.withOpacity(0.06),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.chevron_left_rounded,
                        size: 20.w,
                        color: onSurface,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Configure Order',
                          style: GoogleFonts.outfit(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w900,
                            color: onSurface,
                          ),
                        ),
                        Text(
                          'Product ${_currentStepIndex + 1} of $totalSteps',
                          style: GoogleFonts.outfit(
                            fontSize: 12.sp,
                            color: primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Progress Bar ─────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              child: Row(
                children: List.generate(totalSteps, (index) {
                  final isDone = index < _currentStepIndex;
                  final isCurrent = index == _currentStepIndex;
                  return Expanded(
                    child: Container(
                      height: 4.h,
                      margin: EdgeInsets.symmetric(horizontal: 2.w),
                      decoration: BoxDecoration(
                        color: isDone || isCurrent
                            ? primary
                            : onSurface.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // ── Builder Segment ──────────────────────────────────────────
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // ── Product Info Section (Now Scrollable) ─────────────────────
                  Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Row(
                      children: [
                        Container(
                          width: 50.w,
                          height: 50.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            image: DecorationImage(
                              image: NetworkImage(
                                currentProduct.product.imageUrl,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentProduct.product.name,
                                style: GoogleFonts.outfit(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                currentProduct.product.brand,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: onSurface.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (_currentProductGroups.isNotEmpty) ...[
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                      child: OrderSectionLabel(label: 'CURRENT CONFIGURATION'),
                    ),
                    OrderSummaryTable(
                      groups: _currentProductGroups,
                      productName: currentProduct.product.name,
                      category: 'WHOLESALE',
                      subCategory: 'SELECTED',
                      variantLabel: currentProduct.product.variantLabel,
                    ),
                    SizedBox(height: 10.h),
                    // Rows for removal/editing
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        children: _currentProductGroups
                            .map((g) => _buildGroupRow(g, primary, onSurface))
                            .toList(),
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],

                  OrderGroupBuilder(
                    colors: currentProduct.product.availableColors
                        .map(
                          (c) => ColorVariant(
                            label: c.name,
                            color: ColorUtils.fromHex(c.hexCode),
                          ),
                        )
                        .toList(),
                    sizes: currentProduct.product.availableSizes
                        .map((s) => s.name)
                        .toList(),
                    variantLabel: currentProduct.product.variantLabel,
                    usedColorLabels: _currentProductGroups
                        .map((g) => g.color.label)
                        .toList(),
                    editGroup: _editingGroup,
                    onGroupAdded: (group) {
                      setState(() {
                        _currentProductGroups.add(group);
                        _editingGroup = null;
                      });
                    },
                  ),

                  // ── Integrated Navigation (Not Floating) ────────────────────
                  SizedBox(height: 32.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      children: [
                        // Optional Stats (No 2 and 3)
                        if (widget.showProductStats &&
                            _currentProductGroups.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(bottom: 20.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${_currentProductGroups.fold(0, (sum, g) => sum + g.sizeQtys.values.fold(0, (s, q) => s + q))} Units',
                                      style: GoogleFonts.outfit(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    Text(
                                      'Total for this item',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: onSurface.withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                        Align(
                          alignment: Alignment.centerRight,
                          child: OutlinedButton(
                            onPressed: _currentProductGroups.isNotEmpty
                                ? _nextStep
                                : null,
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: primary, width: 2.w),
                              foregroundColor: primary,
                              padding: EdgeInsets.symmetric(
                                vertical: 16.h,
                                horizontal: 48.w,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            child: Text(
                              _currentStepIndex == totalSteps - 1
                                  ? 'See Summary'
                                  : 'Next',
                              style: GoogleFonts.outfit(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupRow(ColorGroup g, Color primary, Color onSurface) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: onSurface.withOpacity(0.05))),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => setState(() {
              _editingGroup = g;
              _currentProductGroups.remove(g);
            }),
            child: Icon(Icons.edit_rounded, size: 16.w, color: primary),
          ),
          SizedBox(width: 12.w),
          Container(
            width: 8.w,
            height: 8.h,
            decoration: BoxDecoration(
              color: g.color.color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              g.color.label,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _currentProductGroups.remove(g)),
            child: Icon(
              Icons.close_rounded,
              size: 16.w,
              color: onSurface.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryView(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final primary = theme.primaryColor;

    final grandTotalUnits = _completedEntries.fold(
      0,
      (sum, e) => sum + e.totalUnits,
    );
    final grandTotalAmount = _completedEntries.fold(
      0.0,
      (sum, e) => sum + e.totalAmount,
    );

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // ── Summary Header ──────────────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _showingSummary = false),
                    child: Container(
                      width: 32.w,
                      height: 32.h,
                      decoration: BoxDecoration(
                        color: onSurface.withOpacity(0.06),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.chevron_left_rounded,
                        size: 20.w,
                        color: onSurface,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'Order Summary',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w900,
                        color: onSurface,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  GestureDetector(
                    onTap: () {
                      // TODO: Implement unified PDF export
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.picture_as_pdf_rounded,
                            size: 14.w,
                            color: primary,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            'PDF',
                            style: GoogleFonts.outfit(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 0.w),
                children: [
                  ..._completedEntries.asMap().entries.map((entryMap) {
                    final index = entryMap.key;
                    final entry = entryMap.value;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: Row(
                            children: [
                              Container(
                                width: 32.w,
                                height: 32.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6.r),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      entry.savedProduct.product.imageUrl,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      entry.savedProduct.product.name,
                                      style: GoogleFonts.outfit(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${entry.totalUnits} units · UGX ${entry.totalAmount.toStringAsFixed(0)}',
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        color: onSurface.withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        OrderSummaryTable(
                          groups: entry.confirmedGroups,
                          productName: entry.savedProduct.product.name,
                          category: 'WHOLESALE',
                          subCategory: 'ORDER',
                          variantLabel: entry.savedProduct.product.variantLabel,
                        ),
                        SizedBox(height: 24.h),
                        if (index < _completedEntries.length - 1)
                          Divider(
                            color: onSurface.withOpacity(0.05),
                            height: 1.h,
                          ),
                      ],
                    );
                  }),

                  // ── Total Section ───────────────────────────────────────
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Items',
                              style: TextStyle(
                                color: onSurface.withOpacity(0.5),
                              ),
                            ),
                            Text(
                              '${_completedEntries.length}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Units',
                              style: TextStyle(
                                color: onSurface.withOpacity(0.5),
                              ),
                            ),
                            Text(
                              '$grandTotalUnits Units',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: Divider(),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: GoogleFonts.outfit(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'UGX ${grandTotalAmount.toStringAsFixed(0)}',
                                  style: GoogleFonts.outfit(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w900,
                                    color: primary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () async {
                                  final user = await ref.read(
                                    userProfileProvider.future,
                                  );
                                  if (user == null) return;

                                  final pickerResult =
                                      await SavedItemPicker.show(context);
                                  if (pickerResult == null) return;

                                  final repository = ref.read(
                                    orderRepositoryProvider,
                                  );

                                  if (pickerResult.newDraftName != null) {
                                    // Case 1: Create a brand new draft
                                    final draft = DraftOrder(
                                      id: pickerResult
                                          .newDraftName!, // Use name as ID or generate UUID? Let's use name for now as the picker implies
                                      lastModified: DateTime.now(),
                                      entries: _completedEntries,
                                    );
                                    await repository.saveDraft(draft, user.id);
                                  } else if (pickerResult.selectedDrafts !=
                                      null) {
                                    // Case 2: Append to existing drafts
                                    for (final selectedDraft
                                        in pickerResult.selectedDrafts!) {
                                      final updatedDraft = DraftOrder(
                                        id: selectedDraft.id,
                                        lastModified: DateTime.now(),
                                        entries: [
                                          ...selectedDraft.entries,
                                          ..._completedEntries,
                                        ],
                                      );
                                      await repository.saveDraft(
                                        updatedDraft,
                                        user.id,
                                      );
                                    }
                                  }

                                  if (mounted) {
                                    ref.invalidate(userDraftsProvider);
                                    Navigator.pop(context);
                                    NodeToastManager.show(
                                      context,
                                      title: 'Draft Saved',
                                      message:
                                          'Successfully added to your drafts.',
                                      status: NodeToastStatus.success,
                                    );
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: onSurface.withOpacity(0.1),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 14.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                ),
                                child: Text(
                                  'Save Draft',
                                  style: GoogleFonts.outfit(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: onSurface,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                onPressed: () async {
                                  final user = await ref.read(
                                    userProfileProvider.future,
                                  );
                                  if (user == null) return;

                                  final order = WholesaleOrder(
                                    id: const Uuid().v4(),
                                    date: DateTime.now(),
                                    status: OrderStatus.pending,
                                    entries: _completedEntries,
                                  );

                                  final result = await ref
                                      .read(orderRepositoryProvider)
                                      .saveOrder(order, user.id);

                                  if (mounted) {
                                    result.fold(
                                      (f) => NodeToastManager.show(
                                        context,
                                        title: 'Order Failed',
                                        message: f.message,
                                        status: NodeToastStatus.error,
                                      ),
                                      (_) {
                                        ref.invalidate(userOrdersProvider);
                                        Navigator.pop(context);
                                        NodeToastManager.show(
                                          context,
                                          title: 'Order Created',
                                          message:
                                              'Order created successfully!',
                                          status: NodeToastStatus.success,
                                        );
                                      },
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primary,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 14.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Create Order',
                                  style: GoogleFonts.outfit(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
