import 'package:equatable/equatable.dart';

class ProductCategory extends Equatable {
  final String id;
  final String name;
  final String? parentId; // 🌟 NULL if top-level Category
  final String imageUrl;

  const ProductCategory({
    required this.id,
    required this.name,
    this.parentId,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [id, name, parentId, imageUrl];
}
