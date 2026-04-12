import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/core/utils/responsive_size.dart';

class DeleteConfirmationResult {
  final bool confirmDelete;
  final bool deletePdfs;

  DeleteConfirmationResult({
    required this.confirmDelete,
    required this.deletePdfs,
  });
}

class NodeDeleteConfirmationSheet extends StatefulWidget {
  final int orderCount;
  final bool hasPdfs;

  const NodeDeleteConfirmationSheet({
    super.key,
    required this.orderCount,
    required this.hasPdfs,
  });

  static Future<DeleteConfirmationResult?> show(
    BuildContext context, {
    required int orderCount,
    required bool hasPdfs,
  }) {
    return showModalBottomSheet<DeleteConfirmationResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NodeDeleteConfirmationSheet(
        orderCount: orderCount,
        hasPdfs: hasPdfs,
      ),
    );
  }

  @override
  State<NodeDeleteConfirmationSheet> createState() =>
      _NodeDeleteConfirmationSheetState();
}

class _NodeDeleteConfirmationSheetState
    extends State<NodeDeleteConfirmationSheet> {
  bool _deletePdfs = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final primary = theme.primaryColor;

    return Container(
      padding: EdgeInsets.fromLTRB(
        24.w,
        24.h,
        24.w,
        MediaQuery.of(context).padding.bottom + 24.h,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Confirm Deletion',
                style: GoogleFonts.outfit(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w900,
                  color: onSurface,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.close_rounded,
                  color: onSurface.withOpacity(0.3),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Text(
            'You are about to delete ${widget.orderCount} order${widget.orderCount > 1 ? 's' : ''} from your registry. This action cannot be undone.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: onSurface.withOpacity(0.6),
              height: 1.5,
            ),
          ),
          if (widget.hasPdfs) ...[
            SizedBox(height: 8.h),
            Row(
              children: [
                Container(
                  width: 32.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.picture_as_pdf_rounded,
                    color: primary,
                    size: 16.w,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Delete associated PDFs?',
                        style: GoogleFonts.outfit(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: onSurface,
                        ),
                      ),
                      Text(
                        'Removes physical files from storage.',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: onSurface.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                ),
                Transform.scale(
                  scale: 0.7,
                  alignment: Alignment.centerRight,
                  child: Switch.adaptive(
                    value: _deletePdfs,
                    activeColor: primary,
                    onChanged: (val) => setState(() => _deletePdfs = val),
                  ),
                ),
              ],
            ),
          ],
          SizedBox(height: 32.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 18.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    side: BorderSide(color: onSurface.withOpacity(0.1)),
                  ),
                  child: Text(
                    'CANCEL',
                    style: GoogleFonts.outfit(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w800,
                      color: onSurface.withOpacity(0.5),
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                      DeleteConfirmationResult(
                        confirmDelete: true,
                        deletePdfs: _deletePdfs && widget.hasPdfs,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 18.h),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  child: Text(
                    'DELETE PERMANENTLY',
                    style: GoogleFonts.outfit(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
