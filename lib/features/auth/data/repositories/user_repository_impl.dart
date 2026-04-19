import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import '../../../../core/database/app_database.dart';
import '../../../../core/error/failure.dart';
import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final AppDatabase database;
  final sb.SupabaseClient supabase;

  UserRepositoryImpl(this.database, this.supabase);

  @override
  Future<Either<Failure, UserEntry?>> getUser() async {
    try {
      final user = await (database.select(
        database.usersTable,
      )..limit(1)).getSingleOrNull();
      return Right(user);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveUser(UserEntry user) async {
    try {
      // 1. Save locally
      await database.into(database.usersTable).insertOnConflictUpdate(user);

      // 2. Sync to Supabase
      await supabase.from('users_table').upsert({
        'id': user.id,
        'full_name': user.fullName,
        'email': user.email,
        'role': user.role,
        'profile_pic_url': user.profilePicUrl,
      });

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveProfile({
    required UserEntry user,
    required BusinessTableCompanion business,
  }) async {
    try {
      // 1. Save Locally
      await database.transaction(() async {
        await database.into(database.usersTable).insertOnConflictUpdate(user);
        await database
            .into(database.businessTable)
            .insertOnConflictUpdate(business);
      });

      // 2. Push to Supabase
      await supabase.from('users_table').upsert({
        'id': user.id,
        'full_name': user.fullName,
        'email': user.email,
        'role': user.role,
        'profile_pic_url': user.profilePicUrl,
      });

      await supabase.from('business_table').upsert({
        'user_id': business.id.value,
        'legal_name': business.legalName.value,

        'latitude': business.latitude.value,
        'longitude': business.longitude.value,
        'region': business.region.value,
        'city': business.city.value,
        'physical_address': business.physicalAddress.value,
        'phone_number': business.phoneNumber.value,
      });

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateEmail(String newEmail) async {
    try {
      await supabase.auth.updateUser(sb.UserAttributes(email: newEmail));
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
