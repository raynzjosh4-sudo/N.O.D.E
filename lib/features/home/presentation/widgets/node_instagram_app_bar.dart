import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/core/utils/responsive_size.dart';

class NodeAppBar extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;
  final List<Widget>? actions;

  NodeAppBar({super.key, required this.title, this.onBack, this.actions});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return SliverAppBar(
      backgroundColor: theme.appBarTheme.backgroundColor,
      elevation: 0,
      pinned: false,
      floating: true,
      snap: true,
      centerTitle: false, // Instagram style: title on left
      leading: onBack != null
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20.w,
                color: onSurface,
              ),
              onPressed: onBack,
            )
          : null,
      title: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 22.sp,
          fontWeight: FontWeight.w900,
          color: onSurface,
          letterSpacing: -0.5,
        ),
      ),
      actions: actions ?? [],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(1.0),
        child: Container(color: onSurface.withOpacity(0.05), height: 1.0.h),
      ),
    );
  }
}
