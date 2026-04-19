import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/core/database/app_database.dart';
import 'package:node_app/core/database/database_provider.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/core/utils/seed_data_service.dart';
import 'package:node_app/core/error/failure.dart';
import 'package:node_app/features/profile/presentation/providers/legal_providers.dart';
import 'package:node_app/features/showcase/presentation/services/node_toast_manager.dart';
import 'package:node_app/features/showcase/presentation/widgets/node_toast.dart';

class LegalTermsPage extends ConsumerStatefulWidget {
  final String termId;
  final String fallbackTitle;

  const LegalTermsPage({
    super.key,
    required this.termId,
    required this.fallbackTitle,
  });

  static void show(
    BuildContext context, {
    required String termId,
    required String title,
  }) async {
    // 🌐 Central Redirection: Launch the external N.O.D.E legal portal
    try {
      await launchUrl(
        Uri.parse('https://raynzjosh4-sudo.github.io/N.O.D.E.T/'),
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      if (context.mounted) {
        NodeToastManager.show(
          context,
          title: 'Portal Error',
          message:
              'Unable to open the legal portal. Please check your browser.',
          status: NodeToastStatus.error,
        );
      }
    }
  }

  @override
  ConsumerState<LegalTermsPage> createState() => _LegalTermsPageState();
}

class _LegalTermsPageState extends ConsumerState<LegalTermsPage> {
  LegalTermEntry? _term;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadTerm();
  }

  Future<void> _loadTerm() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final db = ref.read(databaseProvider);

    // Show any locally cached version instantly as a preview while we fetch
    final cached = await (db.select(
      db.legalTermsTable,
    )..where((t) => t.id.equals(widget.termId))).getSingleOrNull();
    if (cached != null && mounted) {
      setState(() => _term = cached);
    }

    // ALWAYS fetch fresh from Supabase — overrides any stale/hardcoded local data
    print('🌐 [LegalTermsPage] Syncing "${widget.termId}" from Supabase...');
    try {
      final repository = ref.read(legalTermsRepositoryProvider);
      await SeedDataService.syncLegalFromRemote(db, repository);

      // Re-query after sync — this has the real Supabase content
      final fresh = await (db.select(
        db.legalTermsTable,
      )..where((t) => t.id.equals(widget.termId))).getSingleOrNull();

      if (mounted) {
        setState(() {
          _term = fresh;
          _isLoading = false;
          if (fresh == null) {
            _errorMessage = 'Policy not found in the N.O.D.E registry.';
          }
        });
      }
    } catch (e) {
      print('❌ [LegalTermsPage] Supabase sync failed: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          // Keep showing cached data if available; otherwise show error
          if (_term == null) {
            _errorMessage = Failure.fromException(e).toFriendlyMessage();
          }
        });
      }
    }
  }

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
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.chevron_left_rounded, color: onSurface, size: 28.w),
        ),
        title: Text(
          widget.fallbackTitle,
          style: GoogleFonts.outfit(
            fontSize: 18.sp,
            fontWeight: FontWeight.w900,
            color: onSurface,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _isLoading ? null : _loadTerm,
            icon: Icon(Icons.refresh_rounded, color: onSurface),
            tooltip: 'Refresh from cloud',
          ),
        ],
      ),
      body: _buildBody(context, theme, onSurface),
    );
  }

  Widget _buildBody(BuildContext context, ThemeData theme, Color onSurface) {
    // Loading state — show spinner (with preview if cached data available)
    if (_isLoading && _term == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            SizedBox(height: 16.h),
            Text(
              'Loading from cloud...',
              style: GoogleFonts.outfit(
                fontSize: 14.sp,
                color: onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      );
    }

    // Error state — no cached data and cloud failed
    if (_errorMessage != null && _term == null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_off_rounded,
                size: 48.w,
                color: theme.colorScheme.error.withValues(alpha: 0.5),
              ),
              SizedBox(height: 16.h),
              Text(
                'Unable to Load Terms',
                style: GoogleFonts.outfit(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 13.sp,
                  color: onSurface.withValues(alpha: 0.6),
                ),
              ),
              SizedBox(height: 24.h),
              ElevatedButton.icon(
                onPressed: _loadTerm,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Content state
    final term = _term!;
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Loading indicator at top while refreshing in background
          if (_isLoading) LinearProgressIndicator(color: theme.primaryColor),

          SizedBox(height: 8.h),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'OFFICIAL POLICY',
                  style: GoogleFonts.outfit(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w900,
                    color: theme.primaryColor,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                'Updated: ${term.updatedAt.day}/${term.updatedAt.month}/${term.updatedAt.year}',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: onSurface.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Text(
            term.title,
            style: GoogleFonts.outfit(
              fontSize: 24.sp,
              fontWeight: FontWeight.w900,
              color: onSurface,
            ),
          ),
          SizedBox(height: 32.h),
          ...term.content.split('\n').map((line) {
            if (line.startsWith('### ')) {
              return Padding(
                padding: EdgeInsets.only(top: 24.h, bottom: 8.h),
                child: Text(
                  line.replaceFirst('### ', ''),
                  style: GoogleFonts.outfit(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: onSurface,
                  ),
                ),
              );
            } else if (line.startsWith('# ')) {
              return const SizedBox.shrink(); // Title already shown above
            }
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Text(
                line,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14.sp,
                  color: onSurface.withValues(alpha: 0.7),
                  height: 1.6,
                ),
              ),
            );
          }),
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}
