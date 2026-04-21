import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/features/records/data/models/main_record_model.dart';
import 'package:node_app/features/records/domain/types/record_types.dart';
import 'package:node_app/features/showcase/presentation/services/node_toast_manager.dart';
import 'package:node_app/features/records/presentation/providers/records_provider.dart';
import 'package:node_app/features/showcase/presentation/widgets/node_toast.dart';
import 'package:node_app/core/theme/app_theme.dart';

class AddRecordSheet extends ConsumerStatefulWidget {
  final MainRecordModel? record;

  const AddRecordSheet({super.key, this.record});

  static void show(BuildContext context, {MainRecordModel? record}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddRecordSheet(record: record),
    );
  }

  @override
  ConsumerState<AddRecordSheet> createState() => _AddRecordSheetState();
}

class _AddRecordSheetState extends ConsumerState<AddRecordSheet> {
  final _totalController = TextEditingController();
  final _messageController = TextEditingController();
  TrackingMode _selectedMode = TrackingMode.inventory;

  void _submit() {
    if (_totalController.text.isEmpty || widget.record == null) {
      NodeToastManager.show(
        context,
        title: 'Missing Total',
        message: 'Please enter the total for this entry.',
        status: NodeToastStatus.error,
      );
      return;
    }

    final amount = double.tryParse(_totalController.text) ?? 0;

    ref
        .read(recordsProvider.notifier)
        .addEntry(
          widget.record!.id,
          amount,
          note: _messageController.text,
          isReduce: _selectedMode == TrackingMode.balance,
        );

    Navigator.pop(context);

    NodeToastManager.show(
      context,
      title: 'Success',
      message: 'Successfully updated the record flow.',
      status: NodeToastStatus.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = AppColors.of(context);
    final detail = widget.record?.detail;
    final accentColor = detail?.type == RecordType.credit
        ? appColors.marginGreen
        : detail?.type == RecordType.debt
        ? appColors.moqOrange
        : (detail?.type == RecordType.standard
              ? appColors.accentCyan
              : theme.colorScheme.primary);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
      ),
      padding: EdgeInsets.fromLTRB(
        24.w,
        12.h,
        24.w,
        24.h + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withOpacity(0.1),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Add New Record',
              style: GoogleFonts.outfit(
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 24.h),

            // Tracking Mode Selection
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withOpacity(0.04),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _ModeButton(
                      title: 'Add',
                      isSelected: _selectedMode == TrackingMode.inventory,
                      accentColor: accentColor,
                      onTap: () => setState(
                        () => _selectedMode = TrackingMode.inventory,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _ModeButton(
                      title: 'Reduce',
                      isSelected: _selectedMode == TrackingMode.balance,
                      accentColor: accentColor,
                      onTap: () =>
                          setState(() => _selectedMode = TrackingMode.balance),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // Transaction Total Input
            _buildTextField(
              context,
              controller: _totalController,
              label: 'Total',
              hint: 'Enter the value',
              icon: Icons.add_chart_rounded,
              keyboardType: TextInputType.number,
              accentColor: accentColor,
            ),
            SizedBox(height: 12.h),

            // Message / Description Input
            _buildTextField(
              context,
              controller: _messageController,
              label: 'Message',
              hint: 'What is this for? (Optional)',
              icon: Icons.notes_rounded,
              maxLines: 3,
              accentColor: accentColor,
            ),
            SizedBox(height: 32.h),

            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: Colors.black,
                minimumSize: Size(double.infinity, 54.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.r),
                ),
                elevation: 0,
              ),
              child: Text(
                'Start Tracking',
                style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    required Color accentColor,
  }) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface.withOpacity(0.4),
          ),
        ),
        SizedBox(height: 6.h),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.2),
            ),
            prefixIcon: Icon(icon, size: 20.w, color: accentColor),
            filled: true,
            fillColor: theme.colorScheme.onSurface.withOpacity(0.04),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final Color accentColor;

  const _ModeButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? accentColor : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: isSelected
                    ? Colors.black
                    : theme.colorScheme.onSurface.withOpacity(0.3),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// _ModeButton and other helpers remain below
