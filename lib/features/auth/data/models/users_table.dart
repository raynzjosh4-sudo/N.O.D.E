import 'package:drift/drift.dart';

@DataClassName('UserEntry')
class UsersTable extends Table {
  TextColumn get id => text()();
  TextColumn get fullName => text()();
  TextColumn get email => text().nullable()();
  TextColumn get role => text().withDefault(const Constant('customer'))();
  TextColumn get profilePicUrl => text().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
