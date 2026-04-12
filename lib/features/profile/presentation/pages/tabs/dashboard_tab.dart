import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'profile_tab_widgets.dart';
import 'package:node_app/core/utils/responsive_size.dart';

class DashboardTab extends StatelessWidget {
  DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          ProfileActionTile(
            title: 'Settings',
            icon: Icons.settings_outlined,
            onTap: () => context.pushNamed('settings'),
          ),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}
