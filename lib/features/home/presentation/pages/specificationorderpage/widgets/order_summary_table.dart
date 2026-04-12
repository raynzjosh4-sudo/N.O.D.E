import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../order_models.dart';
import 'package:node_app/core/utils/responsive_size.dart';

/// Cross-tab table: rows = colours, columns = sizes, cells = qty.
/// Includes a product header section (image, name, category) for professional PDF reports.
class OrderSummaryTable extends StatelessWidget {
  final List<ColorGroup> groups;
  final String productName;
  final String category;
  final String subCategory;
  final String? imageUrl;
  final String variantLabel;

  const OrderSummaryTable({
    super.key,
    required this.groups,
    required this.productName,
    required this.category,
    required this.subCategory,
    this.imageUrl,
    this.variantLabel = 'Size',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final primary = theme.primaryColor;

    // Get all unique sizes across all groups
    final allSizes = <String>{};
    for (var g in groups) {
      allSizes.addAll(g.sizeQtys.keys);
    }
    final sortedSizes = allSizes.toList()..sort();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Product Header (For PDF/Summary) ──────────────────────────────
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Details (Left Side)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${category.toUpperCase()}  >  ${subCategory.toUpperCase()}',
                        style: GoogleFonts.outfit(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                          color: onSurface.withOpacity(0.4),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        productName,
                        style: GoogleFonts.outfit(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w800,
                          height: 1.1.h,
                          color: onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20.w),
                // Product Image (Right Side)
                Container(
                  width: 80.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    color: onSurface.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12.r),
                    image: imageUrl != null
                        ? DecorationImage(
                            image: NetworkImage(imageUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: imageUrl == null
                      ? Icon(Icons.inventory_2_rounded,
                          size: 32.w, color: onSurface.withOpacity(0.2))
                      : null,
                ),
              ],
            ),
          ),

          Divider(height: 1.h, thickness: 1),

          // ── Table Grid ────────────────────────────────────────────────────
          Table(
            border: TableBorder(
              horizontalInside: BorderSide(color: onSurface.withOpacity(0.08)),
              verticalInside: BorderSide(color: onSurface.withOpacity(0.08)),
              bottom: BorderSide(color: onSurface.withOpacity(0.08)),
              top: BorderSide(color: onSurface.withOpacity(0.08)),
            ),
            columnWidths: {
              0: FlexColumnWidth(2),
              for (int i = 0; i < sortedSizes.length; i++) i + 1: FlexColumnWidth(1),
              sortedSizes.length + 1: FlexColumnWidth(1.2),
            },
            children: [
              // Header Row
              TableRow(
                decoration: BoxDecoration(
                  color: onSurface.withOpacity(0.03),
                ),
                children: [
                  _buildHeaderCell('COLOUR / ${variantLabel.toUpperCase()}'),
                  ...sortedSizes.map((s) => _buildHeaderCell(s)),
                  _buildHeaderCell('TOTAL'),
                ],
              ),
              // Data Rows
              ...groups.map((g) {
                int rowTotal = g.sizeQtys.values.fold(0, (sum, q) => sum + q);
                return TableRow(
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: onSurface.withOpacity(0.05))),
                  ),
                  children: [
                    // Colour cell
                    Padding(
                      padding: EdgeInsets.all(12.w),
                      child: Row(
                        children: [
                          Container(
                            width: 10.w,
                            height: 10.h,
                            decoration: BoxDecoration(color: g.color.color, shape: BoxShape.circle),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              g.color.label,
                              style: GoogleFonts.outfit(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Quantity cells
                    ...sortedSizes.map((s) {
                      final qty = g.sizeQtys[s] ?? 0;
                      return _buildDataCell(qty == 0 ? '-' : qty.toString());
                    }),
                    // Row total
                    _buildDataCell(rowTotal.toString(), isBold: true),
                  ],
                );
              }),
              // Grand Total Row
              TableRow(
                decoration: BoxDecoration(
                  color: onSurface.withOpacity(0.02),
                ),
                children: [
                  _buildHeaderCell('TOTAL'),
                  ...sortedSizes.map((s) {
                    int colTotal = groups.fold<int>(0, (sum, g) => sum + (g.sizeQtys[s] ?? 0));
                    return _buildDataCell(colTotal.toString(), isBold: true);
                  }),
                  _buildDataCell(
                    groups
                        .fold<int>(0, (sum, g) => sum + g.sizeQtys.values.fold<int>(0, (s, q) => s + q))
                        .toString(),
                    isBold: true,
                    isHighlight: true,
                    primary: primary,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String label) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 8.w),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: GoogleFonts.outfit(
          fontSize: 10.sp,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildDataCell(String value, {bool isBold = false, bool isHighlight = false, Color? primary}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
      child: Text(
        value,
        textAlign: TextAlign.center,
        style: GoogleFonts.outfit(
          fontSize: 13.sp,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          color: isHighlight ? primary ?? const Color(0xFF2E7D32) : null,
        ),
      ),
    );
  }
}
