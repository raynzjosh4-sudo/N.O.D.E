import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:node_app/core/database/app_database.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  static bool _isGoogleInitialized = false;

  Future<AuthResponse?> signInWithGoogle() async {
    try {
      debugPrint('👉 [Google Auth] Starting Google Sign-In flow...');

      const webClientId =
          '959127069942-p625bddb7vket40arga1qajjo09o07da.apps.googleusercontent.com';

      if (!_isGoogleInitialized) {
        debugPrint('👉 [Google Auth] Initializing GoogleSignIn instance...');
        try {
          await GoogleSignIn.instance.initialize(serverClientId: webClientId);
        } catch (e) {
          debugPrint(
            '⚠️ [Google Auth] Initialize not supported on this platform: $e',
          );
        }
        _isGoogleInitialized = true;
      }

      // 1. Force the native Google account picker to open
      debugPrint('👉 [Google Auth] Opening native account picker...');
      final GoogleSignInAccount? googleUser;
      try {
        googleUser = await GoogleSignIn.instance.authenticate();
      } on GoogleSignInException catch (e) {
        debugPrint('⚠️ [Google Auth] Exception: ${e.code} | $e');

        // Return null ONLY if the user explicitly canceled. Otherwise rethrow to see the true crash!
        if (e.code == GoogleSignInExceptionCode.canceled) {
          return null;
        }
        rethrow;
      }

      if (googleUser == null) return null;

      return await signInWithAccount(googleUser);
    } catch (e) {
      debugPrint('❌ [Google Auth] ERROR: $e');
      rethrow;
    }
  }

  /// Handles the Supabase exchange once a Google account is selected/detected.
  Future<AuthResponse?> signInWithAccount(
    GoogleSignInAccount googleUser,
  ) async {
    try {
      debugPrint('✅ [Google Auth] Processing account: ${googleUser.email}');

      // 2. Extract the secure tokens from the selected Google account
      debugPrint('👉 [Google Auth] Extracting tokens...');
      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        throw 'No ID Token found.';
      }
      debugPrint('✅ [Google Auth] Tokens extracted successfully.');

      // 3. Hand the tokens to Supabase to create the user session
      debugPrint('👉 [Google Auth] Attempting Supabase authentication...');
      final response = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
      );

      debugPrint(
        '🎉 [Google Auth] Supabase Login SUCCESS! User ID: ${response.user?.id}',
      );
      return response;
    } catch (e) {
      debugPrint('❌ [Google Auth] Supabase Exchange ERROR: $e');
      rethrow;
    }
  }

  /// Attempts to sign in with Google silently (no UI/Picker).
  /// This is used for Smart Account detection on boot or fresh install.
  Future<GoogleSignInAccount?> signInSilently() async {
    try {
      debugPrint('👉 [Google Auth] Attempting silent sign-in...');

      const webClientId =
          '959127069942-p625bddb7vket40arga1qajjo09o07da.apps.googleusercontent.com';

      if (!_isGoogleInitialized) {
        try {
          await GoogleSignIn.instance.initialize(serverClientId: webClientId);
        } catch (e) {
          debugPrint(
            '⚠️ [Google Auth] Initialize not supported on this platform: $e',
          );
        }
        _isGoogleInitialized = true;
      }

      final googleUser = await GoogleSignIn.instance
          .attemptLightweightAuthentication();
      if (googleUser != null) {
        debugPrint(
          '✅ [Google Auth] Silent detection SUCCESS: ${googleUser.email}',
        );
      } else {
        debugPrint(
          'ℹ️ [Google Auth] Silent detection: No prior account found.',
        );
      }
      return googleUser;
    } catch (e) {
      debugPrint('⚠️ [Google Auth] Silent sign-in failed: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      debugPrint('👉 [Google Auth] Starting sign out...');

      // 0. 🧹 WIPE LOCAL DATA - Absolute privacy first!
      // This ensures that Account B never sees Account A's cached drafts/records.
      try {
        final db = AppDatabase();
        await db.wipeAllData();
        debugPrint('✅ [Google Auth] Local database wiped successfully.');
      } catch (e) {
        debugPrint('⚠️ [Google Auth] Database wipe failed (might be already closed): $e');
      }

      // 1. Sign out from Supabase (clears local session)
      await supabase.auth.signOut();

      // 2. Clear Google Sign-In instance
      // This is important so the next time user clicks "Login with Google"
      // they get to pick an account again instead of auto-logging the old one.
      try {
        await GoogleSignIn.instance.signOut();
      } catch (e) {
        debugPrint(
          '⚠️ [Google Auth] Google-specific signOut not supported on this platform: $e',
        );
      }

      debugPrint('✅ [Google Auth] Successfully signed out.');
    } catch (e) {
      debugPrint('❌ [Google Auth] Sign out ERROR: $e');
      rethrow;
    }
  }

  /// 📧 Manual Email/Password Sign In
  Future<AuthResponse> signInWithEmail(String email, String password) async {
    try {
      debugPrint('👉 [Auth] Attempting Email Sign-In for: $email');
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      debugPrint('✅ [Auth] Email Login SUCCESS!');
      return response;
    } catch (e) {
      debugPrint('❌ [Auth] Email Login ERROR: $e');
      rethrow;
    }
  }

  /// 📝 Manual Email/Password Sign Up
  Future<AuthResponse> signUpWithEmail(String email, String password) async {
    try {
      debugPrint('👉 [Auth] Creating account for: $email');
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );
      debugPrint('✅ [Auth] Email Signup SUCCESS!');
      return response;
    } catch (e) {
      debugPrint('❌ [Auth] Email Signup ERROR: $e');
      rethrow;
    }
  }

  /// 🔢 Verify Magic Code (OTP)
  Future<AuthResponse> verifyOtp(String email, String token) async {
    try {
      debugPrint('👉 [Auth] Verifying OTP for: $email');
      final response = await supabase.auth.verifyOTP(
        email: email,
        token: token,
        type: OtpType.signup,
      );
      debugPrint('✅ [Auth] OTP Verification SUCCESS!');
      return response;
    } catch (e) {
      debugPrint('❌ [Auth] OTP Verification ERROR: $e');
      rethrow;
    }
  }

  /// 🔄 Resend Magic Code (OTP)
  Future<void> resendOtp(String email) async {
    try {
      debugPrint('👉 [Auth] Resending OTP to: $email');
      await supabase.auth.resend(type: OtpType.signup, email: email);
      debugPrint('✅ [Auth] OTP Resend SUCCESS!');
    } catch (e) {
      debugPrint('❌ [Auth] OTP Resend ERROR: $e');
      rethrow;
    }
  }

  /// 🛡️ Deletes a fresh unconfirmed account.
  /// Used for "Cancelling" an unconfirmed signup.
  Future<void> deleteCurrentAccount(String userId) async {
    try {
      debugPrint('🛡️ [Auth] Attempting account wipe for ID: $userId...');
      await supabase.rpc(
        'delete_fresh_unconfirmed_user',
        params: {'target_user_id': userId},
      );
      debugPrint('✅ [Auth] Account successfully wiped.');

      // Also sign out locally to clear session state if any exists
      await signOut();
    } catch (e) {
      debugPrint('❌ [Auth] Account wipe ERROR: $e');
      rethrow;
    }
  }

  /// 🛡️ Permanent Account Deletion
  /// Calls a custom RPC to wipe the user from auth.users.
  /// This will trigger cascading deletes on all linked tables.
  Future<void> deleteAccount() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      debugPrint('🚨 [Auth] PERMANENT DELETION requested for: ${user.id}');

      // 1. Call the secure RPC
      await supabase.rpc('delete_current_user');

      debugPrint('✅ [Auth] Cloud account deleted successfully.');

      // 2. Local Cleanup (Sign out clears tokens/session)
      await signOut();
    } catch (e) {
      debugPrint('❌ [Auth] Delete Account ERROR: $e');
      rethrow;
    }
  }
}
