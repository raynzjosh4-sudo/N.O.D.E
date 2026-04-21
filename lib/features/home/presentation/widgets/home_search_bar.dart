import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:node_app/core/utils/responsive_size.dart';

class HomeSearchBar extends StatefulWidget {
  final TextEditingController? controller;
  final VoidCallback? onTap;
  final VoidCallback? onFilterTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  const HomeSearchBar({
    super.key,
    this.controller,
    this.onTap,
    this.onFilterTap,
    this.onChanged,
    this.onSubmitted,
  });

  @override
  State<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = AppColors.of(context);

    return Row(
      children: [
        // Search Field
        Expanded(
          child: Container(
            height: 42.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(21.r),
                border: Border.all(color: appColors.borderLight),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  )
                ]),
            child: Row(
              children: [
                Icon(Icons.search_rounded,
                    color: theme.colorScheme.onSurface.withOpacity(0.4), size: 18.w),
                SizedBox(width: 8.w),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onTap: widget.onTap,
                    onChanged: (value) {
                      setState(() {});
                      widget.onChanged?.call(value);
                    },
                    onSubmitted: widget.onSubmitted,
                    style: GoogleFonts.plusJakartaSans(
                      color: theme.colorScheme.onSurface,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search for products...',
                      hintStyle: GoogleFonts.plusJakartaSans(
                        color: theme.colorScheme.onSurface.withOpacity(0.4),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                if (_controller.text.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      _controller.clear();
                      setState(() {});
                      widget.onChanged?.call('');
                    },
                    child: Icon(Icons.close_rounded,
                        color: theme.colorScheme.onSurface.withOpacity(0.3), size: 16.w),
                  )
                else
                  // Orange Cart Button Inside Search Bar
                  Container(
                    padding: EdgeInsets.all(5.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.shopping_cart_outlined,
                        color: theme.colorScheme.onPrimary, size: 14.w),
                  )
              ],
            ),
          ),
        ),
        SizedBox(width: 12.w),
        // Filter Button
        GestureDetector(
          onTap: widget.onFilterTap,
          child: Container(
            height: 42.h,
            width: 42.w,
            decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                shape: BoxShape.circle,
                border: Border.all(color: appColors.borderLight),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  )
                ]),
            child: Icon(Icons.tune_rounded,
                color: theme.colorScheme.onSurface, size: 18.w),
          ),
        ),
      ],
    );
  }
}

