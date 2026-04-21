import 'package:flutter/material.dart';
import 'package:node_app/core/utils/responsive_size.dart';

class ProfileTabBar extends StatelessWidget {
  const ProfileTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: SizedBox(
        height: 28.h,
        child: TabBar(
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          padding: EdgeInsets.zero,
          indicatorPadding: EdgeInsets.zero,
          labelPadding: EdgeInsets.symmetric(horizontal: 12.w),
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            color: theme.primaryColor,
            borderRadius: BorderRadius.circular(14.r),
          ),
          unselectedLabelColor: onSurface.withOpacity(0.4),
          labelColor: Colors.white,
          labelStyle: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
          ),
          dividerColor: Colors.transparent,
          tabs: const [
            Tab(text: 'Records'),
            Tab(text: 'Saved'),
            Tab(text: 'Drafts'),
            Tab(text: 'Pending'),
            Tab(text: 'Sent'),
            Tab(text: 'PDF'),
            Tab(text: 'Settings'),
          ],
        ),
      ),
    );
  }
}
