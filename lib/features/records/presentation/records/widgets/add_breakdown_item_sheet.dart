import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/features/records/presentation/providers/records_provider.dart';
import 'package:node_app/features/records/data/models/record_data_model.dart';
import 'package:node_app/features/showcase/presentation/services/node_toast_manager.dart';
import 'package:node_app/features/showcase/presentation/widgets/node_toast.dart';

class AddBreakdownItemSheet extends ConsumerStatefulWidget {
  final String recordId;
  final Color accentColor;

  const AddBreakdownItemSheet({
    super.key,
    required this.recordId,
    required this.accentColor,
  });

  static void show(
    BuildContext context, {
    required String recordId,
    required Color accentColor,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          AddBreakdownItemSheet(recordId: recordId, accentColor: accentColor),
    );
  }

  @override
  ConsumerState<AddBreakdownItemSheet> createState() =>
      _AddBreakdownItemSheetState();
}

class _AddBreakdownItemSheetState extends ConsumerState<AddBreakdownItemSheet> {
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _amountController = TextEditingController();

  void _submit() {
    if (_nameController.text.isEmpty || _amountController.text.isEmpty) {
      NodeToastManager.show(
        context,
        title: 'Missing Details',
        message: 'Please enter the item name and total amount.',
        status: NodeToastStatus.error,
      );
      return;
    }

    final quantity = int.tryParse(_quantityController.text) ?? 1;
    final amount = double.tryParse(_amountController.text) ?? 0;

    final item = RecordBreakdownItemModel(
      quantity: quantity,
      name: _nameController.text.trim(),
      amount: amount,
    );

    ref.read(recordsProvider.notifier).addBreakdownItem(widget.recordId, item);
    Navigator.pop(context);

    NodeToastManager.show(
      context,
      title: 'Item Added',
      message: 'Successfully added the item to your record.',
      status: NodeToastStatus.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Add Breakdown Item',
              style: GoogleFonts.outfit(
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
                color: widget.accentColor,
              ),
            ),
            SizedBox(height: 24.h),

            // Item Name Input
            _buildTextField(
              context,
              controller: _nameController,
              label: 'Item Name',
              hint: 'e.g. Premium Steel',
              icon: Icons.inventory_2_rounded,
            ),
            SizedBox(height: 16.h),

            // Quantity and Amount row
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildTextField(
                    context,
                    controller: _quantityController,
                    label: 'Quantity',
                    hint: '1',
                    icon: Icons.numbers_rounded,
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  flex: 3,
                  child: _buildTextField(
                    context,
                    controller: _amountController,
                    label: 'Total Amount',
                    hint: '0',
                    icon: Icons.payments_rounded,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),

            SizedBox(height: 32.h),

            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.accentColor,
                foregroundColor: Colors.black,
                minimumSize: Size(double.infinity, 54.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.r),
                ),
                elevation: 0,
              ),
              child: Text(
                'ADD ITEM',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w900,
                  fontSize: 16.sp,
                ),
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
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.2),
            ),
            prefixIcon: Icon(
              icon,
              size: 20.w,
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
            filled: true,
            fillColor: theme.colorScheme.onSurface.withOpacity(0.04),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: widget.accentColor.withOpacity(0.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
