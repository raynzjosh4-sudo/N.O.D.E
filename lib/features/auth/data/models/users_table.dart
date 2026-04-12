import 'package:drift/drift.dart';

@DataClassName('UserEntry')
class UsersTable extends Table {
  TextColumn get id => text()();
  TextColumn get fullName => text()();
  TextColumn get phoneNumber => text()();
  TextColumn get address => text()();
  TextColumn get city => text()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
