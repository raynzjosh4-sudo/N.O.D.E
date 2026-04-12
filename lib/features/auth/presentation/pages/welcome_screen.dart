import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/fashion_image_collage.dart';
import 'package:node_app/core/utils/responsive_size.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          // 1. Background Collage
          Positioned.fill(child: FashionImageCollage()),

          // 2. Strong Top Dark Layer + Smooth Fade
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.98), // Very strong top
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                    theme.colorScheme.surface.withOpacity(0.02),
                  ],
                  stops: [0.0, 0.1, 0.45, 1.0],
                ),
              ),
            ),
          ),

          // 3. Top Logo Branding (Mini Headers)
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.only(top: 15.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          'assets/icon/nodeicon.svg',
                          width: 18.w,
                          height: 18.h,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'N.O.D.E.',
                          style: GoogleFonts.outfit(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 0.3.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      child: Text(
                        'National Order & Distribution Exchange',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 6.5.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.5),
                          letterSpacing: 0.5,
                          height: 1.2.h,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 4. Content Container (Full Flush Card)
          Positioned(
            left: 0, // Flush to sides
            right: 0,
            bottom: 0, // Flush to bottom
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 15,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      Text(
                        'Welcome to Node',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.outfit(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                          height: 1.1.h,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Wholesale',
                                style: GoogleFonts.outfit(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w800,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              Container(
                                height: 1.5.h,
                                width: 80.w,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  borderRadius: BorderRadius.circular(1.r),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'style',
                            style: GoogleFonts.outfit(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Node is an innovative and open trade-sharing network. We are dedicated to creating growth for our businesses.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.sp,
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                      height: 1.5.h,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  // Get Started (Signup)
                  SizedBox(
                    width: double.infinity,
                    height: 34.h,
                    child: ElevatedButton(
                      onPressed: () => context.go('/home'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24.r),
                        ),
                      ),
                      child: Text(
                        'Get Started',
                        style: GoogleFonts.outfit(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
