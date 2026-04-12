import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:share_plus/share_plus.dart';
import 'package:node_app/features/profile/domain/entities/pdf_document.dart' as entity;
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/features/showcase/presentation/services/node_toast_manager.dart';
import 'package:node_app/features/showcase/presentation/widgets/node_toast.dart';

class PdfViewerPage extends StatefulWidget {
  final entity.PdfDocument doc;

  const PdfViewerPage({super.key, required this.doc});

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  final controller = PdfViewerController();

  @override
  void dispose() {
    // PdfViewerController 1.3.5 doesn't have a dispose method
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final primary = theme.primaryColor;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leadingWidth: 64.w,
        leading: Center(
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: onSurface,
              size: 20.w,
            ),
          ),
        ),
        title: Column(
          children: [
            Text(
              widget.doc.title,
              style: GoogleFonts.outfit(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              widget.doc.fileSize,
              style: TextStyle(
                fontSize: 11.sp,
                color: onSurface.withValues(alpha: 0.4),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final file = File(widget.doc.fileUrl);
              if (await file.exists()) {
                await SharePlus.instance.share(
                  ShareParams(
                    files: [XFile(widget.doc.fileUrl)],
                    text: 'Order Sheet: ${widget.doc.title}',
                  ),
                );
              } else {
                if (context.mounted) {
                  NodeToastManager.show(
                    context,
                    title: 'File Not Found',
                    message:
                        'The PDF file could not be located on this device.',
                    status: NodeToastStatus.error,
                  );
                }
              }
            },
            icon: Icon(Icons.ios_share_rounded, color: primary, size: 22.w),
          ),
          SizedBox(width: 8.w),
        ],
        centerTitle: true,
      ),
      body: Container(
        color: onSurface.withValues(alpha: 0.03),
        child: PdfViewer.file(
          widget.doc.fileUrl,
          controller: controller,
          params: PdfViewerParams(
            maxScale: 10.0,
            errorBannerBuilder: (context, error, stackTrace, documentRef) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline_rounded,
                        color: Colors.red, size: 48.w),
                    SizedBox(height: 16.h),
                    Text(
                      'Failed to load PDF',
                      style: GoogleFonts.outfit(
                          fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.h),
                    Text(error.toString(), textAlign: TextAlign.center),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 16.h, right: 8.w),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: onSurface.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: onSurface.withValues(alpha: 0.15),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => controller.zoomUp(),
                icon: Icon(Icons.add_rounded, color: Colors.white, size: 20.w),
                padding: EdgeInsets.all(8.w),
                constraints: const BoxConstraints(),
              ),
              Container(
                height: 14.h,
                width: 1.w,
                color: Colors.white.withValues(alpha: 0.2),
                margin: EdgeInsets.symmetric(horizontal: 4.w),
              ),
              IconButton(
                onPressed: () => controller.zoomDown(),
                icon:
                    Icon(Icons.remove_rounded, color: Colors.white, size: 20.w),
                padding: EdgeInsets.all(8.w),
                constraints: const BoxConstraints(),
              ),
              Container(
                height: 14.h,
                width: 1.w,
                color: Colors.white.withValues(alpha: 0.2),
                margin: EdgeInsets.symmetric(horizontal: 4.w),
              ),
              IconButton(
                onPressed: () => controller.goToPage(pageNumber: 1),
                icon: Icon(Icons.first_page_rounded,
                    color: Colors.white, size: 20.w),
                padding: EdgeInsets.all(8.w),
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
