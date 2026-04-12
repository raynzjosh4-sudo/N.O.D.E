import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import '../../features/inventory/data/models/products_table.dart';
import '../../features/inventory/data/models/categories_table.dart';
import '../../features/inventory/data/models/price_tiers_table.dart';
import '../../features/auth/data/models/business_table.dart';
import '../../features/auth/data/models/users_table.dart';
import '../../features/orders/data/models/bulk_orders_table.dart';
import '../../features/orders/data/models/orders_table.dart';
import '../../features/profile/data/models/generated_pdfs_table.dart';
import '../../features/home/data/models/search_history_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    ProductsTable,
    CategoriesTable,
    PriceTiersTable,
    BusinessTable,
    UsersTable,
    BulkOrdersTable,
    OrdersTable,
    GeneratedPdfsTable,
    SearchHistoryTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 15;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (m, from, to) async {
      if (from < 7) {
        await m.createTable(bulkOrdersTable);
      } else {
        if (from == 7) {
          await m.addColumn(bulkOrdersTable, bulkOrdersTable.groupName);
        }
        if (from < 9) {
          await m.addColumn(bulkOrdersTable, bulkOrdersTable.brand);
          await m.addColumn(
            bulkOrdersTable,
            bulkOrdersTable.availableColorsJson,
          );
          await m.addColumn(
            bulkOrdersTable,
            bulkOrdersTable.availableSizesJson,
          );
        }
      }
      if (from < 10) {
        await m.createTable(usersTable);
        await m.createTable(ordersTable);
      }
      if (from < 11) {
        // Migrating ordersTable to the new multi-product structure
        await m.deleteTable('orders_table');
        await m.createTable(ordersTable);
      }
      if (from < 12) {
        await m.createTable(generatedPdfsTable);
      }
      if (from < 13) {
        // Development Fix: Recreate orders table to ensure pdf_id exists
        // Since data is minimal in dev, we drop and recreate to avoid column mismatch errors
        await m.deleteTable('orders_table');
        await m.createTable(ordersTable);
      }
      if (from < 14) {
        // Add metadata columns to BulkOrdersTable
        await m.addColumn(bulkOrdersTable, bulkOrdersTable.srp);
        await m.addColumn(bulkOrdersTable, bulkOrdersTable.priceTiersJson);
        await m.addColumn(
          bulkOrdersTable,
          bulkOrdersTable.availableMaterialsJson,
        );
        await m.addColumn(bulkOrdersTable, bulkOrdersTable.currentStock);
        await m.addColumn(bulkOrdersTable, bulkOrdersTable.leadTimeDays);
        await m.addColumn(bulkOrdersTable, bulkOrdersTable.seoDescription);
        await m.addColumn(bulkOrdersTable, bulkOrdersTable.tradingTermsJson);
      }
      if (from < 15) {
        await m.createTable(searchHistoryTable);
      }
    },
  );

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'node_wholesale.sqlite'));

      if (Platform.isAndroid) {
        // THIS is what physically copies the .so file into the folder it's crying about
        await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
      }

      return NativeDatabase.createInBackground(file);
    });
  }
}
