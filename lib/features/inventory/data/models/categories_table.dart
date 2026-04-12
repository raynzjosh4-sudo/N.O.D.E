import 'package:drift/drift.dart';

@DataClassName('CategoryEntry')
class CategoriesTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 255)();
  TextColumn get parentId => text().nullable()(); // For recursive trees
  IntColumn get level => integer().withDefault(Constant(0))();

  // --- Sync Pillars ---
  BoolColumn get isDirty => boolean().withDefault(Constant(false))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
