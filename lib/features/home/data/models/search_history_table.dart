import 'package:drift/drift.dart';

@DataClassName('SearchHistoryEntry')
class SearchHistoryTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get query => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
