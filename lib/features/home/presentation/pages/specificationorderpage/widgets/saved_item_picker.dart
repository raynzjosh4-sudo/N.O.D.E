import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node_app/features/orders/presentation/providers/bulk_order_providers.dart';
import 'package:node_app/features/profile/domain/entities/draft_order.dart';

/// A bottom sheet that lets the user pick from their saved drafts
/// and add them directly into the current order session.
class SavedItemPicker extends ConsumerStatefulWidget {
  SavedItemPicker({super.key});

  static Future<DraftPickerResult?> show(BuildContext context) {
    return showModalBottomSheet<DraftPickerResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SavedItemPicker(),
    );
  }

  @override
  ConsumerState<SavedItemPicker> createState() => _SavedItemPickerState();
}

class DraftPickerResult {
  final List<DraftOrder>? selectedDrafts;
  final String? newDraftName;

  DraftPickerResult({this.selectedDrafts, this.newDraftName});
}

class _SavedItemPickerState extends ConsumerState<SavedItemPicker> {
  final Set<String> _pickedIds = {};
  bool _isCreatingNew = false;
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _toggle(String id) {
    setState(() {
      if (_pickedIds.contains(id)) {
        _pickedIds.remove(id);
      } else {
        _pickedIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final primary = theme.primaryColor;

    final savedOrdersAsync = ref.watch(userDraftsProvider);

    return savedOrdersAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (saved) {
        final picked = saved.where((s) => _pickedIds.contains(s.id)).toList();

        return DraggableScrollableSheet(
          initialChildSize: 0.65,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          builder: (_, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  // ── Drag Handle ───────────────────────────────────────────────
                  Padding(
                    padding: EdgeInsets.only(top: 12.h, bottom: 4.h),
                    child: Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: onSurface.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),

                  // ── Header ───────────────────────────────────────────────────
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 12, 20, 8),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Saved Drafts',
                              style: GoogleFonts.outfit(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w900,
                                color: onSurface,
                              ),
                            ),
                            Text(
                              'Tap to pick from your saved drafts',
                              style: GoogleFonts.outfit(
                                fontSize: 11.sp,
                                color: onSurface.withOpacity(0.4),
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        if (_pickedIds.isNotEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 5.h,
                            ),
                            decoration: BoxDecoration(
                              color: primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Text(
                              '${_pickedIds.length} selected',
                              style: GoogleFonts.outfit(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: primary,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  Divider(height: 1.h),

                  // ── Action Area ───────────────────────────────────────────────
                  Expanded(
                    child: _isCreatingNew
                        ? _buildNamingSection(theme, onSurface, primary)
                        : _buildDraftsList(saved, scrollController, onSurface),
                  ),

                  // ── Bottom Action ─────────────────────────────────────────────
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      20,
                      12,
                      20,
                      MediaQuery.of(context).padding.bottom + 16,
                    ),
                    child: _isCreatingNew
                        ? _buildCreateButton(primary)
                        : (_pickedIds.isNotEmpty
                              ? _buildAddButton(primary, picked)
                              : _buildNewToggle(onSurface, primary)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildNamingSection(ThemeData theme, Color onSurface, Color primary) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Name Your Draft',
            style: GoogleFonts.outfit(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: onSurface,
            ),
          ),
          SizedBox(height: 8.h),
          TextField(
            controller: _nameController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'e.g. Summer Collection 2026',
              filled: true,
              fillColor: onSurface.withOpacity(0.05),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: primary, width: 2),
              ),
            ),
          ),
          Spacer(),
          TextButton(
            onPressed: () => setState(() => _isCreatingNew = false),
            child: Text(
              'Back to existing drafts',
              style: TextStyle(color: onSurface.withOpacity(0.5)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDraftsList(
    List<DraftOrder> saved,
    ScrollController scrollController,
    Color onSurface,
  ) {
    return ListView.separated(
      controller: scrollController,
      itemCount: saved.length,
      separatorBuilder: (_, __) =>
          Divider(height: 1.h, color: onSurface.withOpacity(0.05)),
      itemBuilder: (_, index) {
        final item = saved[index];
        final isSelectedValue = _pickedIds.contains(item.id);
        return _SavedPickerTile(
          item: item,
          isSelected: isSelectedValue,
          onTap: () => _toggle(item.id),
        );
      },
    );
  }

  Widget _buildAddButton(Color primary, List<DraftOrder> picked) {
    return GestureDetector(
      onTap: () =>
          Navigator.of(context).pop(DraftPickerResult(selectedDrafts: picked)),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: primary,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: primary.withOpacity(0.35),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_shopping_cart_rounded,
              color: Colors.white,
              size: 20.w,
            ),
            SizedBox(width: 10.w),
            Text(
              'Add ${_pickedIds.length} draft${_pickedIds.length > 1 ? 's' : ''} to Order',
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateButton(Color primary) {
    return GestureDetector(
      onTap: () {
        if (_nameController.text.trim().isEmpty) return;
        Navigator.of(
          context,
        ).pop(DraftPickerResult(newDraftName: _nameController.text.trim()));
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: primary,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Center(
          child: Text(
            'Create & Save',
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNewToggle(Color onSurface, Color primary) {
    return GestureDetector(
      onTap: () => setState(() => _isCreatingNew = true),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          border: Border.all(color: onSurface.withOpacity(0.1)),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_rounded, color: primary, size: 22.w),
            SizedBox(width: 8.w),
            Text(
              'Create New Draft',
              style: GoogleFonts.outfit(
                color: primary,
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SavedPickerTile extends StatelessWidget {
  final DraftOrder item;
  final bool isSelected;
  final VoidCallback onTap;

  const _SavedPickerTile({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final primary = theme.primaryColor;

    // Pick first product's image if available
    final firstProductImageUrl = item.entries.isNotEmpty
        ? item.entries.first.savedProduct.product.imageUrl
        : '';

    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
        color: isSelected ? primary.withOpacity(0.05) : Colors.transparent,
        child: Row(
          children: [
            // Image thumbnail
            Container(
              width: 56.w,
              height: 56.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                border: isSelected
                    ? Border.all(color: primary, width: 2.w)
                    : const Border.fromBorderSide(BorderSide.none),
                image: (firstProductImageUrl.isNotEmpty)
                    ? DecorationImage(
                        image: NetworkImage(firstProductImageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
                color: onSurface.withOpacity(0.05),
              ),
              child: (firstProductImageUrl.isEmpty)
                  ? Icon(
                      Icons.inventory_2_rounded,
                      color: onSurface.withOpacity(0.3),
                    )
                  : null,
            ),
            SizedBox(width: 14.w),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.id.length > 20 ? '${item.id.substring(0, 17)}...' : item.id,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? primary : onSurface,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 2.h,
                        ),
                        margin: EdgeInsets.only(right: 8.w),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? primary.withOpacity(0.1)
                              : onSurface.withOpacity(0.07),
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        child: Text(
                          'Draft',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? primary
                                : onSurface.withOpacity(0.5),
                          ),
                        ),
                      ),
                      Text(
                        '${item.totalItems} items',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? primary.withOpacity(0.7)
                              : onSurface.withOpacity(0.4),
                        ),
                      ),
                      Text(
                        ' · ',
                        style: TextStyle(color: onSurface.withOpacity(0.4)),
                      ),
                      Text(
                        '${item.totalUnits} units',
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? primary.withOpacity(0.7)
                              : onSurface.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Check indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24.w,
              height: 24.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? primary : Colors.transparent,
                border: Border.all(
                  color: isSelected ? primary : onSurface.withOpacity(0.2),
                  width: 2.w,
                ),
              ),
              child: isSelected
                  ? Icon(Icons.check_rounded, size: 14.w, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
