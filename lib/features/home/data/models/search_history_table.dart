import 'package:drift/drift.dart';

@DataClassName('SearchHistoryEntry')
class SearchHistoryTable extends Table {
  TextColumn get id => text()(); // UUID String
  TextColumn get userId => text()(); 
  TextColumn get query => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
