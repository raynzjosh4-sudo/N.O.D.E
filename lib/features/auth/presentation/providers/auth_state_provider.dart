import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:node_app/core/services/device_token_service.dart';

/// A provider that listens to the real-time Supabase auth state.
/// This allows us to decouple auth logic from the UI.
final authStateProvider = StreamProvider<AuthState>((ref) {
  debugPrint('🔄 [Provider] Initializing Auth State Listener...');
  return Supabase.instance.client.auth.onAuthStateChange;
});

/// A provider that simply returns true if the user is authenticated.
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider).value;
  final session = Supabase.instance.client.auth.currentSession;
  
  final authenticated = session != null || (authState?.session != null);
  debugPrint('🔍 [Provider] Auth Check: ${authenticated ? 'LOGGED IN' : 'GUEST'}');
  return authenticated;
});

/// 🌉 A bridge that converts the Auth Stream to a Listenable for GoRouter
final routerNotifierProvider = Provider<RouterNotifier>((ref) {
  return RouterNotifier(ref);
});

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;
  
  RouterNotifier(this._ref) {
    // 👂 Listen to the auth state and notify the router whenever it changes
    _ref.listen(authStateProvider, (_, state) {
       final authState = state.value;
       
       // Automatically sync device token into PostgreSQL when session is active
       if (authState != null && 
           (authState.event == AuthChangeEvent.signedIn || 
            authState.event == AuthChangeEvent.initialSession)) {
          final user = authState.session?.user;
          if (user != null) {
            _ref.read(deviceTokenServiceProvider).syncDeviceToken(user.id);
          }
       }

       debugPrint('🔔 [RouterNotifier] Auth state changed. Notifying listeners...');
       notifyListeners();
    });
  }

  bool get isAuthenticated => _ref.read(isAuthenticatedProvider);
}
