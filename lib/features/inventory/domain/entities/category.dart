import 'package:equatable/equatable.dart';

class ProductCategory extends Equatable {
  final String id;
  final String name;
  final String? parentId;
  final String imageUrl;
  final int itemCount;
  final int level;
  final int priority;
  final int usageCount;

  const ProductCategory({
    required this.id,
    required this.name,
    this.parentId,
    required this.imageUrl,
    this.itemCount = 0,
    this.level = 0,
    this.priority = 0,
    this.usageCount = 0,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    parentId,
    imageUrl,
    itemCount,
    level,
    priority,
    usageCount,
  ];
}
