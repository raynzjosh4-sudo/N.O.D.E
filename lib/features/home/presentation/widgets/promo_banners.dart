import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/core/widgets/node_shimmer.dart';
import 'package:node_app/features/home/domain/entities/promo_campaign.dart';
import 'package:node_app/features/home/presentation/providers/home_providers.dart';
import 'package:node_app/core/utils/responsive_layout.dart';

class PromoBanners extends ConsumerWidget {
  const PromoBanners({super.key});

  ImageProvider _getImageProvider(PromoCampaign promo) {
    if (promo.isLocal || !promo.imageUrl.startsWith('http')) {
      return AssetImage(
        promo.imageUrl.isNotEmpty
            ? promo.imageUrl
            : 'assets/images/placeholder.png',
      );
    }
    return NetworkImage(promo.imageUrl);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final promotionsAsync = ref.watch(activePromotionsProvider);

    return promotionsAsync.when(
      data: (activeCampaigns) {
        if (activeCampaigns.length < 3) return const SizedBox();

        final mainPromo = activeCampaigns[0];
        final topSubPromo = activeCampaigns[1];
        final bottomSubPromo = activeCampaigns[2];

        return SizedBox(
          height: ResponsiveLayout.isDesktop(context) ? 350 : 140.h,
          child: Row(
            children: [
              // Left Large Banner
              Expanded(
                flex: 6,
                child: _buildBanner(theme, mainPromo, isLarge: true),
              ),
              SizedBox(width: 8.w),
              // Right Stack Banners
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    Expanded(child: _buildBanner(theme, topSubPromo)),
                    SizedBox(height: 8.h),
                    Expanded(
                      child: _buildBanner(
                        theme,
                        bottomSubPromo,
                        isBottom: true,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const BannerSkeleton(),
      error: (e, st) => const SizedBox(),
    );
  }

  Widget _buildBanner(
    ThemeData theme,
    PromoCampaign promo, {
    bool isLarge = false,
    bool isBottom = false,
  }) {
    if (isLarge) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          image: DecorationImage(
            image: _getImageProvider(promo),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
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
            Center(
              child: Text(
                promo.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            Positioned(
              bottom: 12.h,
              left: 12.w,
              right: 12.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (promo.actionText.isNotEmpty)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        promo.actionText,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 6.sp,
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.onPrimary,
                          height: 1.1.h,
                        ),
                      ),
                    ),
                  if (promo.subtitle.isNotEmpty)
                    Text(
                      promo.subtitle,
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
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: !isBottom
            ? theme.colorScheme.surfaceContainerHighest
            : Colors.blueGrey[800],
        borderRadius: BorderRadius.circular(12.r),
        image: DecorationImage(
          image: _getImageProvider(promo),
          fit: BoxFit.cover,
          colorFilter: isBottom
              ? ColorFilter.mode(
                  Colors.black.withOpacity(0.5),
                  BlendMode.darken,
                )
              : null,
        ),
      ),
      alignment: !isBottom ? Alignment.topLeft : Alignment.center,
      padding: EdgeInsets.all(8.w),
      child: Text(
        promo.title,
        textAlign: isBottom ? TextAlign.center : TextAlign.start,
        style: GoogleFonts.outfit(
          fontSize: !isBottom ? 8.sp : 18.sp,
          fontWeight: FontWeight.w800,
          color: Colors.white,
          height: 1.1.h,
          shadows: !isBottom
              ? [const Shadow(color: Colors.black54, blurRadius: 4)]
              : null,
        ),
      ),
    );
  }
}
