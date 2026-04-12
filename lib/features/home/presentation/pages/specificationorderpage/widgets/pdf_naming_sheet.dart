import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/core/utils/responsive_size.dart';

class PdfNamingSheet extends StatefulWidget {
  final String fallbackName;

  const PdfNamingSheet({
    super.key,
    required this.fallbackName,
  });

  static Future<String?> show(
    BuildContext context, {
    required String fallbackName,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PdfNamingSheet(fallbackName: fallbackName),
    );
  }

  @override
  State<PdfNamingSheet> createState() => _PdfNamingSheetState();
}

class _PdfNamingSheetState extends State<PdfNamingSheet> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final primary = theme.primaryColor;

    return Container(
      padding: EdgeInsets.fromLTRB(
        24.w,
        24.h,
        24.w,
        MediaQuery.of(context).padding.bottom + 24.h + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Name this PDF',
                style: GoogleFonts.outfit(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                  color: onSurface,
                  letterSpacing: -0.5,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: onSurface.withOpacity(0.05),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    size: 20.w,
                    color: onSurface.withOpacity(0.5),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            'Leave blank to use the auto-generated name.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14.sp,
              color: onSurface.withOpacity(0.5),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 32.h),
          Container(
            decoration: BoxDecoration(
              color: onSurface.withOpacity(0.04),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: onSurface.withOpacity(0.08),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            child: TextField(
              controller: _controller,
              autofocus: true,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: onSurface,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: widget.fallbackName,
                hintStyle: GoogleFonts.plusJakartaSans(
                  color: onSurface.withOpacity(0.2),
                ),
              ),
            ),
          ),
          SizedBox(height: 32.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final name = _controller.text.trim().isEmpty
                    ? widget.fallbackName
                    : 'NODE_${_controller.text.trim()}';
                Navigator.pop(context, name);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 20.h),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              child: Text(
                'GENERATE PDF',
                style: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
