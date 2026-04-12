import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:node_app/features/auth/presentation/widgets/auth_prompt_sheet.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../profile/presentation/pages/profile/profile_page.dart';
import 'package:node_app/core/utils/responsive_size.dart';

class HomeHeader extends StatelessWidget {
  HomeHeader({super.key});

  void _showAuthPrompt(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => AuthPromptSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = AppColors.of(context);

    // 🔔 Mock authentication state for demonstration
    const bool isLoggedOut = true;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Profile Avatar
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    const ProfilePage(),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                      const begin = Offset(-1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.easeOutQuint;
                      var tween = Tween(
                        begin: begin,
                        end: end,
                      ).chain(CurveTween(curve: curve));
                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                transitionDuration: Duration(milliseconds: 450),
              ),
            );
          },
          child: CircleAvatar(
            radius: 18,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            backgroundImage: NetworkImage(
              'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200&auto=format&fit=crop',
            ),
          ),
        ),

        // Brand Logo
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/icon/nodeicon.svg',
              width: 22.w, // Slightly larger for better branding visibility
              height: 22.w,
            ),
            SizedBox(width: 6.w),
            Text(
              'N.O.D.E.',
              style: GoogleFonts.outfit(
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.onSurface,
                letterSpacing: 1,
              ),
            ),
          ],
        ),

        // Notification Bell
        GestureDetector(
          onTap: () {
            if (isLoggedOut) {
              _showAuthPrompt(context);
              return;
            }
          },
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: appColors.borderLight),
                ),
                child: Icon(
                  Icons.notifications_none_rounded,
                  size: 18.w,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Positioned(
                right: 4.w,
                top: 4.h,
                child: Container(
                  width: 6.w,
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
