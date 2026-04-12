import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/database/app_database.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/user_repository.dart';
import '../../../inventory/presentation/providers/inventory_notifier.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImpl(ref.watch(databaseProvider));
});

final userProfileProvider = FutureProvider<UserEntry?>((ref) async {
  final repository = ref.watch(userRepositoryProvider);
  final result = await repository.getUser();
  return result.fold((failure) => null, (user) => user);
});
