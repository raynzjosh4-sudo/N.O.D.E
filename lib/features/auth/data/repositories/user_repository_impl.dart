import 'package:fpdart/fpdart.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/error/failure.dart';
import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final AppDatabase database;

  UserRepositoryImpl(this.database);

  @override
  Future<Either<Failure, UserEntry?>> getUser() async {
    try {
      final user = await (database.select(database.usersTable)..limit(1)).getSingleOrNull();
      return Right(user);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveUser(UserEntry user) async {
    try {
      await database.into(database.usersTable).insertOnConflictUpdate(user);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
