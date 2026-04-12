import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node_app/core/theme/theme_provider.dart';

import 'pages/node_manifesto_page.dart';
import 'pages/profile_management_page.dart';
import 'pages/theme_settings_page.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/core/utils/seed_data_service.dart';
import 'package:node_app/features/inventory/presentation/providers/inventory_notifier.dart';
import 'package:node_app/features/showcase/presentation/services/node_toast_manager.dart';
import 'package:node_app/features/showcase/presentation/widgets/node_toast.dart';

class SettingsTab extends ConsumerWidget {
  SettingsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final currentThemeMode = ref.watch(themeModeProvider);
    
    // Formatting mode name for subtitle
    final modeName = currentThemeMode == ThemeMode.system ? 'System' : 
        (currentThemeMode == ThemeMode.light ? 'Light' : 'Dark');

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
          onTap: () => ProfileManagementPage.show(context),
        ),
        _buildSettingTile(
          context,
          'Security & Password',
          Icons.lock_outline_rounded,
          onTap: () {},
        ),
        SizedBox(height: 16.h),
        _buildSectionHeader('Preferences'),
        _buildSettingTile(
          context,
          'Appearance',
          Icons.palette_outlined,
          onTap: () => ThemeSettingsPage.show(context),
          trailing: modeName,
        ),
        _buildSettingTile(
          context,
          'Notifications',
          Icons.notifications_none_rounded,
          onTap: () {},
        ),
        _buildSettingTile(
          context,
          'Language',
          Icons.language_rounded,
          onTap: () {},
          trailing: 'English',
        ),
        SizedBox(height: 16.h),
        _buildSectionHeader('Support'),
        _buildSettingTile(
          context,
          'Help Center',
          Icons.help_outline_rounded,
          onTap: () {},
        ),
        _buildSettingTile(
          context,
          'Terms of Service',
          Icons.description_outlined,
          onTap: () {},
        ),
        _buildSettingTile(
          context,
          'Become a Supplier',
          Icons.storefront_outlined,
          onTap: () {},
        ),
        SizedBox(height: 16.h),
        _buildSectionHeader('Developer'),
        _buildSettingTile(
          context,
          'Populate Initial Data',
          Icons.auto_awesome_rounded,
          onTap: () async {
            final db = ref.read(databaseProvider);
            await SeedDataService.seedDatabase(db);
            await ref.read(inventoryNotifierProvider.notifier).refresh();
            if (context.mounted) {
              NodeToastManager.show(
                context,
                title: 'Data Seeded',
                message: 'Real sample records have been injected into your local registry.',
                status: NodeToastStatus.success,
              );
            }
          },
        ),
        SizedBox(height: 24.h),
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

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
        child: Row(
          children: [
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
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
          ],
        ),
      ),
    );
  }
}
