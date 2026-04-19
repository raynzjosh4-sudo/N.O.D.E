import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:node_app/core/database/app_database.dart';
import 'package:node_app/core/error/failure.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/features/inventory/presentation/providers/trading_terms_notifier.dart';
import 'package:node_app/features/showcase/presentation/services/node_toast_manager.dart';
import 'package:node_app/features/showcase/presentation/widgets/node_toast.dart';

class TradingTermsPage extends ConsumerStatefulWidget {
  const TradingTermsPage({super.key});

  static void show(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TradingTermsPage()),
    );
  }

  @override
  ConsumerState<TradingTermsPage> createState() => _TradingTermsPageState();
}

class _TradingTermsPageState extends ConsumerState<TradingTermsPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final primary = theme.primaryColor;
    final termsState = ref.watch(tradingTermsProvider);

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
          'Trading Terms',
          style: GoogleFonts.outfit(
            fontSize: 18.sp,
            fontWeight: FontWeight.w900,
            color: onSurface,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _showAddEditBottomSheet(context),
            icon: Icon(Icons.add_rounded, color: primary, size: 28.w),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: termsState.when(
        data: (terms) {
          if (terms.isEmpty) {
            return _buildEmptyState(context);
          }
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            itemCount: terms.length,
            itemBuilder: (context, index) {
              final term = terms[index];
              return _buildTermCard(context, term);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(
          child: Text(
            Failure.fromException(e).toFriendlyMessage(),
            style: GoogleFonts.plusJakartaSans(
              color: onSurface.withOpacity(0.5),
              fontSize: 12.sp,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.description_outlined,
            size: 64.w,
            color: theme.colorScheme.onSurface.withOpacity(0.1),
          ),
          SizedBox(height: 16.h),
          Text(
            'No Trading Terms Yet',
            style: GoogleFonts.outfit(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface.withOpacity(0.4),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Add terms like MOQ, Delivery, and Warranty\nto reuse them across your products.',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.sp,
              color: theme.colorScheme.onSurface.withOpacity(0.3),
            ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton.icon(
            onPressed: () => _showAddEditBottomSheet(context),
            icon: const Icon(Icons.add_rounded),
            label: const Text('CREATE FIRST TERM'),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermCard(BuildContext context, TradingTermsEntry term) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: onSurface.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: onSurface.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TEMPLATE',
                style: GoogleFonts.outfit(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w900,
                  color: theme.primaryColor,
                  letterSpacing: 1.2,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () =>
                        _showAddEditBottomSheet(context, term: term),
                    icon: Icon(
                      Icons.edit_outlined,
                      size: 18.w,
                      color: onSurface.withOpacity(0.4),
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                  IconButton(
                    onPressed: () => _confirmDelete(context, term.id),
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      size: 18.w,
                      color: Colors.red.withOpacity(0.4),
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            term.content,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: onSurface,
            ),
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              if (term.moq != null) _buildTag(context, 'MOQ: ${term.moq}'),
              if (term.deliveryTerms != null)
                _buildTag(context, 'Delivery: ${term.deliveryTerms}'),
              if (term.paymentTerms != null)
                _buildTag(context, 'Payment: ${term.paymentTerms}'),
              if (term.warranty != null)
                _buildTag(context, 'Warranty: ${term.warranty}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(BuildContext context, String text) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: onSurface.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
          color: onSurface.withOpacity(0.5),
        ),
      ),
    );
  }

  void _showAddEditBottomSheet(
    BuildContext context, {
    TradingTermsEntry? term,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _TradingTermsForm(term: term),
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Term?'),
        content: const Text(
          'Are you sure you want to delete this trading term template?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              ref.read(tradingTermsProvider.notifier).deleteTerms(id);
              Navigator.pop(context);
              NodeToastManager.show(
                context,
                title: 'Term Deleted',
                message: 'The template has been removed.',
                status: NodeToastStatus.success,
              );
            },
            child: const Text('DELETE', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _TradingTermsForm extends ConsumerStatefulWidget {
  final TradingTermsEntry? term;
  const _TradingTermsForm({this.term});

  @override
  ConsumerState<_TradingTermsForm> createState() => _TradingTermsFormState();
}

class _TradingTermsFormState extends ConsumerState<_TradingTermsForm> {
  final _contentController = TextEditingController();
  final _moqController = TextEditingController();
  final _warrantyController = TextEditingController();
  final _paymentController = TextEditingController();
  final _deliveryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.term != null) {
      _contentController.text = widget.term!.content;
      _moqController.text = widget.term!.moq ?? '';
      _warrantyController.text = widget.term!.warranty ?? '';
      _paymentController.text = widget.term!.paymentTerms ?? '';
      _deliveryController.text = widget.term!.deliveryTerms ?? '';
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    _moqController.dispose();
    _warrantyController.dispose();
    _paymentController.dispose();
    _deliveryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final primary = theme.primaryColor;

    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: onSurface.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              widget.term == null ? 'New Trading Term' : 'Edit Trading Term',
              style: GoogleFonts.outfit(
                fontSize: 20.sp,
                fontWeight: FontWeight.w900,
                color: onSurface,
              ),
            ),
            SizedBox(height: 24.h),
            _buildTextField(
              'Term Name / Quick Content',
              _contentController,
              hint: 'e.g. Standard Wholesale Terms',
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    'MOQ',
                    _moqController,
                    hint: 'e.g. 50 units',
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildTextField(
                    'Warranty',
                    _warrantyController,
                    hint: 'e.g. 6 Months',
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            _buildTextField(
              'Payment Terms',
              _paymentController,
              hint: 'e.g. 50% Advance, 50% Before Delivery',
            ),
            SizedBox(height: 16.h),
            _buildTextField(
              'Delivery Terms',
              _deliveryController,
              hint: 'e.g. Ex-Works Kampala',
            ),
            SizedBox(height: 32.h),
            SizedBox(
              width: double.infinity,
              height: 56.h,
              child: ElevatedButton(
                onPressed: () {
                  if (_contentController.text.isEmpty) {
                    NodeToastManager.show(
                      context,
                      title: 'Required',
                      message: 'Please provide a name or content.',
                      status: NodeToastStatus.warning,
                    );
                    return;
                  }

                  if (widget.term == null) {
                    ref
                        .read(tradingTermsProvider.notifier)
                        .addTerms(
                          moq: _moqController.text,
                          warranty: _warrantyController.text,
                          paymentTerms: _paymentController.text,
                          deliveryTerms: _deliveryController.text,
                          content: _contentController.text,
                        );
                  } else {
                    ref
                        .read(tradingTermsProvider.notifier)
                        .updateTerms(
                          widget.term!.copyWith(
                            content: _contentController.text,
                            moq: Value(_moqController.text),
                            warranty: Value(_warrantyController.text),
                            paymentTerms: Value(_paymentController.text),
                            deliveryTerms: Value(_deliveryController.text),
                          ),
                        );
                  }

                  Navigator.pop(context);
                  NodeToastManager.show(
                    context,
                    title: widget.term == null
                        ? 'Terms Created'
                        : 'Terms Updated',
                    message: 'Your trading terms are now secured.',
                    status: NodeToastStatus.success,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  widget.term == null ? 'SAVE TEMPLATE' : 'UPDATE TEMPLATE',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    String? hint,
  }) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            color: onSurface.withOpacity(0.5),
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.plusJakartaSans(
              fontSize: 14.sp,
              color: onSurface.withOpacity(0.2),
            ),
            filled: true,
            fillColor: onSurface.withOpacity(0.03),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
