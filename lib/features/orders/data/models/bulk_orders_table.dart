import 'package:drift/drift.dart';

@DataClassName('BulkOrderEntry')
class BulkOrdersTable extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get groupName => text().nullable()();
  TextColumn get productName => text()();
  TextColumn get brand => text().nullable()();
  TextColumn get category => text()();
  TextColumn get subCategory => text()();
  TextColumn get imageUrl => text().nullable()();
  TextColumn get availableColorsJson => text().nullable()();
  TextColumn get availableSizesJson => text().nullable()();
  TextColumn get variantLabel => text()();
  TextColumn get configJson => text()(); // List of ColorGroup serialized
  IntColumn get totalUnits => integer()();
  
  // --- New Metadata for full persistence ---
  RealColumn get srp => real().withDefault(const Constant(0.0))();
  TextColumn get priceTiersJson => text().nullable()();
  TextColumn get availableMaterialsJson => text().nullable()();
  IntColumn get currentStock => integer().withDefault(const Constant(0))();
  IntColumn get leadTimeDays => integer().withDefault(const Constant(0))();
  TextColumn get seoDescription => text().nullable()();
  TextColumn get tradingTermsJson => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
