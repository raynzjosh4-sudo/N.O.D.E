import 'package:drift/drift.dart';

@DataClassName('WholesaleOrderEntry')
class OrdersTable extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get userId => text()(); // Link to UsersTable
  
  // Serialized List<ProductOrderEntry>
  TextColumn get itemsJson => text()(); 
  
  RealColumn get totalAmount => real()();
  IntColumn get totalUnits => integer()();
  
  TextColumn get status => text().withDefault(const Constant('PROCESSING'))();
  BoolColumn get isDraft => boolean().withDefault(const Constant(false))();
  
  TextColumn get pdfId => text().nullable()(); // Link to GeneratedPdfsTable
  TextColumn get productId => text().nullable()(); // Direct lookup for button state
  TextColumn get supplierId => text().nullable()(); // For supplier-specific logic
  
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
