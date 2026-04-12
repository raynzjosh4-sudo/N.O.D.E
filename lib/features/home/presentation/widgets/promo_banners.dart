import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/features/home/domain/entities/promo_campaign.dart';

class PromoBanners extends StatelessWidget {
  PromoBanners({super.key});

  ImageProvider _getImageProvider(PromoCampaign promo) {
    if (promo.isLocal) {
      return AssetImage(promo.imageUrl);
    }
    return NetworkImage(promo.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Fetch data from dummy database (this will be replaced by Provider reading real DB later)
    final campaigns = PromoCampaign.dummyCampaigns;
    if (campaigns.length < 3) return const SizedBox(); // Guard clause
    
    final mainPromo = campaigns[0];
    final topSubPromo = campaigns[1];
    final bottomSubPromo = campaigns[2];

    return SizedBox(
      height: 140.h, // Shorter height
      child: Row(
        children: [
          // Left Large Banner
          Expanded(
            flex: 6,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                image: DecorationImage(
                  image: _getImageProvider(mainPromo),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  // Dark Gradient Overlay for text readability
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.1),
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  // Content Stack
                  Stack(
                    children: [
                      // Centered Big Text
                      Center(
                        child: Text(
                          mainPromo.title,
                          style: GoogleFonts.outfit(
                            fontSize: 26.sp,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      // Bottom Row: Shop Now & Discount
                      Positioned(
                        bottom: 12.h,
                        left: 12.w,
                        right: 12.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                mainPromo.actionText,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.outfit(
                                  fontSize: 6.sp,
                                  fontWeight: FontWeight.w800,
                                  color: theme.colorScheme.onPrimary,
                                  height: 1.1.h,
                                ),
                              ),
                            ),
                            Text(
                              mainPromo.subtitle,
                              textAlign: TextAlign.right,
                              style: GoogleFonts.outfit(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                height: 1.2.h,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(width: 8.w),
          // Right Stack Banners
          Expanded(
            flex: 4,
            child: Column(
              children: [
                // Top Small Banner
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12.r),
                      image: DecorationImage(
                        image: _getImageProvider(topSubPromo),
                        fit: BoxFit.cover,
                      ),
                    ),
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(8.w),
                    child: Text(
                      topSubPromo.title,
                      style: GoogleFonts.outfit(
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.1.h,
                        shadows: [
                          Shadow(color: Colors.black54, blurRadius: 4),
                        ]
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                // Bottom Small Banner
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[800],
                      borderRadius: BorderRadius.circular(12.r),
                      image: DecorationImage(
                        image: _getImageProvider(bottomSubPromo),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      bottomSubPromo.title,
                      style: GoogleFonts.outfit(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
