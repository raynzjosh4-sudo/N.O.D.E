import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/core/database/database_provider.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/features/auth/google/service.dart';
import 'package:node_app/features/profile/presentation/pages/tabs/settingstab/widgets/account_deletion_sheet.dart';
import 'package:node_app/features/profile/presentation/providers/profile_providers.dart';
import 'account_details_page.dart';
import 'profile_info_page.dart';
import 'package:node_app/core/database/app_database.dart';

class ProfileManagementPage extends ConsumerWidget {
  const ProfileManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final userAsync = ref.watch(userProfileProvider);
    final businessAsync = ref.watch(userBusinessProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.chevron_left_rounded, color: onSurface, size: 28.w),
        ),
        title: Text(
          'Profile Management',
          style: GoogleFonts.outfit(
            fontSize: 18.sp,
            fontWeight: FontWeight.w900,
            color: onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        children: [
          // 👤 User Identity Header
          userAsync.when(
            data: (user) => _buildProfileHeader(
              context,
              user?.fullName ?? 'Anonymous User',
              user?.email ?? '',
              user?.profilePicUrl,
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          SizedBox(height: 32.h),
          _buildSectionHeader(context, 'Account Settings'),

          // ── Navigation Section ────────────────────────────────────────
          _buildManagementTile(
            context,
            title: 'Account Information',
            subtitle: 'Name, Email, Profile Photo',
            icon: Icons.person_outline_rounded,
            onTap: () => AccountDetailsPage.show(context),
          ),
          _buildManagementTile(
            context,
            title: 'Business Setup',
            subtitle: 'Legal Entity,',
            icon: Icons.business_center_outlined,
            onTap: () => ProfileInfoPage.show(context),
          ),

          SizedBox(height: 20.h),
          _buildSectionHeader(context, 'Account Actions'),

          // ── Critical Actions ──────────────────────────────────────────
          _buildActionTile(
            context,
            title: 'Sign Out',
            icon: Icons.logout_rounded,
            onTap: () async {
              try {
                debugPrint(
                  '👉 [UI] Sign Out button tapped from Profile Management.',
                );
                final authService = AuthService();
                await authService.signOut();
                if (context.mounted) {
                  debugPrint(
                    '✅ [UI] Logout complete. Returning to Home Screen.',
                  );
                  context.go('/home');
                }
              } catch (e) {
                debugPrint('❌ [Settings] Logout failed: $e');
              }
            },
            isDestructive: true,
          ),
          _buildActionTile(
            context,
            title: 'Delete Account',
            icon: Icons.delete_forever_outlined,
            onTap: () async {
              final confirmed = await AccountDeletionSheet.show(
                context,
                onDelete: () async {
                  // 1. Delete cloud account (triggers cascades)
                  final authService = AuthService();
                  await authService.deleteAccount();

                  // 2. Wipe local Drift DB
                  final db = ref.read(databaseProvider);
                  await db.wipeAllData();
                },
              );

              if (confirmed == true && context.mounted) {
                context.go('/home');
              }
            },
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    String name,
    String subtitle,
    String? profilePicUrl,
  ) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 4.w),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: theme.primaryColor.withOpacity(0.1),
                width: 2.w,
              ),
            ),
            child: ClipOval(
              child: profilePicUrl != null && profilePicUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: profilePicUrl,
                      width: 64.w,
                      height: 64.w,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: theme.primaryColor.withOpacity(0.2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(
                        Icons.person_rounded,
                        size: 32.w,
                        color: theme.primaryColor,
                      ),
                    )
                  : Icon(
                      Icons.person_rounded,
                      size: 32.w,
                      color: theme.primaryColor,
                    ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.outfit(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w900,
                    color: onSurface,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: onSurface.withOpacity(0.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 4.h),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.outfit(
          fontSize: 11.sp,
          fontWeight: FontWeight.w900,
          color: Colors.grey.withOpacity(0.5),
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildManagementTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: onSurface,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              subtitle,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: onSurface.withOpacity(0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    required bool isDestructive,
  }) {
    final theme = Theme.of(context);
    final color = isDestructive
        ? theme.colorScheme.error
        : theme.colorScheme.onSurface;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
        child: Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: color.withOpacity(isDestructive ? 1.0 : 0.7),
          ),
        ),
      ),
    );
  }
}
