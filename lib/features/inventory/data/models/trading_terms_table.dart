import 'package:drift/drift.dart';

@DataClassName('TradingTermsEntry')
class TradingTermsTable extends Table {
  TextColumn get id => text()();
  TextColumn get content => text()();
  TextColumn get moq => text().nullable()();
  TextColumn get warranty => text().nullable()();
  TextColumn get paymentTerms => text().nullable()();
  TextColumn get deliveryTerms => text().nullable()();

  // --- Metadata ---
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  
  @override
  Set<Column> get primaryKey => {id};
}
