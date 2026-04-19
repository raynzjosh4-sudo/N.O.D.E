import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node_app/core/error/failure.dart';
import 'package:node_app/features/auth/presentation/providers/auth_providers.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:node_app/features/showcase/presentation/services/node_toast_manager.dart';
import 'package:node_app/features/showcase/presentation/widgets/node_toast.dart';
import 'package:node_app/features/auth/presentation/widgets/email_otp_sheet.dart';
import 'package:node_app/features/profile/presentation/pages/tabs/settingstab/pages/legal_terms_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _agreeToTerms = false;
  bool _isLoading = false;

  Future<void> _handleSignup() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      NodeToastManager.show(
        context,
        title: 'Missing Fields',
        message: 'Email and password are required to create an account.',
        status: NodeToastStatus.error,
      );
      return;
    }

    if (!_agreeToTerms) {
      NodeToastManager.show(
        context,
        title: 'Terms Required',
        message: 'Please agree to the Terms and Conditions to proceed.',
        status: NodeToastStatus.error,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authServiceProvider);
      final response = await authService.signUpWithEmail(email, password);

      if (mounted && response.user != null) {
        // 🔢 Show the Magic Code (OTP) entry sheet with the specific User ID
        final isVerified = await EmailOtpSheet.show(
          context,
          email,
          response.user!.id,
        );

        // If verified successfully, go to Home
        if (isVerified == true && mounted) {
          debugPrint('🏁 [Signup] Verification complete. Navigating home...');
          context.go('/home');
        }
      }
    } catch (e) {
      if (mounted) {
        final failure = Failure.fromException(e);
        NodeToastManager.show(
          context,
          title: 'Signup Failed',
          message: failure.toFriendlyMessage(),
          status: NodeToastStatus.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16.h),
              // 🔝 TOP ACTIONS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: theme.colorScheme.onSurface,
                      size: 20.w,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/login'),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Log in',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.h),

              // 📢 SMALL HEADER (NO 1 PLACE)
              Text(
                'Sign up',
                style: GoogleFonts.outfit(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
              SizedBox(height: 8.h),

              // 🏷️ BRANDING
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icon/nodeicon.svg',
                    width: 48.w,
                    height: 48.h,
                  ),
                  SizedBox(width: 10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'N.O.D.E.',
                        style: GoogleFonts.outfit(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.onSurface,
                          letterSpacing: 2,
                        ),
                      ),
                      Text(
                        'National, Order & Distribution, Exchange',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface.withOpacity(0.4),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 32.h),

              // 📧 EMAIL FIELD
              _buildLabel('Email Address'),
              SizedBox(height: 4.h),
              TextField(
                controller: _emailController,
                style: TextStyle(fontSize: 14.sp),
                decoration: _getInputDecoration(
                  'name@company.com',
                  Icons.email_outlined,
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 12.h),

              // 🔑 PASSWORD FIELD
              _buildLabel('Password'),
              SizedBox(height: 4.h),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: TextStyle(fontSize: 14.sp),
                decoration: _getInputDecoration(
                  'Create a password',
                  Icons.lock_outline_rounded,
                  suffixIcon: IconButton(
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 18.w,
                      color: theme.colorScheme.onSurface.withOpacity(0.4),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              // ✅ TERMS & CONDITIONS
              Row(
                children: [
                  SizedBox(
                    height: 20.h,
                    width: 20.w,
                    child: Checkbox(
                      value: _agreeToTerms,
                      onChanged: (val) =>
                          setState(() => _agreeToTerms = val ?? false),
                      activeColor: theme.colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: 'I agree to the ',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.sp,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        children: [
                          TextSpan(
                            text: 'Terms of Service',
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => LegalTermsPage.show(
                                context,
                                termId: 'tos',
                                title: 'Terms of Service',
                              ),
                          ),
                          const TextSpan(text: ' & '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => LegalTermsPage.show(
                                context,
                                termId: 'privacy',
                                title: 'Privacy Policy',
                              ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              // 🚀 SIGNUP BUTTON
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: (_agreeToTerms && !_isLoading)
                      ? _handleSignup
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    disabledBackgroundColor: theme.colorScheme.primary
                        .withOpacity(0.3),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          height: 20.h,
                          width: 20.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: theme.colorScheme.onPrimary,
                          ),
                        )
                      : Text(
                          'Create Account',
                          style: GoogleFonts.outfit(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 11.sp,
        fontWeight: FontWeight.w700,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
      ),
    );
  }

  InputDecoration _getInputDecoration(
    String hint,
    IconData icon, {
    Widget? suffixIcon,
  }) {
    final theme = Theme.of(context);
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(
        icon,
        size: 18.w,
        color: theme.colorScheme.onSurface.withOpacity(0.3),
      ),
      suffixIcon: suffixIcon,
      hintStyle: GoogleFonts.plusJakartaSans(
        color: theme.colorScheme.onSurface.withOpacity(0.2),
        fontSize: 13.sp,
      ),
      filled: true,
      fillColor: theme.colorScheme.onSurface.withOpacity(0.03),
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(
          color: theme.colorScheme.onSurface.withOpacity(0.05),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: theme.colorScheme.primary, width: 2.w),
      ),
    );
  }
}
