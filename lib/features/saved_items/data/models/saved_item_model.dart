import 'package:node_app/features/saved_items/domain/entities/saved_item.dart';

class SavedItemModel extends SavedItem {
  const SavedItemModel({
    required super.id,
    required super.userId,
    required super.productId,
    super.quantity,
    super.selectedColor,
    super.selectedSize,
    super.productSnapshot,
    super.createdAt,
  });

  factory SavedItemModel.fromJson(Map<String, dynamic> json) {
    return SavedItemModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      productId: json['product_id'] as String,
      quantity: json['quantity'] as int? ?? 1,
      selectedColor: json['selected_color'] as String?,
      selectedSize: json['selected_size'] as String?,
      productSnapshot: json['product_snapshot'] as Map<String, dynamic>? ?? {},
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'product_id': productId,
      'quantity': quantity,
      'selected_color': selectedColor,
      'selected_size': selectedSize,
      'product_snapshot': productSnapshot,
    };
  }

  factory SavedItemModel.fromEntity(SavedItem entity) {
    return SavedItemModel(
      id: entity.id,
      userId: entity.userId,
      productId: entity.productId,
      quantity: entity.quantity,
      selectedColor: entity.selectedColor,
      selectedSize: entity.selectedSize,
      productSnapshot: entity.productSnapshot,
      createdAt: entity.createdAt,
    );
  }
}
