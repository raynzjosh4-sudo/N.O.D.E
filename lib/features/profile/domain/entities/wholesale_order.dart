import 'package:equatable/equatable.dart';
import 'package:node_app/features/profile/domain/entities/saved_product.dart';
import 'package:node_app/features/home/presentation/pages/specificationorderpage/order_models.dart';
import 'package:node_app/core/utils/color_utils.dart';
import 'order_status.dart';

class ProductOrderEntry extends Equatable {
  final SavedProduct savedProduct;
  final List<ColorGroup> confirmedGroups;

  const ProductOrderEntry({
    required this.savedProduct,
    required this.confirmedGroups,
  });

  int get totalUnits => confirmedGroups.fold(
        0,
        (sum, g) => sum + g.sizeQtys.values.fold(0, (s, q) => s + q),
      );

  double get totalAmount {
    double total = 0;
    for (var group in confirmedGroups) {
      final groupQty = group.sizeQtys.values.fold(0, (s, q) => s + q);
      final unitPrice = savedProduct.product.getPriceForQuantity(groupQty);
      total += unitPrice * groupQty;
    }
    return total;
  }

  Map<String, dynamic> toMap() {
    return {
      'savedProduct': savedProduct.toMap(),
      'confirmedGroups': confirmedGroups.map((g) => {
        'color': {
          'label': g.color.label,
          'hex': ColorUtils.toHex(g.color.color),
        },
        'sizeQtys': g.sizeQtys,
      }).toList(),
    };
  }

  @override
  List<Object?> get props => [savedProduct, confirmedGroups];
}

class WholesaleOrder extends Equatable {
  final String id;
  final DateTime date;
  final List<ProductOrderEntry> entries;
  final OrderStatus status;
  final String? pdfId;

  const WholesaleOrder({
    required this.id,
    required this.date,
    required this.entries,
    required this.status,
    this.pdfId,
  });

  int get totalItems => entries.length;
  int get totalUnits => entries.fold(0, (sum, e) => sum + e.totalUnits);
  double get totalAmount => entries.fold(0, (sum, e) => sum + e.totalAmount);

  @override
  List<Object?> get props => [id, date, entries, status, pdfId];
}
