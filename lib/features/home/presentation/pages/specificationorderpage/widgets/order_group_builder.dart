import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../order_models.dart';
import 'order_section_label.dart';
import 'order_step_btn.dart';
import 'package:node_app/core/utils/responsive_size.dart';

/// The "draft builder" — lets the user pick a color, toggle sizes,
/// set qty per size, then emit the finished ColorGroup via [onGroupAdded].
class OrderGroupBuilder extends StatefulWidget {
  final List<ColorVariant> colors;
  final List<String> sizes;
  final String variantLabel;
  final List<String> usedColorLabels; // prevent duplicate color groups
  final ColorGroup? editGroup;
  final void Function(ColorGroup) onGroupAdded;

  const OrderGroupBuilder({
    super.key,
    required this.colors,
    required this.sizes,
    this.variantLabel = 'Size',
    required this.usedColorLabels,
    this.editGroup,
    required this.onGroupAdded,
  });

  @override
  State<OrderGroupBuilder> createState() => _OrderGroupBuilderState();
}

class _OrderGroupBuilderState extends State<OrderGroupBuilder> {
  ColorVariant? _selectedColor;
  // size → qty; only sizes in this map are "selected"
  final Map<String, int> _sizeQtys = {};

  @override
  void initState() {
    super.initState();
    if (widget.editGroup != null) {
      _loadGroup(widget.editGroup!);
    }
  }

  @override
  void didUpdateWidget(covariant OrderGroupBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.editGroup != null && widget.editGroup != oldWidget.editGroup) {
      _loadGroup(widget.editGroup!);
    }
  }

  void _loadGroup(ColorGroup group) {
    _selectedColor = group.color;
    _sizeQtys.clear();
    _sizeQtys.addAll(group.sizeQtys);
  }

  bool get _canAdd => _selectedColor != null && _sizeQtys.isNotEmpty;

  void _toggleSize(String size) {
    setState(() {
      if (_sizeQtys.containsKey(size)) {
        _sizeQtys.remove(size);
      } else {
        _sizeQtys[size] = 1;
      }
    });
  }

  void _confirm() {
    if (!_canAdd) return;
    widget.onGroupAdded(
      ColorGroup(
        color: _selectedColor!,
        sizeQtys: Map<String, int>.from(_sizeQtys),
      ),
    );
    setState(() {
      _selectedColor = null;
      _sizeQtys.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final primary = theme.primaryColor;
    final cardColor = theme.cardColor;

    final availableColors = widget.colors
        .where((c) => !widget.usedColorLabels.contains(c.label))
        .toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── COLOUR ──────────────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: OrderSectionLabel(label: 'SELECT COLOUR YOU WANT'),
          ),
          SizedBox(height: 1.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: OrderSectionLabel(
              label: 'tab the color you want, then tap the sizes',
            ),
          ),
          SizedBox(height: 5.h),

          if (availableColors.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                'All colours added.',
                style: GoogleFonts.outfit(
                  fontSize: 13.sp,
                  color: onSurface.withOpacity(0.4),
                ),
              ),
            )
          else
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SizedBox(
                height: 75.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: availableColors.length,
                  separatorBuilder: (_, __) => SizedBox(width: 10.w),
                  itemBuilder: (_, i) {
                    final c = availableColors[i];
                    final isSelected = _selectedColor?.label == c.label;
                    return GestureDetector(
                      onTap: () => setState(() {
                        _selectedColor = isSelected ? null : c;
                        _sizeQtys.clear();
                      }),
                      child: Column(
                        children: [
                          AnimatedContainer(
                            duration: Duration(milliseconds: 160),
                            width: 44.w,
                            height: 44.h,
                            decoration: BoxDecoration(
                              color: c.color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? primary
                                    : Colors.transparent,
                                width: 3.w,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: c.color.withOpacity(0.5),
                                        blurRadius: 8,
                                        offset: Offset(0, 3),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: isSelected
                                ? Icon(
                                    Icons.check,
                                    size: 18.w,
                                    color: c.color.computeLuminance() > 0.5
                                        ? Colors.black
                                        : Colors.white,
                                  )
                                : null,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            c.label,
                            style: GoogleFonts.outfit(
                              fontSize: 10.sp,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: isSelected
                                  ? onSurface
                                  : onSurface.withOpacity(0.4),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

          // ── SIZES (only when color is picked) ───────────────────────────────
          if (_selectedColor != null) ...[
            SizedBox(height: 24.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: OrderSectionLabel(
                label: 'SELECT ${widget.variantLabel.toUpperCase()}',
              ),
            ),
            SizedBox(height: 12.h),

            if (widget.sizes.isEmpty)
              // No sizes? Just add a single quantity row for this color
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: GestureDetector(
                  onTap: () => setState(() {
                    if (!_sizeQtys.containsKey('Quantity')) {
                      _sizeQtys['Quantity'] = 1;
                    }
                  }),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 150),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: _sizeQtys.containsKey('Quantity')
                          ? primary
                          : cardColor,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: _sizeQtys.containsKey('Quantity')
                            ? primary
                            : onSurface.withOpacity(0.08),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_rounded,
                          size: 16.w,
                          color: _sizeQtys.containsKey('Quantity')
                              ? Colors.white
                              : primary,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Confirm Quantity',
                          style: GoogleFonts.outfit(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: _sizeQtys.containsKey('Quantity')
                                ? Colors.white
                                : onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              // Size toggle pills
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.sizes.map((size) {
                    final isActive = _sizeQtys.containsKey(size);
                    return GestureDetector(
                      onTap: () => _toggleSize(size),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 150),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: isActive ? primary : cardColor,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: isActive
                                ? primary
                                : onSurface.withOpacity(0.08),
                          ),
                        ),
                        child: Text(
                          size,
                          style: GoogleFonts.outfit(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: isActive
                                ? Colors.white
                                : onSurface.withOpacity(0.55),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

            // Qty rows for each active size
            if (_sizeQtys.isNotEmpty) ...[
              SizedBox(height: 16.h),
              ..._sizeQtys.keys.map((size) {
                final qty = _sizeQtys[size]!;
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: cardColor,
                    border: Border(
                      bottom: BorderSide(color: onSurface.withOpacity(0.08)),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        size,
                        style: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: onSurface,
                        ),
                      ),
                      Spacer(),
                      OrderStepBtn(
                        icon: Icons.remove,
                        onTap: qty > 1
                            ? () => setState(() => _sizeQtys[size] = qty - 1)
                            : null,
                      ),
                      SizedBox(width: 14.w),
                      Text(
                        '$qty',
                        style: GoogleFonts.outfit(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: onSurface,
                        ),
                      ),
                      SizedBox(width: 14.w),
                      OrderStepBtn(
                        icon: Icons.add,
                        onTap: () => setState(() => _sizeQtys[size] = qty + 1),
                      ),
                    ],
                  ),
                );
              }),
            ],

            // Add group button
            if (_sizeQtys.isNotEmpty) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 20.w),
                decoration: BoxDecoration(
                  color: cardColor,
                  border: Border(
                    bottom: BorderSide(color: onSurface.withOpacity(0.08)),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: _canAdd ? _confirm : null,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 10.h,
                        ),
                        decoration: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.add_rounded,
                              size: 16.w,
                              color: Colors.white,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              'Add ${_selectedColor?.label ?? ''} to Order',
                              style: GoogleFonts.outfit(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
