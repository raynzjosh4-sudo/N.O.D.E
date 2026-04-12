import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:node_app/core/utils/responsive_size.dart';
import 'package:node_app/features/auth/presentation/widgets/forgot_password_sheet.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

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
                    onPressed: () => context.push('/signup'),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Sign up',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              // 📢 SMALL HEADER (NO 1 PLACE)
              Text(
                'Log in',
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
                  Image.asset(
                    'assets/icon/nodeicon.png',
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
              SizedBox(height: 16.h),

              // 🔑 PASSWORD FIELD
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildLabel('Password'),
                  TextButton(
                    onPressed: () => ForgotPasswordSheet.show(context),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Forgot password?',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: TextStyle(fontSize: 14.sp),
                decoration: _getInputDecoration(
                  'Your password',
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
              SizedBox(height: 32.h),

              // 🚀 LOGIN BUTTON
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: () => context.go('/home'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    'Log In',
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
