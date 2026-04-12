import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/database/app_database.dart';

abstract class UserRepository {
  Future<Either<Failure, UserEntry?>> getUser();
  Future<Either<Failure, void>> saveUser(UserEntry user);
}
