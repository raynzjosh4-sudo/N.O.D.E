import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/core/utils/responsive_size.dart';

class OrderConfirmationSheet extends StatelessWidget {
  final String productName;
  final int totalUnits;
  final String userName;
  final VoidCallback onConfirm;

  const OrderConfirmationSheet({
    super.key,
    required this.productName,
    required this.totalUnits,
    required this.userName,
    required this.onConfirm,
  });

  static void show(
    BuildContext context, {
    required String productName,
    required int totalUnits,
    required String userName,
    required VoidCallback onConfirm,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => OrderConfirmationSheet(
        productName: productName,
        totalUnits: totalUnits,
        userName: userName,
        onConfirm: onConfirm,
      ),
    );
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
        MediaQuery.of(context).padding.bottom + 24.h,
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
                'Create Order',
                style: GoogleFonts.outfit(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w900,
                  color: onSurface,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.close_rounded,
                  color: onSurface.withOpacity(0.3),
                ),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          Text(
            productName,
            style: GoogleFonts.outfit(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: onSurface,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            '$totalUnits Unit(s)',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: primary,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'Business Name: $userName',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: onSurface.withOpacity(0.4),
            ),
          ),
          SizedBox(height: 24.h),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: primary.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded, size: 16.w, color: primary),
                SizedBox(width: 5.w),
                Expanded(
                  child: Text(
                    'After creating your order, go to your profile/orders and send it. This allows you to generate the PDF even without immediate fulfillment.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: primary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onConfirm();
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
                'CREATE ORDER NOW',
                style: GoogleFonts.outfit(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
