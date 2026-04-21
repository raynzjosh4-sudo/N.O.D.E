import 'package:drift/drift.dart';

@DataClassName('RecordEntry')
class RecordsTable extends Table {
  TextColumn get id => text()();
  
  // JSON serialized columns for modular pieces
  TextColumn get detailJson => text().nullable()();
  TextColumn get recordsHistoryJson => text().withDefault(const Constant('[]'))();
  TextColumn get dataJson => text().nullable()();
  TextColumn get reminderJson => text().nullable()();
  
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
