import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/features/showcase/presentation/services/node_toast_manager.dart';
import 'package:node_app/core/error/failure.dart';
import 'package:node_app/features/showcase/presentation/widgets/node_toast.dart';

import '../providers/auth_providers.dart';

class EmailOtpSheet extends ConsumerStatefulWidget {
  final String email;
  final String userId;

  const EmailOtpSheet({super.key, required this.email, required this.userId});

  static Future<bool?> show(
    BuildContext context,
    String email,
    String userId,
  ) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false, // Force the user to interact or explicitly cancel
      enableDrag: false,
      builder: (context) => EmailOtpSheet(email: email, userId: userId),
    );
  }

  @override
  ConsumerState<EmailOtpSheet> createState() => _EmailOtpSheetState();
}

class _EmailOtpSheetState extends ConsumerState<EmailOtpSheet> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isLoading = false;
  int _resendTimer = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    // Auto-focus after a frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  void _startResendTimer() {
    setState(() {
      _resendTimer = 60;
      _canResend = false;
    });
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() {
        if (_resendTimer > 0) {
          _resendTimer--;
        } else {
          _canResend = true;
        }
      });
      return _resendTimer > 0;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _handleVerify() async {
    final code = _controller.text;
    if (code.length < 6) return;

    setState(() => _isLoading = true);
    try {
      final authService = ref.read(authServiceProvider);
      await authService.verifyOtp(widget.email, code);

      if (mounted) {
        NodeToastManager.show(
          context,
          title: 'Verification Success',
          message: 'Welcome to the N.O.D.E. network!',
          status: NodeToastStatus.success,
        );
        Navigator.pop(context, true); // Return TRUE for success
      }
    } catch (e) {
      if (mounted) {
        NodeToastManager.show(
          context,
          title: 'Invalid Code',
          message: Failure.fromException(e).toFriendlyMessage(),
          status: NodeToastStatus.error,
        );

        _controller.clear();
        _focusNode.requestFocus();
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleResend() async {
    if (!_canResend) return;

    setState(() => _isLoading = true);
    try {
      final authService = ref.read(authServiceProvider);
      await authService.resendOtp(widget.email);
      if (mounted) {
        NodeToastManager.show(
          context,
          title: 'Code Resent',
          message: 'Please check your inbox (and spam folder).',
          status: NodeToastStatus.info,
        );
        _startResendTimer();
      }
    } catch (e) {
      if (mounted) {
        NodeToastManager.show(
          context,
          title: 'Resend Failed',
          message: Failure.fromException(e).toFriendlyMessage(),
          status: NodeToastStatus.error,
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleCancel() async {
    final proceed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Cancel Signup?',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'If you cancel now, your account will be deleted and you will need to start over.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Stay'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Cancel & Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (proceed == true) {
      setState(() => _isLoading = true);
      try {
        final authService = ref.read(authServiceProvider);
        await authService.deleteCurrentAccount(widget.userId);
        if (mounted) Navigator.pop(context, false); // Return false for cancel
      } catch (e) {
        if (mounted) {
          NodeToastManager.show(
            context,
            title: 'Action Failed',
            message: Failure.fromException(e).toFriendlyMessage(),
            status: NodeToastStatus.error,
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1C1C21) : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        ),
        padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🏷️ TOP DECORATION
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withOpacity(0.1),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 24.h),

            // 📢 HEADER
            Text(
              'Verify your email',
              style: GoogleFonts.outfit(
                fontSize: 22.sp,
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Enter the 6-digit code sent to\n${widget.email}',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13.sp,
                height: 1.5,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            SizedBox(height: 32.h),

            // 🔢 PREMIUM OTP INPUT DISPLAY
            Stack(
              children: [
                // Real invisible TextField behind the scenes
                // This handles the keyboard, copy/paste, and input logic
                Opacity(
                  opacity: 0,
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    onChanged: (val) {
                      setState(() {});
                      if (val.length == 6) {
                        _handleVerify();
                      }
                    },
                    decoration: const InputDecoration(counterText: ''),
                  ),
                ),
                // Beautiful visual boxes
                GestureDetector(
                  onTap: () => _focusNode.requestFocus(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      6,
                      (index) => _buildDigitBox(index),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 32.h),

            // 🚀 VERIFY BUTTON
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                onPressed: (_controller.text.length == 6 && !_isLoading)
                    ? _handleVerify
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  elevation: 0,
                  disabledBackgroundColor: theme.colorScheme.primary
                      .withOpacity(0.3),
                ),
                child: _isLoading
                    ? SizedBox(
                        height: 24.h,
                        width: 24.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'Verify & Complete',
                        style: GoogleFonts.outfit(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 24.h),

            // 🔄 RESEND SECTION
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Didn't get the code? ",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.sp,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
                GestureDetector(
                  onTap: _canResend ? _handleResend : null,
                  child: Text(
                    _canResend ? 'Resend Code' : 'Resend in ${_resendTimer}s',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: _canResend
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface.withOpacity(0.3),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // ❌ CANCEL BUTTON
            TextButton(
              onPressed: _isLoading ? null : _handleCancel,
              child: Text(
                'Cancel & Delete Account',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.error,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDigitBox(int index) {
    final theme = Theme.of(context);
    final val = _controller.text;
    final isFocused = _focusNode.hasFocus && val.length == index;
    final hasValue = val.length > index;
    final digit = hasValue ? val[index] : '';

    return Container(
      width: 45.w,
      height: 56.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isFocused
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface.withOpacity(0.1),
          width: isFocused ? 2 : 1,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        digit,
        style: GoogleFonts.outfit(
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}
