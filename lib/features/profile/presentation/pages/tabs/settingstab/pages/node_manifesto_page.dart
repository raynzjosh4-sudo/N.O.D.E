import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:node_app/core/utils/responsive_size.dart';

class NodeManifestoPage extends StatelessWidget {
  const NodeManifestoPage({super.key});

  static void show(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NodeManifestoPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final primary = theme.primaryColor;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: [
          // ── Premium App Bar ─────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.chevron_left_rounded,
                color: onSurface,
                size: 28.w,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 16.h,
              ),
              centerTitle: false,
              title: Text(
                "N.O.D.E",
                style: GoogleFonts.outfit(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                  color: onSurface,
                ),
              ),
              background: Container(
                color: primary.withOpacity(0.03),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icon/nodeicon.svg',
                    width: 60.w,
                    height: 60.h,
                  ),
                ),
              ),
            ),
          ),

          // ── Manifesto Content ───────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildIntro(context),
                  SizedBox(height: 48.h),

                  _buildManifestoSection(
                    context,
                    emoji: '🇺🇬',
                    letter: 'N',
                    word: 'NATIONAL',
                    tagline: '“The Infrastructure of the Country.”',
                    bullets: [
                      '**N**etwork of **A**ccess: Connecting every district, from Kampala to the furthest border.',
                      '**T**rade **I**ntegration: Standardizing how Uganda does business with the world.',
                      '**O**utreach & **N**eighborhoods: Ensuring even the smallest micro-shop in a village is part of the system.',
                      '**A**ll-inclusive **L**egacy: Building a system that lasts for the next generation of Ugandan traders.',
                    ],
                  ),

                  _buildManifestoSection(
                    context,
                    emoji: '📦',
                    letter: 'O',
                    word: 'ORDER',
                    tagline: '“The Precision of the Engine.”',
                    bullets: [
                      '**O**ptimized **R**esourcing: Ensuring no stock is ever wasted and every net is accounted for.',
                      '**D**igital **E**fficiency: Moving away from paper receipts to real-time, cloud-synced data.',
                      '**R**eliability: A guarantee that when a shop owner taps "Buy," the goods exist and the price is locked.',
                    ],
                  ),

                  _buildManifestoSection(
                    context,
                    emoji: '🚚',
                    letter: 'D',
                    word: 'DISTRIBUTION',
                    tagline: '“The Muscle of the Movement.”',
                    bullets: [
                      '**D**irect **I**ntegrated **S**upply: Cutting out the expensive middlemen to lower prices for locals.',
                      '**T**racking & **R**oute **I**ntelligence: Using AI to find the fastest way to get a truck from Namanve to Mbarara.',
                      '**B**ulk **U**tilization: Maximizing every cubic meter of space in every taxi and truck.',
                      '**T**ransport **I**nnovation: Using QR-code handoffs to ensure zero theft during delivery.',
                      '**O**utbound **N**etworking: Building a web of drivers that covers the "last mile" to the shop door.',
                    ],
                  ),

                  _buildManifestoSection(
                    context,
                    emoji: '💱',
                    letter: 'E',
                    word: 'EXCHANGE',
                    tagline: '“The Flow of the Capital.”',
                    bullets: [
                      '**E**conomic **X**-border: Bridging the gap between the Chinese Yuan (factory) and the Ugandan Shilling (retailer).',
                      '**C**apital **H**ub: A central place where money is held in Escrow, protecting both the buyer and the seller.',
                      '**A**sset **N**etwork: Turning physical inventory into digital data that can be used for credit and loans.',
                      '**G**rowth **E**ngine: A system designed not just to trade, but to multiply the wealth of every shop owner on the platform.',
                    ],
                  ),

                  SizedBox(height: 60.h),
                  _buildSoulFooter(context),
                  SizedBox(height: 80.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntro(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Text(
      'N.O.D.E is a system for a nation\'s commerce. We believe in building the bridge between the factory, suppliers and the final shop door.',
      style: GoogleFonts.plusJakartaSans(
        fontSize: 15.sp,
        height: 1.6.h,
        fontWeight: FontWeight.w500,
        color: onSurface.withOpacity(0.7),
      ),
    );
  }

  Widget _buildManifestoSection(
    BuildContext context, {
    required String emoji,
    required String letter,
    required String word,
    required String tagline,
    required List<String> bullets,
  }) {
    final primary = Theme.of(context).primaryColor;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Padding(
      padding: EdgeInsets.only(bottom: 48.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(emoji, style: TextStyle(fontSize: 24.sp)),
              SizedBox(width: 12.w),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$letter - ',
                      style: GoogleFonts.outfit(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w900,
                        color: primary,
                      ),
                    ),
                    TextSpan(
                      text: word,
                      style: GoogleFonts.outfit(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w900,
                        color: onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            tagline,
            style: GoogleFonts.outfit(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
              color: onSurface.withOpacity(0.4),
            ),
          ),
          SizedBox(height: 20.h),
          ...bullets
              .map((bullet) => _buildBulletPoint(context, bullet))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(BuildContext context, String text) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final primary = Theme.of(context).primaryColor;

    // Split for simple bold markdown
    final parts = text.split('**');

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h, left: 4.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 8.h),
            width: 4.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: primary.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.sp,
                  height: 1.5.h,
                  color: onSurface.withOpacity(0.8),
                ),
                children: parts.asMap().entries.map((entry) {
                  final index = entry.key;
                  final content = entry.value;
                  return TextSpan(
                    text: content,
                    style: TextStyle(
                      fontWeight: index % 2 == 1
                          ? FontWeight.w800
                          : FontWeight.w500,
                      color: index % 2 == 1
                          ? onSurface
                          : onSurface.withOpacity(0.8),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoulFooter(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: primary.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'THE SOUL OF THE BUSINESS',
            style: GoogleFonts.outfit(
              fontSize: 11.sp,
              fontWeight: FontWeight.w900,
              color: primary,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'This manifesto defines our architecture. From HS Codes to Escrow Wallets, every feature we build is designed to empower the National Exchange of Uganda.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.sp,
              height: 1.6.h,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
