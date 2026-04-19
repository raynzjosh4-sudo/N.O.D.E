import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../auth/presentation/providers/auth_state_provider.dart';
import '../../data/repositories/profile_repository.dart';
import '../../../../core/database/app_database.dart';

/// 👤 Provider for the current User Entry from Drift
final userProfileProvider = StreamProvider<UserEntry?>((ref) {
  // We watch the auth state to get the current user ID
  final authState = ref.watch(authStateProvider).value;
  final userId =
      authState?.session?.user.id ??
      Supabase.instance.client.auth.currentUser?.id;

  if (userId == null) return Stream.value(null);

  final repo = ref.watch(profileRepositoryProvider);
  return repo.watchUser(userId);
});

/// 🏢 Provider for the current Business Entry from Drift
final userBusinessProvider = StreamProvider<BusinessEntry?>((ref) {
  final authState = ref.watch(authStateProvider).value;
  final userId =
      authState?.session?.user.id ??
      Supabase.instance.client.auth.currentUser?.id;

  if (userId == null) return Stream.value(null);

  final repo = ref.watch(profileRepositoryProvider);
  return repo.watchBusiness(userId);
});
