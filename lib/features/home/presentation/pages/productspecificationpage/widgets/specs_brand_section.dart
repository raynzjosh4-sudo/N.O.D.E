import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:node_app/core/utils/responsive_size.dart';

class SpecsBrandSection extends StatelessWidget {
  final String productName;
  final String brandName;
  final String supplierName;

  SpecsBrandSection({
    super.key,
    required this.productName,
    required this.brandName,
    required this.supplierName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          productName,
          style: GoogleFonts.outfit(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: onSurface,
          ),
        ),
        Text(
          brandName,
          style: GoogleFonts.outfit(
            fontSize: 14.sp,
            color: onSurface.withOpacity(0.45),
          ),
        ),
        SizedBox(height: 16.h),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              supplierName,
              style: GoogleFonts.outfit(
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
                color: onSurface.withOpacity(0.25),
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                SizedBox(
                  width: 32.w,
                  height: 32.h,
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: 'https://logo.clearbit.com/${brandName.toLowerCase().replaceAll(' ', '')}.com',
                      fit: BoxFit.contain,
                      placeholder: (context, url) => Container(color: theme.primaryColor.withOpacity(0.05)),
                      errorWidget: (context, url, error) => Container(
                        color: theme.primaryColor.withOpacity(0.1),
                        child: Center(
                          child: Text(
                            brandName.isNotEmpty ? brandName[0].toUpperCase() : 'B',
                            style: GoogleFonts.outfit(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: theme.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        supplierName,
                        style: GoogleFonts.outfit(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: onSurface.withOpacity(0.85),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                              decoration: BoxDecoration(
                                color: onSurface.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.location_on_outlined, 
                                    size: 14.w, 
                                    color: onSurface.withOpacity(0.4)
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    'View Location',
                                    style: GoogleFonts.outfit(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.bold,
                                      color: onSurface.withOpacity(0.4),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
