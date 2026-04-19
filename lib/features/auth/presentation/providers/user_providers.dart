import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/user_repository.dart';
import '../../../inventory/presentation/providers/inventory_notifier.dart';

import 'package:supabase_flutter/supabase_flutter.dart' as sb;

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(
    ref.watch(databaseProvider),
    sb.Supabase.instance.client,
  );
});
