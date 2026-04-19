import 'package:equatable/equatable.dart';

class SavedItem extends Equatable {
  final String id;
  final String userId;
  final String productId;
  final int quantity;
  final String? selectedColor;
  final String? selectedSize;
  final Map<String, dynamic> productSnapshot;
  final DateTime? createdAt;

  const SavedItem({
    required this.id,
    required this.userId,
    required this.productId,
    this.quantity = 1,
    this.selectedColor,
    this.selectedSize,
    this.productSnapshot = const {},
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    productId,
    quantity,
    selectedColor,
    selectedSize,
    productSnapshot,
    createdAt,
  ];
}
