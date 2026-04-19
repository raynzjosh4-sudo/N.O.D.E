import 'package:equatable/equatable.dart';
import 'package:node_app/features/inventory/domain/entities/product.dart';

class SavedProduct extends Equatable {
  final String? id;
  final Product product;
  final int quantity;
  final String? selectedColor;
  final String? selectedSize;

  const SavedProduct({
    this.id,
    required this.product,
    required this.quantity,
    this.selectedColor,
    this.selectedSize,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': product.id,
      'productName': product.name,
      'sku': product.sku,
      'brand': product.brand,
      'imageUrl': product.imageUrl,
      'srp': product.srp,
      'quantity': quantity,
      'selectedColor': selectedColor,
      'selectedSize': selectedSize,
      'category': product.categoryId,
      'currentStock': product.currentStock,
      'leadTimeDays': product.leadTimeDays,
      'seoDescription': product.seoDescription,
      'tradingTerms': product.tradingTerms.toJson(),
      'priceTiers': product.priceTiers.map((t) => t.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [id, product, quantity, selectedColor, selectedSize];
}
