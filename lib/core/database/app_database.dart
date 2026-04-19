import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import 'package:path/path.dart' as p;
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import '../../features/inventory/data/models/products_table.dart';
import '../../features/inventory/data/models/categories_table.dart';
import '../../features/inventory/data/models/price_tiers_table.dart';
import '../../features/inventory/data/models/trading_terms_table.dart';
import '../../features/auth/data/models/business_table.dart';
import '../../features/auth/data/models/users_table.dart';
import '../../features/orders/data/models/bulk_orders_table.dart';
import '../../features/orders/data/models/orders_table.dart';
import '../../features/profile/data/models/generated_pdfs_table.dart';
import '../../features/profile/data/models/legal_terms_table.dart';
import '../../features/home/data/models/search_history_table.dart';
import '../../features/home/data/models/promotions_table.dart';

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
    PromotionsTable,
    TradingTermsTable,
    LegalTermsTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_executor);

  @override
  int get schemaVersion => 28;

  // 🔒 Singleton Executor: Ensures only ONE connection exists for the whole app session.
  // This prevents multiple background isolates from fighting over the database file.
  static final QueryExecutor _executor = LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'node_wholesale.sqlite'));

    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    return NativeDatabase.createInBackground(
      file,
      setup: (database) {
        // WAL allows multiple concurrent readers and one writer
        database.execute('PRAGMA journal_mode=WAL;');
        // Wait up to 5s if the DB is busy before failing
        database.execute('PRAGMA busy_timeout=5000;');
      },
    );
  });

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
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
      if (from < 16) {
        // v16: Schema alignment for Users and Business tables
        await m.deleteTable('users_table');
        await m.deleteTable('business_table');
        await m.createTable(usersTable);
        await m.createTable(businessTable);
      }
      if (from < 18) {
        // v18: Simplified Business Schema (No TIN/RegNo, specific logistcs columns)
        await m.deleteTable('users_table');
        await m.deleteTable('business_table');
        await m.createTable(usersTable);
        await m.createTable(businessTable);
      }
      if (from < 19) {
        // v19: Cloud-Synced Search History (UUID IDs + UserId)
        await m.deleteTable('search_history_table');
        await m.createTable(searchHistoryTable);
      }
      if (from < 20) {
        // v20: Align products_table with real-time Supabase schema
        // Drops and recreates to ensure supplier_json and support_json exist
        await m.deleteTable('products_table');
        await m.createTable(productsTable);
      }
      if (from < 21) {
        // v21: fix categories table
        await m.deleteTable('categories_table');
        await m.createTable(categoriesTable);
      }
      if (from < 22) {
        // v22: Add promotions_table
        await m.createTable(promotionsTable);
      }
      if (from < 23) {
        // v23: Add priority and usageCount to categories_table
        try {
          await m.addColumn(categoriesTable, categoriesTable.priority);
        } catch (e) {
          debugPrint(
            'ℹ️ [Migration] priority column already exists, skipping.',
          );
        }
        try {
          await m.addColumn(categoriesTable, categoriesTable.usageCount);
        } catch (e) {
          debugPrint(
            'ℹ️ [Migration] usageCount column already exists, skipping.',
          );
        }
      }

      if (from < 24) {
        // v24: Add trading_terms_table
        await m.createTable(tradingTermsTable);
      }
      if (from < 25) {
        // v25: Add legal_terms_table
        await m.createTable(legalTermsTable);
      }
      if (from < 26) {
        // v26: Add productId and supplierId to ordersTable
        try {
          await m.addColumn(ordersTable, ordersTable.productId);
        } catch (e) {
          debugPrint(
            'ℹ️ [Migration] productId column already exists, skipping.',
          );
        }
        try {
          await m.addColumn(ordersTable, ordersTable.supplierId);
        } catch (e) {
          debugPrint(
            'ℹ️ [Migration] supplierId column already exists, skipping.',
          );
        }
      }

      if (from < 27) {
        // v27: CRITICAL - Add updatedAt column if missing
        try {
          await m.addColumn(ordersTable, ordersTable.updatedAt);
        } catch (e) {
          // If the column already exists, we can safely ignore this error
          print('ℹ️ [Migration] updatedAt column already exists, skipping.');
        }
      }

      if (from < 28) {
        // v28: Add aspectRatio to productsTable
        try {
          await m.addColumn(productsTable, productsTable.aspectRatio);
        } catch (e) {
          print('ℹ️ [Migration] aspectRatio column already exists, skipping.');
        }
      }
    },
  );

  /// 🧹 Clear all local user data
  /// Used during account deletion to ensure privacy.
  Future<void> wipeAllData() async {
    await transaction(() async {
      for (final table in allTables) {
        await delete(table).go();
      }
    });
  }
}
