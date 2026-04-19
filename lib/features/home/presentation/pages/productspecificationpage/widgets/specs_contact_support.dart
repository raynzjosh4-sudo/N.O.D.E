import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/features/inventory/domain/entities/product_attributes.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:url_launcher/url_launcher.dart';

class SpecsContactSupport extends StatelessWidget {
  final ProductSupport support;

  const SpecsContactSupport({super.key, required this.support});

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        debugPrint('Could not launch $url');
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }

  void _contactWhatsApp(String number) {
    // Clean the number: remove spaces, +, and -
    final cleanNumber = number.replaceAll(RegExp(r'[^0-9]'), '');
    _launchUrl('https://wa.me/$cleanNumber');
  }

  void _contactPhone(String number) {
    final cleanNumber = number.replaceAll(RegExp(r'[^0-9+]'), '');
    _launchUrl('tel:$cleanNumber');
  }

  void _contactEmail(String email) {
    _launchUrl('mailto:$email');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0.w),
          child: Text(
            'Merchant Support',
            style: GoogleFonts.outfit(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: onSurface.withOpacity(0.25),
              letterSpacing: 1.2,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(color: theme.cardColor),
          child: Column(
            children: [
              // Table Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildTableHeader(context, 'CHANNEL'),
                    ),
                    Expanded(
                      flex: 4,
                      child: _buildTableHeader(context, 'CONTACT INFO'),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 1.h,
                thickness: 1,
                color: theme.dividerColor.withOpacity(0.05),
              ),

              // Support Rows using Dynamic Data
              _buildSupportTableRow(
                context,
                'WHATSAPP',
                support.whatsapp,
                onTap: () => _contactWhatsApp(support.whatsapp),
              ),
              _buildSupportTableRow(
                context,
                'CALLS',
                support.phone,
                onTap: () => _contactPhone(support.phone),
              ),
              _buildSupportTableRow(
                context,
                'EMAIL',
                support.email,
                onTap: () => _contactEmail(support.email),
                isLast: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTableHeader(BuildContext context, String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 10.sp,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.25),
      ),
    );
  }

  Widget _buildSupportTableRow(
    BuildContext context,
    String channel,
    String info, {
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    channel,
                    style: GoogleFonts.outfit(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: onSurface.withOpacity(0.25),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Text(
                    info,
                    style: GoogleFonts.outfit(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: onSurface.withOpacity(0.85),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (!isLast)
            Divider(
              height: 1.h,
              thickness: 1,
              color: theme.dividerColor.withOpacity(0.05),
            ),
        ],
      ),
    );
  }
}
