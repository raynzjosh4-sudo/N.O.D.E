import 'package:drift/drift.dart';

@DataClassName('CategoryEntry')
class CategoriesTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withLength(min: 1, max: 255)();
  TextColumn get parentId => text().nullable()(); // For recursive trees
  IntColumn get level => integer().withDefault(Constant(0))();
  
  TextColumn get imageUrl => text().nullable()();
  IntColumn get itemCount => integer().withDefault(Constant(0))();
  IntColumn get priority => integer().withDefault(Constant(0))();
  IntColumn get usageCount => integer().withDefault(Constant(0))();

  // --- Sync Pillars ---
  BoolColumn get isDirty => boolean().withDefault(Constant(false))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
