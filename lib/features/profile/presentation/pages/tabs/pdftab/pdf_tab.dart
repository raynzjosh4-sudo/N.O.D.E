import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/features/profile/domain/entities/pdf_document.dart';
import 'package:node_app/features/profile/presentation/providers/pdf_providers.dart';
import 'package:intl/intl.dart';
import '../profile_tab_widgets.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/core/widgets/node_error_state.dart';

class PdfTab extends ConsumerWidget {
  const PdfTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final docsAsync = ref.watch(userPdfsProvider);

    return docsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => NodeErrorState(
        error: e,
        onRetry: () => ref.refresh(userPdfsProvider),
      ),
      data: (docs) {
        return RefreshIndicator(
          onRefresh: () => ref.refresh(userPdfsProvider.future),
          child: docs.isEmpty
              ? SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    alignment: Alignment.center,
                    child: ProfilePlaceholderView(
                      title: 'No PDFs yet',
                      subtitle:
                          'Open an order sheet and tap "Download PDF" to generate one.',
                    ),
                  ),
                )
              : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    return _PdfDocumentTile(
                      doc: doc,
                      onTap: () {
                        context.push('/pdf-viewer', extra: doc);
                      },
                    );
                  },
                ),
        );
      },
    );
  }
}

class _PdfDocumentTile extends StatelessWidget {
  final PdfDocument doc;
  final VoidCallback onTap;

  const _PdfDocumentTile({required this.doc, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final primary = theme.primaryColor;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: onSurface.withOpacity(0.05), width: 1.w),
          ),
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: primary.withOpacity(0.07),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Icon(
                  Icons.picture_as_pdf_rounded,
                  color: primary,
                  size: 24.w,
                ),
              ),
            ),
            SizedBox(width: 16.w),

            // Title + meta
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doc.title,
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      _TypeBadge(type: 'PDF'),
                      SizedBox(width: 8.w),
                      Text(
                        '${DateFormat('MMM dd, yyyy').format(doc.updatedAt)} · ${doc.fileSize}',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: onSurface.withOpacity(0.4),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Arrow
            Icon(
              Icons.chevron_right_rounded,
              color: onSurface.withOpacity(0.2),
              size: 20.w,
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  final String type;
  const _TypeBadge({required this.type});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        type,
        style: TextStyle(
          color: primary,
          fontSize: 9.sp,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
