import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/core/utils/responsive_size.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: onSurface, size: 20.w),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Settings',
          style: GoogleFonts.outfit(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20.w),
        children: [
          _buildSectionHeader('Account'),
          _buildSettingTile(
            context,
            'Profile Information',
            Icons.person_outline_rounded,
            onTap: () {},
          ),
          _buildSettingTile(
            context,
            'Security & Password',
            Icons.lock_outline_rounded,
            onTap: () {},
          ),
          SizedBox(height: 24.h),
          _buildSectionHeader('Preferences'),
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
          SizedBox(height: 24.h),
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
            'Privacy Policy',
            Icons.privacy_tip_outlined,
            onTap: () {},
          ),
          SizedBox(height: 32.h),
          _buildSettingTile(
            context,
            'Sign Out',
            Icons.logout_rounded,
            onTap: () {
              // Handle sign out
            },
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 12.h),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.outfit(
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          color: Colors.grey.withOpacity(0.6),
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
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.04),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: color.withOpacity(0.05)),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 20.w, color: color.withOpacity(0.8)),
              ),
              SizedBox(width: 16.w),
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
              SizedBox(width: 8.w),
              Icon(
                Icons.chevron_right_rounded,
                size: 20.w,
                color: color.withOpacity(0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
