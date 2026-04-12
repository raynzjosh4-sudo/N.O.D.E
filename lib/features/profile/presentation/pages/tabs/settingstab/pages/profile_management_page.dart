import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'account_details_page.dart';
import 'profile_info_page.dart';
import 'package:node_app/core/utils/responsive_size.dart';

class ProfileManagementPage extends StatelessWidget {
  ProfileManagementPage({super.key});

  static void show(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfileManagementPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final primary = theme.primaryColor;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
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
            subtitle: 'Legal Entity, Logistics, TIN',
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
            onTap: () {
              // Handle logout
            },
            isDestructive: false,
          ),
          _buildActionTile(
            context,
            title: 'Delete Account',
            icon: Icons.delete_forever_outlined,
            onTap: () {
              // Handle deletion warning
            },
            isDestructive: true,
          ),
          SizedBox(height: 40.h),
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
    final color = isDestructive ? theme.colorScheme.error : theme.colorScheme.onSurface;

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
