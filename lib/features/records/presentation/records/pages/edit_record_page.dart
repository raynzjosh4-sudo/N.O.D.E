import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import '../../../data/models/main_record_model.dart';
import '../../../data/models/record_detail_model.dart';
import '../../../domain/types/record_types.dart';
import 'package:node_app/features/records/presentation/providers/records_provider.dart';
import 'package:node_app/features/showcase/presentation/services/node_toast_manager.dart';
import 'package:node_app/features/showcase/presentation/widgets/node_toast.dart';

class EditRecordPage extends ConsumerStatefulWidget {
  final MainRecordModel record;
  final bool isNew;

  const EditRecordPage({super.key, required this.record, this.isNew = false});

  static void show(
    BuildContext context,
    MainRecordModel record, {
    bool isNew = false,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          top: 60.0,
        ), // Padding to avoid covering top perfectly
        child: EditRecordPage(record: record, isNew: isNew),
      ),
    );
  }

  @override
  ConsumerState<EditRecordPage> createState() => _EditRecordPageState();
}

class _EditRecordPageState extends ConsumerState<EditRecordPage> {
  late TextEditingController _nameController;
  late TextEditingController _itemController;
  late TextEditingController _unitController;
  late TextEditingController _tagController;
  late TextEditingController _targetValueController;
  late RecordType _type;

  @override
  void initState() {
    super.initState();
    final detail = widget.record.detail;
    _nameController = TextEditingController(text: detail?.contactName ?? '');
    _itemController = TextEditingController(text: detail?.itemName ?? '');
    _unitController = TextEditingController(text: detail?.unit ?? '');
    _tagController = TextEditingController(text: detail?.referenceTag ?? '');
    _targetValueController = TextEditingController(
      text: (detail?.targetValue ?? 0).toStringAsFixed(0),
    );
    _type = detail?.type ?? RecordType.standard;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _itemController.dispose();
    _unitController.dispose();
    _tagController.dispose();
    _targetValueController.dispose();
    super.dispose();
  }

  void _save() {
    final updatedDetail = RecordDetailModel(
      contactName: _nameController.text,
      itemName: _itemController.text,
      unit: _unitController.text,
      referenceTag: _tagController.text,
      targetValue:
          double.tryParse(_targetValueController.text) ??
          (widget.record.detail?.targetValue ?? 0),
      currentValue: widget.record.detail?.currentValue ?? 0,
      type: _type,
      contactImageUrl: widget.record.detail?.contactImageUrl,
    );

    final updatedRecord = widget.record.copyWith(detail: updatedDetail);

    if (widget.isNew) {
      ref.read(recordsProvider.notifier).addRecord(updatedRecord);
    } else {
      ref.read(recordsProvider.notifier).updateRecord(updatedRecord);
    }
    Navigator.pop(context);

    NodeToastManager.show(
      context,
      title: widget.isNew ? 'Record Created' : 'Record Updated',
      message: widget.isNew
          ? 'New record has been created successfully.'
          : 'Administrative details have been successfully modified.',
      status: NodeToastStatus.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = _type == RecordType.credit
        ? Colors.greenAccent
        : _type == RecordType.debt
        ? Colors.orangeAccent
        : Colors.cyanAccent;

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
      child: Column(
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

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.isNew
                      ? 'NEW RECORD'
                      : (_nameController.text.isEmpty
                                ? 'EDIT RECORD'
                                : _nameController.text)
                            .toUpperCase(),
                  style: GoogleFonts.outfit(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    color: accentColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── GENERAL INFO SECTION ──────────────────
                  _SectionHeader(
                    title: 'General Information',
                    icon: Icons.person_outline_rounded,
                    accentColor: accentColor,
                  ),
                  SizedBox(height: 16.h),
                  _NodeTextField(
                    controller: _nameController,
                    label: 'Title',
                    hint: 'e.g. Jane Shop',
                    accentColor: accentColor,
                  ),

                  SizedBox(height: 40.h),

                  // ── CONFIGURATION SECTION ──────────────────
                  _SectionHeader(
                    title: 'Configuration',
                    icon: Icons.tune_rounded,
                    accentColor: accentColor,
                  ),
                  SizedBox(height: 16.h),

                  _Label(text: 'Record Type'),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: _SelectionButton(
                          title: 'Credit',
                          isSelected: _type == RecordType.credit,
                          onTap: () =>
                              setState(() => _type = RecordType.credit),
                          activeColor: Colors.greenAccent,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: _SelectionButton(
                          title: 'Standard',
                          isSelected: _type == RecordType.standard,
                          onTap: () =>
                              setState(() => _type = RecordType.standard),
                          activeColor: Colors.cyanAccent,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: _SelectionButton(
                          title: 'Debt',
                          isSelected: _type == RecordType.debt,
                          onTap: () => setState(() => _type = RecordType.debt),
                          activeColor: Colors.orangeAccent,
                        ),
                      ),
                    ],
                  ),

                  if (_type == RecordType.standard) ...[
                    SizedBox(height: 24.h),
                    _NodeTextField(
                      controller: _targetValueController,
                      label: 'Total Target',
                      hint: '0',
                      keyboardType: TextInputType.number,
                      accentColor: accentColor,
                    ),
                  ],

                  SizedBox(height: 48.h),

                  ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: Colors.black,
                      minimumSize: Size(double.infinity, 56.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      widget.isNew ? 'CREATE RECORD' : 'SAVE CHANGES',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w900,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color accentColor;

  const _SectionHeader({
    required this.title,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: accentColor, size: 20.w),
        SizedBox(width: 12.w),
        Text(
          title.toUpperCase(),
          style: GoogleFonts.outfit(
            fontSize: 12.sp,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.outfit(
        fontSize: 14.sp,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
      ),
    );
  }
}

class _NodeTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType keyboardType;
  final Color accentColor;

  const _NodeTextField({
    required this.controller,
    required this.label,
    required this.hint,
    this.keyboardType = TextInputType.text,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Label(text: label),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.2),
            ),
            filled: true,
            fillColor: theme.colorScheme.onSurface.withOpacity(0.04),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 16.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(
                color: theme.colorScheme.onSurface.withOpacity(0.05),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: accentColor.withOpacity(0.5)),
            ),
          ),
        ),
      ],
    );
  }
}

class _SelectionButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final Color activeColor;

  const _SelectionButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 48.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor
              : theme.colorScheme.onSurface.withOpacity(0.04),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected
                ? activeColor
                : theme.colorScheme.onSurface.withOpacity(0.05),
          ),
        ),
        child: Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            color: isSelected ? Colors.black : theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
