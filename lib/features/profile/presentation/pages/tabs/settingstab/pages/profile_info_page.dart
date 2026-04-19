import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/core/error/failure.dart';
import 'package:node_app/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:node_app/features/profile/data/repositories/profile_repository.dart';
import 'package:uuid/uuid.dart';
import 'location_picker_page.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/core/database/app_database.dart';
import 'package:node_app/core/domain/entities/location.dart';
import 'package:node_app/features/auth/presentation/providers/user_providers.dart';
import 'package:node_app/features/profile/presentation/providers/profile_providers.dart';
import 'package:drift/drift.dart' hide Column;
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
    debugPrint('🔄 [ProfileInfo] Loading initial data...');

    // 1. Try immediate read from reactive providers
    final user = ref.read(userProfileProvider).value;
    final business = ref.read(userBusinessProvider).value;

    debugPrint(
      '📍 [ProfileInfo] Local Snapshot - User: ${user != null}, Business: ${business != null}',
    );

    if (mounted) {
      if (business != null) {
        debugPrint('✅ [ProfileInfo] Found local business data. Populating...');
        _nameController.text = business.legalName;
        _addressController.text = business.physicalAddress ?? '';
        _regionController.text = business.city ?? business.region ?? '';
        _momoController.text = business.phoneNumber ?? '';
      } else if (user != null) {
        debugPrint('ℹ️ [ProfileInfo] No business data, using user identity...');
        _nameController.text = user.fullName;
      }
    }

    // 2. SAFETY SYNC: If data is missing, force a sync from Supabase
    if (user == null || business == null) {
      debugPrint(
        '⚠️ [ProfileInfo] Data missing locally. Triggering Safety Sync...',
      );
      final userId = ref.read(authStateProvider).value?.session?.user.id;

      if (userId != null) {
        try {
          await ref.read(profileRepositoryProvider).syncProfile(userId);
          debugPrint('✅ [ProfileInfo] Safety Sync Complete.');

          // Refresh and repopulate
          final freshUser = await ref.read(userProfileProvider.future);
          final freshBus = await ref.read(userBusinessProvider.future);

          if (mounted) {
            if (freshBus != null) {
              _nameController.text = freshBus.legalName;
              _addressController.text = freshBus.physicalAddress ?? '';
              _regionController.text = freshBus.city ?? freshBus.region ?? '';
              _momoController.text = freshBus.phoneNumber ?? '';
            } else if (freshUser != null && _nameController.text.isEmpty) {
              _nameController.text = freshUser.fullName;
            }
          }
        } catch (e) {
          debugPrint('❌ [ProfileInfo] Safety Sync FAILED: $e');
        }
      } else {
        debugPrint('❌ [ProfileInfo] Cannot sync: No userId found in AuthState');
      }
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

  Future<void> _handleRefresh() async {
    final userId = ref.read(authStateProvider).value?.session?.user.id;
    if (userId == null) return;

    try {
      await ref.read(profileRepositoryProvider).syncProfile(userId);
      // Force individual providers to refresh
      ref.invalidate(userProfileProvider);
      ref.invalidate(userBusinessProvider);

      if (mounted) {
        NodeToastManager.show(
          context,
          title: 'Identity Refreshed',
          message: 'All your business data is now up to date.',
          status: NodeToastStatus.success,
        );
      }
    } catch (e) {
      if (mounted) {
        NodeToastManager.show(
          context,
          title: 'Sync Failed',
          message: Failure.fromException(e).toFriendlyMessage(),
          status: NodeToastStatus.error,
        );
      }
    }
  }

  Future<void> _saveProfile() async {
    debugPrint('🚀 [ProfileInfo] Save Profile Button Tapped');

    if (_nameController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _regionController.text.isEmpty ||
        _momoController.text.isEmpty) {
      debugPrint('⚠️ [ProfileInfo] Save blocked: Missing fields');
      NodeToastManager.show(
        context,
        title: 'Missing Information',
        message: 'Please fill in all fields',
        status: NodeToastStatus.warning,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final repository = ref.read(userRepositoryProvider);
      final currentUserAvailable = ref.read(userProfileProvider).value;
      final id = currentUserAvailable?.id ?? const Uuid().v4();

      final user = UserEntry(
        id: id,
        fullName: currentUserAvailable?.fullName ?? _nameController.text,
        email: currentUserAvailable?.email,
        role: currentUserAvailable?.role ?? 'customer',
        profilePicUrl: currentUserAvailable?.profilePicUrl,
        updatedAt: DateTime.now(),
      );

      // Parse coordinates if available in the address string
      double? lat;
      double? lng;
      if (_addressController.text.contains('Loc:')) {
        final regExp = RegExp(r"Loc:\s*(-?\d+\.?\d*),\s*(-?\d+\.?\d*)");
        final match = regExp.firstMatch(_addressController.text);
        if (match != null && match.groupCount >= 2) {
          lat = double.tryParse(match.group(1) ?? '');
          lng = double.tryParse(match.group(2) ?? '');
        }
      }

      final business = BusinessTableCompanion.insert(
        id: id,
        legalName: _nameController.text,
        physicalAddress: Value(_addressController.text),
        city: Value(_regionController.text),
        phoneNumber: Value(_momoController.text),
        region: Value(_regionController.text),
        latitude: Value(lat),
        longitude: Value(lng),
      );

      debugPrint('📡 [ProfileInfo] Sending to Repository:');
      debugPrint('   - Name: ${user.fullName}');
      debugPrint('   - Address: ${_addressController.text}');
      debugPrint('   - Phone: ${_momoController.text}');

      final result = await repository.saveProfile(
        user: user,
        business: business,
      );

      if (mounted) {
        setState(() => _isLoading = false);
        result.fold(
          (failure) {
            debugPrint(
              '❌ [ProfileInfo] Repository Failure: ${failure.message}',
            );
            NodeToastManager.show(
              context,
              title: 'Storage Error',
              message: failure.toFriendlyMessage(),
              status: NodeToastStatus.error,
            );
          },
          (_) {
            debugPrint('✅ [ProfileInfo] Profile Saved Successfully');
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
    } catch (e, stack) {
      debugPrint('❌ [ProfileInfo] CRITICAL CRASH: $e');
      debugPrint('📜 Stack Trace: $stack');
      if (mounted) {
        setState(() => _isLoading = false);
        NodeToastManager.show(
          context,
          title: 'Critical Error',
          message: Failure.fromException(e).toFriendlyMessage(),
          status: NodeToastStatus.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final primary = theme.primaryColor;

    // Listen for data updates to pre-fill controllers if empty
    ref.listen(userProfileProvider, (previous, next) {
      final user = next.value;
      if (user != null && _nameController.text.isEmpty) {
        _nameController.text = user.fullName;
      }
    });

    ref.listen(userBusinessProvider, (previous, next) {
      final business = next.value;
      if (business != null) {
        // ALWAYS prioritize business legal name over user full name on this page
        final user = ref.read(userProfileProvider).value;
        if (_nameController.text.isEmpty ||
            (user != null && _nameController.text == user.fullName)) {
          _nameController.text = business.legalName;
        }

        if (_addressController.text.isEmpty) {
          _addressController.text = business.physicalAddress ?? '';
        }
        if (_regionController.text.isEmpty) {
          _regionController.text = business.city ?? business.region ?? '';
        }
        if (_momoController.text.isEmpty) {
          _momoController.text = business.phoneNumber ?? '';
        }
      }
    });

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
            child: RefreshIndicator(
              onRefresh: _handleRefresh,
              color: primary,
              backgroundColor: theme.colorScheme.surface,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
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
