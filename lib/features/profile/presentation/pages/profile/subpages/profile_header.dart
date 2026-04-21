import 'package:flutter/material.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:go_router/go_router.dart';

class ProfileHeader extends StatelessWidget {
  final String? profilePicUrl;
  final String fullName;
  final String legalName;
  final IconData? actionIcon;
  final VoidCallback? onActionTap;

  const ProfileHeader({
    super.key,
    this.profilePicUrl,
    required this.fullName,
    required this.legalName,
    this.actionIcon,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Avatar (Top Left)
          Container(
            width: 38.w,
            height: 38.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: theme.primaryColor,
                width: 1.5.w,
              ),
              image: profilePicUrl != null
                  ? DecorationImage(
                      image: NetworkImage(profilePicUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: profilePicUrl == null
                ? Icon(
                    Icons.person_rounded,
                    size: 20.w,
                    color: onSurface.withOpacity(0.3),
                  )
                : null,
          ),

          // Name (Top Center)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                fullName,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                legalName,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: onSurface.withOpacity(0.5),
                ),
              ),
            ],
          ),

          // Dynamic Action Button (Top Right)
          GestureDetector(
            onTap: onActionTap ?? () => context.pop(),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Container(
                key: ValueKey(actionIcon ?? Icons.close_rounded),
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: (actionIcon != null && actionIcon != Icons.close_rounded)
                      ? theme.primaryColor
                      : onSurface.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  actionIcon ?? Icons.close_rounded,
                  size: 24.w,
                  color: (actionIcon != null && actionIcon != Icons.close_rounded)
                      ? Colors.black
                      : onSurface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
