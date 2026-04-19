import 'package:drift/drift.dart';

@DataClassName('BusinessEntry')
class BusinessTable extends Table {
  TextColumn get id => text()(); // Mapped to user_id in sync
  TextColumn get legalName => text()();
  
  // Logistics - Direct Match with SQL
  TextColumn get phoneNumber => text().nullable()();
  RealColumn get latitude => real().nullable()();
  RealColumn get longitude => real().nullable()();
  TextColumn get region => text().nullable()();
  TextColumn get city => text().nullable()();
  TextColumn get physicalAddress => text().nullable()();

  // --- Sync Pillars ---
  DateTimeColumn get updatedAt => dateTime().named('updated_at').nullable().withDefault(currentDateAndTime)();
  BoolColumn get isDirty => boolean().withDefault(Constant(false))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
