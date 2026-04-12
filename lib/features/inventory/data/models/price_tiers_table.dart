import 'package:drift/drift.dart';

@DataClassName('PriceTierEntry')
class PriceTiersTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get productId => text()(); // Links to ProductsTable
  IntColumn get quantity => integer()();
  RealColumn get price => real()();
}
