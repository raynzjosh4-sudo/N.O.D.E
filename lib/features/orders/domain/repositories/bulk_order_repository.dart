import 'package:fpdart/fpdart.dart';
import 'package:node_app/core/database/app_database.dart';
import 'package:node_app/core/error/failure.dart';
import 'package:node_app/features/home/presentation/pages/specificationorderpage/order_models.dart';
import 'package:node_app/features/inventory/domain/entities/product_attributes.dart';

abstract class BulkOrderRepository {
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
  });

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
  });

  Future<Either<Failure, List<BulkOrderEntry>>> getBulkOrders();

  Future<Either<Failure, void>> deleteBulkOrder(String id);
}
