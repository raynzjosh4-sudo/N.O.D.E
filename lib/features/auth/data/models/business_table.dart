import 'package:drift/drift.dart';

@DataClassName('BusinessEntry')
class BusinessTable extends Table {
  TextColumn get id => text()();
  TextColumn get legalName => text()();
  TextColumn get tin => text().withLength(min: 9, max: 15)();
  TextColumn get registrationNo => text()();
  TextColumn get tier => text()(); // Store enum as String
  TextColumn get status => text()(); 

  // Logistics
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  TextColumn get region => text()();
  TextColumn get physicalAddress => text()();

  // Financials
  RealColumn get creditLimit => real().withDefault(Constant(0))();
  RealColumn get currentBalance => real().withDefault(Constant(0))();
  TextColumn get primaryMoMoNumber => text()();

  // SEO
  TextColumn get slug => text()();
  TextColumn get description => text()();
  TextColumn get logoUrl => text().nullable()();

  // --- Sync Pillars ---
  BoolColumn get isDirty => boolean().withDefault(Constant(false))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
