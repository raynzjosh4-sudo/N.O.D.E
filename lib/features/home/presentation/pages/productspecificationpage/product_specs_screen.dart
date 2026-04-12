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

class ProductSpecsScreen extends ConsumerStatefulWidget {
  final Product product;
  const ProductSpecsScreen({super.key, required this.product});

  @override
  ConsumerState<ProductSpecsScreen> createState() => _ProductSpecsScreenState();
}

class _ProductSpecsScreenState extends ConsumerState<ProductSpecsScreen> {
  int _quantity = 2; // Initial value as shown in image
  int _selectedMediaIndex = 0;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    final theme = Theme.of(context);
    final scaffoldBg = theme.scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // 🎩 MODULAR INSTAGRAM-STYLE APP BAR
          NodeAppBar(title: 'Product Details', onBack: () => context.pop()),

          // 🧥 BENTO HERO IMAGE
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

          // 🎞️ THUMBNAIL GALLERY
          SliverToBoxAdapter(
            child: SpecsThumbnailGallery(
              imageUrls: product.mediaUrls.isNotEmpty
                  ? product.mediaUrls
                  : [product.imageUrl],
              selectedIndex: _selectedMediaIndex,
              onSelect: (index) => setState(() => _selectedMediaIndex = index),
            ),
          ),

          // 📝 INFO SECTION
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
                    supplierName: 'Node Supply Group',
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

                      result.fold(
                        (failure) {
                          NodeToastManager.show(
                            context,
                            title: 'Failed to add to order',
                            message: failure.message,
                            status: NodeToastStatus.error,
                          );
                        },
                        (_) {
                          // Invalidate saved orders so Profile page updates
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
                      availableSizes: product.availableSizes
                          .map((s) => s.name)
                          .toList(),
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

          // ☎️ FULL-WIDTH SUPPORT SECTION (Edges touch screen)
          SliverToBoxAdapter(
            child: SpecsContactSupport(support: product.support),
          ),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 32.h),

                // ⚙️ FULL-WIDTH TECHNICAL TABLE (Edges touch screen)
                SpecsTechnicalTable(product: product),

                SpecsSimilarProducts(),

                SizedBox(height: 24.h), // Bottom spacing
              ],
            ),
          ),
        ],
      ),
    );
  }
}
