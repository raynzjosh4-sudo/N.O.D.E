import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/core/database/app_database.dart';
import 'package:node_app/core/error/failure.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:node_app/features/auth/presentation/providers/user_providers.dart';
import 'package:node_app/features/profile/data/repositories/profile_repository.dart';
import 'package:node_app/features/profile/presentation/providers/profile_providers.dart';
import 'package:node_app/features/showcase/presentation/services/node_toast_manager.dart';
import 'package:node_app/features/showcase/presentation/widgets/node_toast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AccountDetailsPage extends ConsumerStatefulWidget {
  const AccountDetailsPage({super.key});

  static void show(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AccountDetailsPage()),
    );
  }

  @override
  ConsumerState<AccountDetailsPage> createState() => _AccountDetailsPageState();
}

class _AccountDetailsPageState extends ConsumerState<AccountDetailsPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();

    // Populate immediately if data is already available
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      debugPrint('🔄 [AccountDetails] Loading initial data...');
      final user = ref.read(userProfileProvider).value;

      if (user != null && mounted) {
        debugPrint('✅ [AccountDetails] Found local user data. Populating...');
        _nameController.text = user.fullName;
        _emailController.text = user.email ?? '';
      } else {
        debugPrint(
          '⚠️ [AccountDetails] User data missing locally. Triggering Safety Sync...',
        );
        final userId = ref.read(authStateProvider).value?.session?.user.id;

        if (userId != null) {
          try {
            await ref.read(profileRepositoryProvider).syncProfile(userId);
            debugPrint('✅ [AccountDetails] Safety Sync Complete.');

            final freshUser = await ref.read(userProfileProvider.future);
            if (freshUser != null && mounted) {
              _nameController.text = freshUser.fullName;
              _emailController.text = freshUser.email ?? '';
            }
          } catch (e) {
            debugPrint('❌ [AccountDetails] Safety Sync FAILED: $e');
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final primary = theme.primaryColor;

    // 🎧 Listen for profile updates and populate controllers
    ref.listen<AsyncValue<UserEntry?>>(userProfileProvider, (previous, next) {
      next.whenData((user) {
        if (user != null) {
          if (_nameController.text.isEmpty) {
            debugPrint(
              '🎯 [AccountDetails] Reactive Population: Setting Name to ${user.fullName}',
            );
            _nameController.text = user.fullName;
          }
          if (_emailController.text.isEmpty) {
            debugPrint(
              '🎯 [AccountDetails] Reactive Population: Setting Email to ${user.email}',
            );
            _emailController.text = user.email ?? '';
          }
        }
      });
    });

    // 🛡️ Pre-fill Email from Session immediately if DB is currently empty
    final sessionEmail =
        Supabase.instance.client.auth.currentSession?.user.email;
    if (_emailController.text.isEmpty && sessionEmail != null) {
      _emailController.text = sessionEmail;
    }

    final user = ref.watch(userProfileProvider).value;

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
          'Account Information',
          style: GoogleFonts.outfit(
            fontSize: 18.sp,
            fontWeight: FontWeight.w900,
            color: onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          children: [
            // ── Avatar Edit Section ──────────────────────────────────────
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120.w,
                    height: 120.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: primary, width: 3.w),
                      color: theme.colorScheme.onSurface.withOpacity(0.04),
                    ),
                    child: ClipOval(
                      child: (user?.profilePicUrl != null &&
                              user!.profilePicUrl!.isNotEmpty)
                          ? CachedNetworkImage(
                              imageUrl: user.profilePicUrl!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: primary.withOpacity(0.2),
                                ),
                              ),
                              errorWidget: (context, url, error) => Icon(
                                Icons.person,
                                size: 60.w,
                                color: onSurface.withOpacity(0.2),
                              ),
                            )
                          : Icon(
                              Icons.person,
                              size: 60.w,
                              color: onSurface.withOpacity(0.2),
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4.w,
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.w),
                      ),
                      child: Icon(
                        Icons.camera_alt_rounded,
                        size: 18.w,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              'Tap to Change Photo',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: primary,
              ),
            ),
            SizedBox(height: 48.h),

            // ── Input Fields ─────────────────────────────────────────────
            _buildTextField(
              context,
              'Full Name',
              _nameController,
              Icons.person_outline_rounded,
            ),
            SizedBox(height: 24.h),
            _buildTextField(
              context,
              'Email Address',
              _emailController,
              Icons.mail_outline_rounded,
            ),

            SizedBox(height: 80.h),

            // ── Save Button ──────────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _updateAccount,
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
                        'UPDATE ACCOUNT',
                        style: GoogleFonts.outfit(
                          fontSize: 14.sp,
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

  Future<void> _updateAccount() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim().toLowerCase();

    if (name.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final repository = ref.read(userRepositoryProvider);
      final currentUser = ref.read(userProfileProvider).value;

      // 1. Handle Identity Update (Name, Photo)
      final updatedUser = UserEntry(
        id: currentUser?.id ?? const Uuid().v4(),
        fullName: name,
        email: currentUser?.email, // Keep old email in table until confirmed
        role: currentUser?.role ?? 'customer',
        profilePicUrl: currentUser?.profilePicUrl,
        updatedAt: DateTime.now(),
      );

      final identityResult = await repository.saveUser(updatedUser);

      // 2. Handle Email Change Request (Secure Auth Update)
      bool emailChanged = email.isNotEmpty && email != currentUser?.email;
      if (emailChanged) {
        final emailResult = await repository.updateEmail(email);
        emailResult.fold(
          (failure) => NodeToastManager.show(
            context,
            title: 'Email Update Failed',
            message: failure.toFriendlyMessage(),
            status: NodeToastStatus.error,
          ),
          (_) {
            NodeToastManager.show(
              context,
              title: 'Verification Sent',
              message: 'Please check your new inbox to confirm the change.',
              status: NodeToastStatus.info,
            );
          },
        );
      }

      if (mounted) {
        identityResult.fold(
          (failure) => NodeToastManager.show(
            context,
            title: 'Update Failed',
            message: failure.toFriendlyMessage(),
            status: NodeToastStatus.error,
          ),
          (_) {
            if (!emailChanged) {
              NodeToastManager.show(
                context,
                title: 'Profile Updated',
                message: 'Your changes have been saved.',
                status: NodeToastStatus.success,
              );
              Navigator.pop(context);
            }
          },
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildTextField(
    BuildContext context,
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final primary = Theme.of(context).primaryColor;

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
          style: GoogleFonts.outfit(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              size: 20.w,
              color: onSurface.withOpacity(0.3),
            ),
            filled: true,
            fillColor: onSurface.withOpacity(0.04),
            contentPadding: EdgeInsets.all(18.w),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: onSurface.withOpacity(0.05)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: primary, width: 2.w),
            ),
          ),
        ),
      ],
    );
  }
}
