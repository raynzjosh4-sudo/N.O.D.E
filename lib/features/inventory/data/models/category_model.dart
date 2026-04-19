import '../../domain/entities/category.dart';
import '../../../../core/database/app_database.dart';

class CategoryModel extends ProductCategory {
  const CategoryModel({
    required super.id,
    required super.name,
    super.parentId,
    required super.imageUrl,
    super.itemCount = 0,
    super.level = 0,
    super.priority = 0,
    super.usageCount = 0,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      parentId: json['parent_id'] as String?,
      imageUrl: json['image_url'] as String? ?? '',
      itemCount: json['item_count'] as int? ?? 0,
      level: json['level'] as int? ?? 0,
      priority: json['priority'] as int? ?? 0,
      usageCount: json['usage_count'] as int? ?? 0,
    );
  }

  factory CategoryModel.fromEntity(ProductCategory entity) {
    return CategoryModel(
      id: entity.id,
      name: entity.name,
      parentId: entity.parentId,
      imageUrl: entity.imageUrl,
      itemCount: entity.itemCount,
      level: entity.level,
      priority: entity.priority,
      usageCount: entity.usageCount,
    );
  }

  factory CategoryModel.fromDrift(CategoryEntry entry) {
    return CategoryModel(
      id: entry.id,
      name: entry.name,
      parentId: entry.parentId,
      imageUrl: entry.imageUrl ?? '',
      itemCount: entry.itemCount,
      level: entry.level,
      priority: entry.priority,
      usageCount: entry.usageCount,
    );
  }

  CategoryEntry toDrift({bool isDirty = false, DateTime? lastSyncedAt}) {
    return CategoryEntry(
      id: id,
      name: name,
      parentId: parentId,
      imageUrl: imageUrl,
      itemCount: itemCount,
      level: level,
      priority: priority,
      usageCount: usageCount,
      isDirty: isDirty,
      lastSyncedAt: lastSyncedAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'parent_id': parentId,
      'image_url': imageUrl,
      'item_count': itemCount,
      'level': level,
      'priority': priority,
      'usage_count': usageCount,
    };
  }
}
