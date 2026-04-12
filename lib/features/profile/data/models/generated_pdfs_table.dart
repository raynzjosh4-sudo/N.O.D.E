import 'package:drift/drift.dart';

@DataClassName('GeneratedPdfEntry')
class GeneratedPdfsTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get title => text()();
  TextColumn get filePath => text()();
  TextColumn get fileSize => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
