// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// // Update this import path to match where your constants file is located
// import 'package:nexus/features/auth/constants/supabase-constants.dart';

// // Get the Supabase client instance
// class AuthService extends ChangeNotifier {
//   SupabaseClient get supabase => Supabase.instance.client;
//   User? _currentUser;
//   bool _isLoading = true;

//   User? get currentUser => _currentUser;
//   bool get isLoggedIn => _currentUser != null;
//   bool get isLoading => _isLoading;

//   AuthService() {
//     _setupAuthListener();
//   }

//   /// Sets up an auth state change listener for real-time updates
//   void _setupAuthListener() {
//     // Set initial user from an existing session
//     _currentUser = supabase.auth.currentUser;
//     _isLoading = false;
//     notifyListeners();

//     // Listen for auth state changes
//     supabase.auth.onAuthStateChange.listen((data) {
//       final AuthChangeEvent event = data.event;
//       final Session? session = data.session;

//       // Update the user based on the event
//       if (event == AuthChangeEvent.signedIn ||
//           event == AuthChangeEvent.initialSession ||
//           event == AuthChangeEvent.tokenRefreshed ||
//           event == AuthChangeEvent.userUpdated) {
//         _currentUser = session?.user;
//       } else if (event == AuthChangeEvent.signedOut) {
//         _currentUser = null;
//       }

//       _isLoading = false; // Auth state is confirmed, no longer loading
//       notifyListeners();
//     });
//   }

//   /// Sign up a new user and create their profile (Email/Password)
//   Future<void> signUp(String email, String password, String name) async {
//     try {
//       final AuthResponse response = await supabase.auth.signUp(
//         email: email,
//         password: password,
//       );

//       // If sign up is successful, create the profile
//       if (response.user != null) {
//         await supabase.from('nexususers').insert({
//           'id': response.user!.id,
//           'name': name,
//           'email': email,
//         });
//       }
//     } on AuthException {
//       rethrow;
//     } on SocketException {
//       throw 'No internet connection. Please check your data bundle.';
//     } catch (e) {
//       _checkForNetworkError(e);
//       rethrow;
//     }
//   }

//   /// Log in an existing user (Email/Password)
//   Future<void> signIn(String email, String password) async {
//     try {
//       await supabase.auth.signInWithPassword(email: email, password: password);
//     } on AuthException {
//       rethrow;
//     } on SocketException {
//       throw 'No internet connection. Please check your data bundle.';
//     } catch (e) {
//       _checkForNetworkError(e);
//       rethrow;
//     }
//   }

//   /// Google Sign In Logic
//   Future<void> signInWithGoogle() async {
//     try {
//       // 1. Check Internet before starting (Optional optimization)
//       try {
//         final result = await InternetAddress.lookup('google.com');
//         if (result.isEmpty || result[0].rawAddress.isEmpty) {
//           throw 'No internet connection.';
//         }
//       } catch (_) {
//         throw 'No internet connection. Please check your data bundle.';
//       }

//       // 2. Setup Google Sign In
//       GoogleSignIn googleSignIn;
//       // Avoid passing empty client IDs which can cause a platform-specific failure
//       if (ClientID.iosClientId.isNotEmpty || ClientID.webClientId.isNotEmpty) {
//         googleSignIn = GoogleSignIn(
//           clientId: ClientID.iosClientId.isNotEmpty
//               ? ClientID.iosClientId
//               : null,
//           serverClientId: ClientID.webClientId.isNotEmpty
//               ? ClientID.webClientId
//               : null,
//         );
//       } else {
//         // Let the plugin use its defaults (works on Android with manifest config)
//         googleSignIn = GoogleSignIn();
//       }

//       // 3. Trigger the native Google Sign-In flow
//       final googleUser = await googleSignIn.signIn();

//       // If user cancelled the popup, just return
//       if (googleUser == null) return;

//       // 4. Obtain the auth details (tokens)
//       final googleAuth = await googleUser.authentication;
//       final accessToken = googleAuth.accessToken;
//       final idToken = googleAuth.idToken;

//       if (accessToken == null) {
//         throw 'No Access Token found.';
//       }
//       if (idToken == null) {
//         throw 'No ID Token found.';
//       }

//       // 5. Sign in to Supabase using the tokens
//       final AuthResponse response = await supabase.auth.signInWithIdToken(
//         provider: OAuthProvider.google,
//         idToken: idToken,
//         accessToken: accessToken,
//       );

//       // 6. Check if this is a new user and add to 'nexususers' if needed
//       if (response.user != null) {
//         final userId = response.user!.id;
//         final email = response.user!.email;

//         // Google provides metadata like full_name and avatar_url
//         final meta = response.user!.userMetadata;
//         final name = meta?['full_name'] ?? meta?['name'] ?? 'Google User';
//         final avatarUrl = meta?['avatar_url'] ?? meta?['picture'];

//         // Check if user already exists
//         final existingUser = await supabase
//             .from('nexususers')
//             .select()
//             .eq('id', userId)
//             .maybeSingle();

//         // INSERT only if they don't exist
//         if (existingUser == null) {
//           await supabase.from('nexususers').insert({
//             'id': userId,
//             'name': name,
//             'email': email,
//             'avatar_url': avatarUrl,
//           });
//         }
//       }
//     } on AuthException {
//       rethrow;
//     } on SocketException {
//       // 🔥 Catch explicit network/socket errors
//       throw 'No internet connection. Please check your data bundle.';
//     } catch (e) {
//       // 🔥 Catch wrapped "Connection reset" errors
//       _checkForNetworkError(e);
//       rethrow;
//     }
//   }

//   /// Send a password reset link to an email
//   Future<void> sendPasswordReset(String email) async {
//     try {
//       await supabase.auth.resetPasswordForEmail(email);
//     } on AuthException {
//       rethrow;
//     } on SocketException {
//       throw 'No internet connection. Please check your data bundle.';
//     } catch (e) {
//       _checkForNetworkError(e);
//       rethrow;
//     }
//   }

//   /// Log out the current user
//   Future<void> logout() async {
//     try {
//       if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
//         try {
//           final GoogleSignIn googleSignIn = GoogleSignIn();
//           await googleSignIn.signOut();
//         } catch (e) {
//           debugPrint("Google Sign Out warning: $e");
//         }
//       }

//       await supabase.auth.signOut();
//       _currentUser = null;
//       notifyListeners();
//     } on AuthException {
//       rethrow;
//     } catch (e) {
//       rethrow;
//     }
//   }

//   /// Helper to check for common network error strings
//   void _checkForNetworkError(Object e) {
//     final errorMsg = e.toString().toLowerCase();
//     if (errorMsg.contains('socketexception') ||
//         errorMsg.contains('connection reset') ||
//         errorMsg.contains('network is unreachable') ||
//         errorMsg.contains('clientexception')) {
//       throw 'No internet connection. Please check your data bundle.';
//     }
//   }
// }
