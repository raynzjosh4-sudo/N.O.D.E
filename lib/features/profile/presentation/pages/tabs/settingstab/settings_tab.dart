import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node_app/core/theme/theme_provider.dart';

import 'pages/node_manifesto_page.dart';
import 'pages/theme_settings_page.dart';
import 'pages/trading_terms_page.dart';
import 'pages/legal_terms_page.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/features/showcase/presentation/services/node_toast_manager.dart';
import 'package:node_app/features/showcase/presentation/widgets/node_toast.dart';

import 'package:go_router/go_router.dart';

class SettingsTab extends ConsumerWidget {
  SettingsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final currentThemeMode = ref.watch(themeModeProvider);

    // Formatting mode name for subtitle
    final modeName = currentThemeMode == ThemeMode.system
        ? 'System'
        : (currentThemeMode == ThemeMode.light ? 'Light' : 'Dark');

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 0),
      children: [
        // ── N.O.D.E. Branding ───────────────────────────────────────
        SizedBox(height: 8.h),
        Row(
          children: [
            SvgPicture.asset(
              'assets/icon/nodeicon.svg',
              width: 28.w,
              height: 28.h,
            ),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'N.O.D.E.',
                  style: GoogleFonts.outfit(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w900,
                    color: onSurface,
                    letterSpacing: 2,
                  ),
                ),
                Text(
                  'National, Order & Distribution, Exchange',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w600,
                    color: onSurface.withOpacity(0.4),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 16.h),

        // ── Manifesto Entry ─────────────────────────────────────────
        _buildSettingTile(
          context,
          'Our Purpose & Mission',
          Icons.lightbulb_outline_rounded,
          onTap: () => NodeManifestoPage.show(context),
        ),
        SizedBox(height: 4.h),
        Divider(color: onSurface.withOpacity(0.05)),
        SizedBox(height: 16.h),

        _buildSettingTile(
          context,
          'Profile Information',
          Icons.person_outline_rounded,
          onTap: () => context.push('/profile-management'),
        ),

        SizedBox(height: 7.h),
        _buildSectionHeader('Preferences'),
        _buildSettingTile(
          context,
          'Appearance',
          Icons.palette_outlined,
          onTap: () => ThemeSettingsPage.show(context),
          trailing: modeName,
        ),

        SizedBox(height: 16.h),
        _buildSectionHeader('Support'),
        _buildSettingTile(
          context,
          'Help Center',
          Icons.help_outline_rounded,
          onTap: () => NodeToastManager.show(
            context,
            title: 'Coming Soon',
            message: 'Help Center is being prepared for the N.O.D.E live release.',
          ),
        ),
        _buildSettingTile(
          context,
          'Terms of Service',
          Icons.description_outlined,
          onTap: () => LegalTermsPage.show(
            context,
            termId: 'tos',
            title: 'Terms of Service',
          ),
        ),
        _buildSettingTile(
          context,
          'Privacy Policy',
          Icons.privacy_tip_outlined,
          onTap: () => LegalTermsPage.show(
            context,
            termId: 'privacy',
            title: 'Privacy Policy',
          ),
        ),

        _buildSettingTile(
          context,
          'Become a Supplier',
          Icons.storefront_outlined,
          onTap: () => LegalTermsPage.show(
            context,
            termId: 'supplier',
            title: 'Become a Supplier',
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
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

  Widget _buildSettingTile(
    BuildContext context,
    String title,
    IconData icon, {
    required VoidCallback onTap,
    String? trailing,
    bool isDestructive = false,
  }) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final color = isDestructive ? theme.colorScheme.error : onSurface;

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
          decoration: BoxDecoration(
            color: isDestructive
                ? theme.colorScheme.error.withOpacity(0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12.r),
            border: isDestructive
                ? Border.all(color: theme.colorScheme.error.withOpacity(0.15))
                : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20.w,
                color: color.withOpacity(isDestructive ? 1.0 : 0.7),
              ),
              SizedBox(width: 12.w),
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 15.sp,
                  fontWeight: isDestructive ? FontWeight.w700 : FontWeight.w600,
                  color: color,
                ),
              ),
              Spacer(),
              if (trailing != null)
                Text(
                  trailing,
                  style: GoogleFonts.outfit(
                    fontSize: 14.sp,
                    color: onSurface.withOpacity(0.5),
                  ),
                ),
              Icon(
                Icons.chevron_right_rounded,
                size: 16.w,
                color: color.withAlpha(80),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
