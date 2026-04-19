// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:node_app/features/profile/presentation/providers/profile_providers.dart';
// import 'profile_tab_widgets.dart';
// import 'package:node_app/core/utils/responsive_size.dart';

// class DashboardTab extends StatelessWidget {
//   DashboardTab({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return RefreshIndicator(
//       onRefresh: () => ref.refresh(userProfileProvider.future),
//       child: SingleChildScrollView(
//         physics: const AlwaysScrollableScrollPhysics(),
//         padding: EdgeInsets.symmetric(vertical: 20.h),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 16.h),
//             ProfileActionTile(
//               title: 'Settings',
//               icon: Icons.settings_outlined,
//               onTap: () => context.pushNamed('settings'),
//             ),
//             SizedBox(height: 40.h),
//           ],
//         ),
//       ),
//     );
//   }
// }
