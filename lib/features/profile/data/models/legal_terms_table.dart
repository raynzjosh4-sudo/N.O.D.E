import 'package:drift/drift.dart';

@DataClassName('LegalTermEntry')
class LegalTermsTable extends Table {
  TextColumn get id => text()(); // 'tos', 'privacy'
  TextColumn get title => text()();
  TextColumn get content => text()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
