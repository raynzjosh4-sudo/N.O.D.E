import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:node_app/core/utils/color_utils.dart';
import 'package:node_app/features/home/presentation/pages/specificationorderpage/page/specs_order_page.dart';
import 'package:node_app/features/home/presentation/widgets/node_instagram_app_bar.dart';
import 'package:node_app/features/inventory/domain/entities/product.dart';
import 'widgets/specs_hero_section.dart';
import '../../../../showcase/presentation/services/node_toast_manager.dart';
import '../../../../showcase/presentation/widgets/node_toast.dart';
import 'widgets/specs_thumbnail_gallery.dart';
import 'widgets/specs_brand_section.dart';
import 'widgets/specs_logistics_row.dart';
import 'widgets/specs_price_action_row.dart';
import 'widgets/specs_order_button.dart';
import 'widgets/specs_description.dart';
import 'widgets/specs_pricing_table.dart';
import 'widgets/specs_trading_terms.dart';
import 'widgets/specs_technical_table.dart';
import 'widgets/specs_similar_products.dart';
import 'widgets/specs_contact_support.dart';
import '../imageviewerpage/image_viewer_page.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/features/orders/presentation/providers/bulk_order_providers.dart';
import 'package:node_app/features/saved_items/presentation/providers/saved_items_provider.dart';
import 'package:node_app/core/error/failure.dart';
import 'package:node_app/core/utils/responsive_layout.dart';

class ProductSpecsScreen extends ConsumerStatefulWidget {
  final Product product;
  const ProductSpecsScreen({super.key, required this.product});

  @override
  ConsumerState<ProductSpecsScreen> createState() => _ProductSpecsScreenState();
}

class _ProductSpecsScreenState extends ConsumerState<ProductSpecsScreen> {
  int _quantity = 2; // Initial value as shown in image
  int _selectedMediaIndex = 0;

  Widget _buildMobile(BuildContext context, Product product) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // 🎩 MODULAR INSTAGRAM-STYLE APP BAR
        NodeAppBar(title: 'Product Details', onBack: () => context.pop()),
        ..._buildImageSlivers(product),
        ..._buildDetailsSlivers(product),
      ],
    );
  }

  Widget _buildDesktop(BuildContext context, Product product) {
    final theme = Theme.of(context);
    return Column(
      children: [
        // Top App Bar
        SizedBox(
          height: 60.h,
          child: NodeAppBar(title: 'Product Details', onBack: () => context.pop()),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🖼️ LEFT PANE: Sticky Images
              Expanded(
                flex: 5,
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          ..._buildImageSlivers(product).map((s) => 
                            s is SliverToBoxAdapter ? s.child! : 
                            (s is SliverPadding ? s.child! : const SizedBox())
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Vertical Divider
              Container(
                width: 1,
                color: theme.colorScheme.onSurface.withOpacity(0.05),
              ),

              // 📝 RIGHT PANE: Scrolling Details
              Expanded(
                flex: 7,
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.only(top: 24.h),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          ..._buildDetailsSlivers(product).map((s) => 
                            s is SliverToBoxAdapter ? s.child! : 
                            (s is SliverPadding ? s.child! : const SizedBox())
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildImageSlivers(Product product) {
    return [
      SliverToBoxAdapter(
        child: SpecsHeroSection(
          imageUrl: product.mediaUrls.isNotEmpty
              ? product.mediaUrls[_selectedMediaIndex]
              : product.imageUrl,
          srp: product.srp,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ImageViewerPage(
                  imageUrls: product.mediaUrls.isNotEmpty
                      ? product.mediaUrls
                      : [product.imageUrl],
                  initialIndex: _selectedMediaIndex,
                ),
              ),
            );
          },
        ),
      ),
      SliverToBoxAdapter(
        child: SpecsThumbnailGallery(
          imageUrls: product.mediaUrls.isNotEmpty
              ? product.mediaUrls
              : [product.imageUrl],
          selectedIndex: _selectedMediaIndex,
          onSelect: (index) => setState(() => _selectedMediaIndex = index),
        ),
      ),
    ];
  }

  List<Widget> _buildDetailsSlivers(Product product) {
    return [
      SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0.w),
              child: SpecsBrandSection(
                productName: product.name,
                brandName: product.brand,
                supplierName: product.supplier.name,
                supplierLocation: product.supplier.location,
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0.w),
              child: SpecsLogisticsRow(
                stock: product.currentStock,
                leadTimeDays: product.leadTimeDays,
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0.w),
              child: SpecsPriceActionRow(
                srp: product.srp,
                quantity: _quantity,
                onAdd: () => setState(() => _quantity++),
                onRemove: () => setState(
                  () => _quantity = _quantity > 1 ? _quantity - 1 : 1,
                ),
                onAddToOrder: () async {
                  // 💼 PERSIST TO CLOUD
                  final cloudResult = await ref
                      .read(savedItemsProvider.notifier)
                      .saveItem(product: product, quantity: _quantity);

                  final repository = ref.read(bulkOrderRepositoryProvider);
                  final result = await repository.quickAddBulkOrder(
                    productName: product.name,
                    brand: product.brand,
                    category: product.categoryId,
                    subCategory: product.variantLabel,
                    imageUrl: product.imageUrl,
                    availableColors: product.availableColors,
                    availableSizes: product.availableSizes,
                    variantLabel: product.variantLabel,
                    totalUnits: _quantity,
                    srp: product.srp,
                  );

                  if (mounted) {
                    cloudResult.fold(
                      (failure) => NodeToastManager.show(
                        context,
                        title: 'Registry Error',
                        message: failure.toFriendlyMessage(),
                        status: NodeToastStatus.error,
                      ),
                      (_) => NodeToastManager.show(
                        context,
                        title: 'Saved to Bag',
                        message: '${product.name} synced to your cloud bag.',
                        status: NodeToastStatus.success,
                      ),
                    );
                  }

                  result.fold(
                    (failure) {
                      NodeToastManager.show(
                        context,
                        title: 'Failed to add to order',
                        message: failure.toFriendlyMessage(),
                        status: NodeToastStatus.error,
                      );
                    },
                    (_) {
                      ref.invalidate(savedBulkOrdersProvider);
                      NodeToastManager.show(
                        context,
                        title: 'Order Updated',
                        message: 'Added $_quantity units of ${product.name} to order',
                        status: NodeToastStatus.success,
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0.w),
              child: SpecsOrderButton(
                onTap: () => SpecsOrderSheet.show(
                  context,
                  productName: product.name,
                  brand: product.brand,
                  category: product.categoryId,
                  subCategory: product.variantLabel,
                  imageUrl: product.imageUrl,
                  availableSizes: product.availableSizes.map((s) => s.name).toList(),
                  availableColors: product.availableColors.map((c) {
                    return {
                      'label': c.name,
                      'color': ColorUtils.fromHex(c.hexCode),
                    };
                  }).toList(),
                  product: product,
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0.w),
              child: SpecsDescription(description: product.seoDescription),
            ),
            SizedBox(height: 32.h),

            // 🏦 FULL-WIDTH PRICING TABLE (Edges touch screen)
            SpecsWholesalePricingTable(product: product),

            SizedBox(height: 32.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0.w),
              child: SpecsTradingTerms(tradingTerms: product.tradingTerms),
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
      // ☎️ FULL-WIDTH SUPPORT SECTION
      SliverToBoxAdapter(
        child: SpecsContactSupport(support: product.support),
      ),
      SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 32.h),
            // ⚙️ FULL-WIDTH TECHNICAL TABLE
            SpecsTechnicalTable(product: product),
            SpecsSimilarProducts(currentProduct: product),
            SizedBox(height: 24.h), // Bottom spacing
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final theme = Theme.of(context);
    final scaffoldBg = theme.scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: ResponsiveLayout(
        mobileBody: _buildMobile(context, product),
        desktopBody: _buildDesktop(context, product),
      ),
    );
  }
}
