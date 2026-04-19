import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:node_app/features/auth/presentation/widgets/auth_prompt_sheet.dart';
import '../../../../core/theme/app_theme.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node_app/features/auth/presentation/providers/auth_state_provider.dart';

import 'package:go_router/go_router.dart';
import 'package:node_app/features/profile/presentation/providers/profile_providers.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeHeader extends ConsumerWidget {
  HomeHeader({super.key});

  void _showAuthPrompt(BuildContext context) {
    debugPrint('👉 [UI] Authentication required. Showing Login Sheet.');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => AuthPromptSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final appColors = AppColors.of(context);
    final isAuthenticated = ref.watch(isAuthenticatedProvider);
    final userProfile = ref.watch(userProfileProvider).value;
    final businessProfile = ref.watch(userBusinessProvider).value;

    // Determine Greeting Name
    final displayName =
        userProfile?.fullName ?? businessProfile?.legalName ?? 'Guest';

    // 🔄 Sync Trigger... (omitted for brevity)

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Profile Avatar & Greeting
        GestureDetector(
          onTap: () {
            if (!isAuthenticated) {
              _showAuthPrompt(context);
              return;
            }
            context.push('/profile');
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 18.w,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                child: !isAuthenticated
                    ? Icon(
                        Icons.person_outline_rounded,
                        size: 20.w,
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      )
                    : ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: userProfile?.profilePicUrl ?? '',
                          width: 36.w,
                          height: 36.w,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: theme.colorScheme.primary.withOpacity(0.2),
                            ),
                          ),
                          errorWidget: (context, url, error) => Icon(
                            Icons.person_rounded,
                            size: 20.w,
                            color: theme.colorScheme.onSurface.withOpacity(0.3),
                          ),
                        ),
                      ),
              ),
              SizedBox(width: 10.w),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Hello,',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface.withOpacity(0.4),
                      ),
                    ),
                    Text(
                      displayName,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: GoogleFonts.outfit(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Brand Logo
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/icon/nodeicon.svg',
              width: 22.w,
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
            debugPrint(
              '👉 [UI] Notification Icon tapped. Auth State: $isAuthenticated',
            );
            if (!isAuthenticated) {
              _showAuthPrompt(context);
              return;
            }
            context.push('/notifications');
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
