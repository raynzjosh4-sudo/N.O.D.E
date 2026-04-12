import 'package:drift/drift.dart';

@DataClassName('ProductEntry')
class ProductsTable extends Table {
  TextColumn get id => text()();
  TextColumn get sku => text()();
  TextColumn get name => text().withLength(min: 1, max: 255)();
  TextColumn get brand => text()();
  RealColumn get srp => real()();
  TextColumn get priceTiers => text()(); // List<PriceTier> JSON
  
  // --- Logistics & Customs ---
  TextColumn get hsCode => text()();
  RealColumn get weightKg => real()();
  RealColumn get volumeCbm => real()();
  TextColumn get originCountry => text()();

  // --- Compliance & Trust ---
  TextColumn get unbsNumber => text()();
  TextColumn get denier => text()();
  TextColumn get material => text()();

  // --- Supply Chain ---
  TextColumn get supplierId => text()();
  TextColumn get supplierJson => text()(); // Full nested Supplier object JSON
  TextColumn get categoryId => text()();
  IntColumn get currentStock => integer()();
  IntColumn get leadTimeDays => integer()();
  TextColumn get warehouseLoc => text()();

  // --- Advanced SEO & Search ---
  TextColumn get seoTitle => text()();
  TextColumn get seoDescription => text()();
  TextColumn get searchKeywords => text()(); // Space separated
  TextColumn get slug => text()();
  TextColumn get imageUrl => text()();
  TextColumn get mediaUrls => text().nullable()();
  
  // --- Rich Attributes (JSON) ---
  TextColumn get availableColors => text().nullable()();
  TextColumn get availableSizes => text().nullable()();
  TextColumn get availableMaterials => text().nullable()();
  TextColumn get supportJson => text().nullable()();
  TextColumn get tradingTermsJson => text().nullable()();

  // --- Sync Pillars ---
  BoolColumn get isDirty => boolean().withDefault(Constant(false))();
  DateTimeColumn get lastSyncedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
