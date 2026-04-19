import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileBody;
  final Widget desktopBody;
  final Widget? tabletBody;

  const ResponsiveLayout({
    super.key,
    required this.mobileBody,
    required this.desktopBody,
    this.tabletBody,
  });

  /// Standard breakpoints
  static const double mobileLimit = 650;
  static const double tabletLimit = 1100;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileLimit;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobileLimit &&
      MediaQuery.of(context).size.width < tabletLimit;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletLimit;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= tabletLimit) {
          return desktopBody;
        } else if (constraints.maxWidth >= mobileLimit && tabletBody != null) {
          return tabletBody!;
        } else {
          // Default to mobile for small screens or tablet if no tablet body provided
          return mobileBody;
        }
      },
    );
  }
}
