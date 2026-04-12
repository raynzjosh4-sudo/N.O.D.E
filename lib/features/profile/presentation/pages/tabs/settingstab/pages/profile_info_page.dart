import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import 'location_picker_page.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/core/database/app_database.dart';
import 'package:node_app/features/auth/presentation/providers/user_providers.dart';
import '../../../../../../showcase/presentation/services/node_toast_manager.dart';
import '../../../../../../showcase/presentation/widgets/node_toast.dart';

class ProfileInfoPage extends ConsumerStatefulWidget {
  final bool isRequired;
  final String? message;

  const ProfileInfoPage({super.key, this.isRequired = false, this.message});

  static void show(
    BuildContext context, {
    bool isRequired = false,
    String? message,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ProfileInfoPage(isRequired: isRequired, message: message),
      ),
    );
  }

  @override
  ConsumerState<ProfileInfoPage> createState() => _ProfileInfoPageState();
}

class _ProfileInfoPageState extends ConsumerState<ProfileInfoPage> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _regionController = TextEditingController();
  final _momoController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    // Try to load from DB
    final user = await ref.read(userProfileProvider.future);
    if (user != null) {
      _nameController.text = user.fullName;
      _addressController.text = user.address;
      _regionController.text = user.city;
      _momoController.text = user.phoneNumber;
    } else {
      // Fallback to dummy for demo if DB is empty
      _nameController.text = 'Sarah Jenkins (NODE Wholesale)';
      _addressController.text = 'Block 4, Namanve Industrial Park';
      _regionController.text = 'Kampala / Mukono';
      _momoController.text = '256772000000';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _regionController.dispose();
    _momoController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_nameController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _regionController.text.isEmpty ||
        _momoController.text.isEmpty) {
      NodeToastManager.show(
        context,
        title: 'Missing Information',
        message: 'Please fill in all fields',
        status: NodeToastStatus.warning,
      );
      return;
    }

    setState(() => _isLoading = true);

    final repository = ref.read(userRepositoryProvider);

    // For demo, we use a fixed ID or check if one exists
    final currentUserAvailable = await ref.read(userProfileProvider.future);
    final id = currentUserAvailable?.id ?? const Uuid().v4();

    final user = UserEntry(
      id: id,
      fullName: _nameController.text,
      address: _addressController.text,
      city: _regionController.text,
      phoneNumber: _momoController.text,
      updatedAt: DateTime.now(),
    );

    final result = await repository.saveUser(user);

    if (mounted) {
      setState(() => _isLoading = false);
      result.fold(
        (failure) => NodeToastManager.show(
          context,
          title: 'Storage Error',
          message: failure.message,
          status: NodeToastStatus.error,
        ),
        (_) {
          NodeToastManager.show(
            context,
            title: 'Identity Secured',
            message: 'Your business profile has been updated.',
            status: NodeToastStatus.success,
          );
          // Invalidate provider to refresh data elsewhere
          ref.invalidate(userProfileProvider);
          if (widget.isRequired) Navigator.pop(context);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final primary = theme.primaryColor;

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
          'Business Setup',
          style: GoogleFonts.outfit(
            fontSize: 18.sp,
            fontWeight: FontWeight.w900,
            color: onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          if (widget.isRequired)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              color: Colors.orange.withOpacity(0.1),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: Colors.orange,
                    size: 20.w,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      widget.message ??
                          'Please set your location and contact details to proceed with the order.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(context, 'LEGAL IDENTITY'),
                  SizedBox(height: 12.h),
                  _buildTextField(
                    context,
                    'Full Legal / Business Name',
                    _nameController,
                    Icons.business_rounded,
                  ),

                  SizedBox(height: 32.h),
                  _buildSectionHeader(context, 'LOCATION & CONTACT'),
                  SizedBox(height: 12.h),
                  _buildTextField(
                    context,
                    'Physical Address',
                    _addressController,
                    Icons.location_on_outlined,
                    onMapPick: () async {
                      final result = await LocationPickerPage.show(context);
                      if (result != null) {
                        setState(() => _addressController.text = result);
                      }
                    },
                  ),
                  SizedBox(height: 16.h),
                  _buildTextField(
                    context,
                    'Region / City',
                    _regionController,
                    Icons.map_outlined,
                    // REMOVED readOnly and onMapPick logic for City as requested
                  ),

                  SizedBox(height: 32.h),
                  _buildTextField(
                    context,
                    'Phone Number',
                    _momoController,
                    Icons.phone_outlined,
                  ),

                  SizedBox(height: 48.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 20.h),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                      ),
                      child: _isLoading
                          ? SizedBox(
                              height: 20.h,
                              width: 20.h,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'SAVE PROFILE',
                              style: GoogleFonts.outfit(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 11.sp,
        fontWeight: FontWeight.w900,
        color: Theme.of(context).primaryColor,
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context,
    String label,
    TextEditingController controller,
    IconData icon, {
    VoidCallback? onMapPick,
  }) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final primary = Theme.of(context).primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: onSurface.withOpacity(0.5),
              ),
            ),
            if (onMapPick != null)
              GestureDetector(
                onTap: onMapPick,
                child: Text(
                  'PICK ON MAP',
                  style: GoogleFonts.outfit(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w900,
                    color: primary,
                    letterSpacing: 1,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          readOnly: onMapPick != null,
          style: GoogleFonts.outfit(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              size: 18.w,
              color: onSurface.withOpacity(0.3),
            ),
            suffixIcon: onMapPick != null
                ? Icon(
                    Icons.map_rounded,
                    size: 18.w,
                    color: primary.withOpacity(0.6),
                  )
                : null,
            filled: true,
            fillColor: onSurface.withOpacity(0.03),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide(color: onSurface.withOpacity(0.05)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide(color: primary, width: 2.w),
            ),
          ),
        ),
      ],
    );
  }
}
