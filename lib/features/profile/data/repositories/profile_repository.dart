import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../../../../core/database/app_database.dart';
import '../../../../core/database/database_provider.dart';
import '../../../../core/error/failure.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(
    ref.watch(databaseProvider),
    sb.Supabase.instance.client,
  );
});

class ProfileRepository {
  final AppDatabase _db;
  final sb.SupabaseClient _supabase;

  // 🔒 Concurrency Lock: Prevents multiple syncProfile calls from
  // overlapping and fighting over the database transaction.
  bool _isSyncing = false;

  ProfileRepository(this._db, this._supabase);

  Future<void> _upsertLocalUser(
    String userId,
    Map<String, dynamic> userData,
  ) async {
    await _db
        .into(_db.usersTable)
        .insertOnConflictUpdate(
          UsersTableCompanion.insert(
            id: userId,
            fullName: userData['full_name'] ?? 'No Name',
            email: Value(userData['email']),
            role: Value(userData['role'] ?? 'customer'),
            profilePicUrl: Value(userData['profile_pic_url']),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }

  /// 🔄 Syncs both User and Business profiles from Supabase to Drift.
  Future<Either<Failure, void>> syncProfile(String userId) async {
    if (_isSyncing) {
      debugPrint('👉 [ProfileRepo] Sync already in progress. Skipping...');
      return const Right(null);
    }

    _isSyncing = true;
    debugPrint('👉 [ProfileRepo] Syncing profile for user: $userId');

    try {
      // 1. Fetch User Data from Supabase (maybeSingle to avoid crashes)
      final userDataResult = await _supabase
          .from('users_table')
          .select()
          .eq('id', userId)
          .maybeSingle();

      Map<String, dynamic> userData;

      if (userDataResult == null) {
        debugPrint('⚠️ [ProfileRepo] User missing in public table. Seeding...');
        final currentUser = _supabase.auth.currentUser;
        userData = {
          'id': userId,
          'full_name': currentUser?.userMetadata?['full_name'] ?? 'No Name',
          'email': currentUser?.email,
          'role': 'customer',
          'profile_pic_url': currentUser?.userMetadata?['avatar_url'],
        };

        // Seed to Supabase so it exists for next time
        await _supabase.from('users_table').upsert(userData);
      } else {
        userData = userDataResult;
      }

      // 2. Fetch Business Data from Supabase (nullable)
      final businessDataResult = await _supabase
          .from('business_table')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      // 3 & 4. Wrap all local writes in a single transaction to prevent
      // SQLite "database is locked" errors from concurrent write access.
      await _db.transaction(() async {
        // Upsert into Drift (UsersTable)
        await _upsertLocalUser(userId, userData);

        // Upsert into Drift (BusinessTable) if exists
        if (businessDataResult != null) {
          await _db
              .into(_db.businessTable)
              .insertOnConflictUpdate(
                BusinessTableCompanion.insert(
                  id: userId,
                  legalName: businessDataResult['legal_name'],
                  phoneNumber: Value(businessDataResult['phone_number']),
                  physicalAddress: Value(
                    businessDataResult['physical_address'],
                  ),
                  city: Value(businessDataResult['city']),
                  region: Value(businessDataResult['region']),
                  latitude: Value(businessDataResult['latitude']?.toDouble()),
                  longitude: Value(businessDataResult['longitude']?.toDouble()),
                  updatedAt: businessDataResult['updated_at'] != null
                      ? Value(
                          DateTime.parse(
                            businessDataResult['updated_at'] as String,
                          ),
                        )
                      : const Value.absent(),
                ),
              );
        }
      });

      debugPrint('✅ [ProfileRepo] Profile sync SUCCESS');
      return const Right(null);
    } catch (e) {
      debugPrint('❌ [ProfileRepo] Sync ERROR: $e');
      return Left(Failure.fromException(e));
    } finally {
      _isSyncing = false;
    }
  }

  /// 👂 Watches the local Drift user.
  Stream<UserEntry?> watchUser(String userId) {
    return (_db.select(
      _db.usersTable,
    )..where((t) => t.id.equals(userId))).watchSingleOrNull();
  }

  /// 👂 Watches the local Drift business record.
  Stream<BusinessEntry?> watchBusiness(String userId) {
    return (_db.select(
      _db.businessTable,
    )..where((t) => t.id.equals(userId))).watchSingleOrNull();
  }
}
