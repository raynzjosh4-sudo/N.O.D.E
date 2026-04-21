import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/features/records/data/models/main_record_model.dart';
import 'package:node_app/features/records/presentation/providers/records_provider.dart';
import 'package:node_app/features/showcase/presentation/services/node_toast_manager.dart';
import 'package:node_app/features/showcase/presentation/widgets/node_toast.dart';
import 'package:node_app/core/theme/app_theme.dart';
import '../../../domain/types/record_types.dart';

class PaymentDialog extends ConsumerStatefulWidget {
  final MainRecordModel record;

  const PaymentDialog({super.key, required this.record});

  static Future<void> show(BuildContext context, MainRecordModel record) {
    return showDialog(
      context: context,
      builder: (context) => PaymentDialog(record: record),
    );
  }

  @override
  ConsumerState<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends ConsumerState<PaymentDialog> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submit() {
    final amount = double.tryParse(_amountController.text.trim()) ?? 0;
    if (amount <= 0) {
      NodeToastManager.show(
        context,
        title: 'Input Error',
        message: 'Please enter a valid number.',
        status: NodeToastStatus.error,
      );
      return;
    }

    ref
        .read(recordsProvider.notifier)
        .addEntry(widget.record.id, amount, note: _noteController.text.trim());

    Navigator.pop(context);

    final detail = widget.record.detail;

    NodeToastManager.show(
      context,
      title: 'Record Updated',
      message:
          'Added $amount ${detail?.unit ?? "Units"} to ${detail?.itemName ?? "Record"}.',
      status: NodeToastStatus.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final appColors = AppColors.of(context);
    final detail = widget.record.detail;
    final unit = detail?.unit ?? 'Units';
    final itemName = detail?.itemName ?? 'Item';

    final accentColor = detail?.type == RecordType.credit
        ? appColors.marginGreen
        : detail?.type == RecordType.debt
        ? appColors.moqOrange
        : appColors.accentCyan;

    return AlertDialog(
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      title: Text(
        'Add $itemName',
        style: GoogleFonts.outfit(
          fontWeight: FontWeight.w800,
          color: accentColor,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Quantity ($unit)',
              hintText: 'e.g. 50',
              prefixIcon: const Icon(Icons.add_task_rounded),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          TextField(
            controller: _noteController,
            decoration: InputDecoration(
              labelText: 'Note (Optional)',
              hintText: 'e.g. Morning collection',
              prefixIcon: const Icon(Icons.notes_rounded),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: accentColor,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
