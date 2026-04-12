import 'dart:convert';
import 'package:drift/drift.dart' as drift;
import 'package:fpdart/fpdart.dart';
import 'package:node_app/features/inventory/domain/entities/product_attributes.dart';
import 'package:node_app/features/orders/data/models/bulk_orders_table.dart';
import 'package:node_app/features/orders/domain/repositories/bulk_order_repository.dart';
import 'package:uuid/uuid.dart';

import 'package:node_app/core/database/app_database.dart';
import 'package:node_app/core/error/failure.dart';
import 'package:node_app/features/home/presentation/pages/specificationorderpage/order_models.dart';
import 'package:node_app/core/utils/color_utils.dart';

class BulkOrderRepositoryImpl implements BulkOrderRepository {
  final AppDatabase database;

  BulkOrderRepositoryImpl(this.database);

  @override
  Future<Either<Failure, void>> saveBulkOrder({
    required String groupName,
    required String productName,
    required String brand,
    required String category,
    required String subCategory,
    String? imageUrl,
    required List<ProductColor> availableColors,
    required List<ProductSize> availableSizes,
    List<ProductMaterial>? availableMaterials,
    double? srp,
    String? priceTiersJson,
    int? currentStock,
    int? leadTimeDays,
    String? seoDescription,
    String? tradingTermsJson,
    required String variantLabel,
    required List<ColorGroup> confirmedGroups,
  }) async {
    try {
      final id = const Uuid().v4();
      int totalUnits = 0;

      // Map configuration to JSON serializable objects
      final serializedGroups = confirmedGroups.map((g) {
        final unitsInGroup = g.sizeQtys.values.fold(0, (sum, q) => sum + q);
        totalUnits += unitsInGroup as int;

        return {
          'name': g.color.label,
          'hexCode': ColorUtils.toHex(g.color.color),
          'sizeQtys': g.sizeQtys,
        };
      }).toList();

      final String configJson = jsonEncode(serializedGroups);

      await database
          .into(database.bulkOrdersTable)
          .insert(
            BulkOrdersTableCompanion.insert(
              id: id,
              groupName: drift.Value(groupName),
              productName: productName,
              brand: drift.Value(brand),
              category: category,
              subCategory: subCategory,
              imageUrl: drift.Value(imageUrl),
              availableColorsJson: drift.Value(
                jsonEncode(availableColors.map((c) => c.toJson()).toList()),
              ),
              availableSizesJson: drift.Value(
                jsonEncode(availableSizes.map((s) => s.toJson()).toList()),
              ),
              availableMaterialsJson: drift.Value(
                jsonEncode(
                  (availableMaterials ?? []).map((m) => m.toJson()).toList(),
                ),
              ),
              srp: drift.Value(srp ?? 0.0),
              priceTiersJson: drift.Value(priceTiersJson),
              currentStock: drift.Value(currentStock ?? 0),
              leadTimeDays: drift.Value(leadTimeDays ?? 0),
              seoDescription: drift.Value(seoDescription),
              tradingTermsJson: drift.Value(tradingTermsJson),
              variantLabel: variantLabel,
              configJson: configJson,
              totalUnits: totalUnits,
            ),
          );

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> quickAddBulkOrder({
    required String productName,
    required String brand,
    required String category,
    required String subCategory,
    String? imageUrl,
    required List<ProductColor> availableColors,
    required List<ProductSize> availableSizes,
    required String variantLabel,
    required int totalUnits,
    double? srp,
  }) async {
    try {
      final id = const Uuid().v4();

      // Create a "Generic" configuration for quick add
      final serializedGroups = [
        {
          'colorName': 'Generic/Assorted',
          'hexCode': 'FF808080', // Gray
          'sizeQtys': {'Total': totalUnits},
        },
      ];

      final String configJson = jsonEncode(serializedGroups);

      await database
          .into(database.bulkOrdersTable)
          .insert(
            BulkOrdersTableCompanion.insert(
              id: id,
              groupName: drift.Value('Quick Add'),
              productName: productName,
              brand: drift.Value(brand),
              category: category,
              subCategory: subCategory,
              imageUrl: drift.Value(imageUrl),
              availableColorsJson: drift.Value(
                jsonEncode(availableColors.map((c) => c.toJson()).toList()),
              ),
              availableSizesJson: drift.Value(
                jsonEncode(availableSizes.map((s) => s.toJson()).toList()),
              ),
              srp: drift.Value(srp ?? 0.0),
              variantLabel: variantLabel,
              configJson: configJson,
              totalUnits: totalUnits,
            ),
          );

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BulkOrderEntry>>> getBulkOrders() async {
    try {
      final orders = await database.select(database.bulkOrdersTable).get();
      return Right(orders);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBulkOrder(String id) async {
    try {
      await (database.delete(
        database.bulkOrdersTable,
      )..where((t) => t.id.equals(id))).go();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
