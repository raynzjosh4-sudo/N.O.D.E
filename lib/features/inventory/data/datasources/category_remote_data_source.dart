import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category_model.dart';

abstract class ICategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories({
    String? parentId,
    int limit = 100,
    int offset = 0,
  });
}

class CategoryRemoteDataSourceImpl implements ICategoryRemoteDataSource {
  final SupabaseClient supabaseClient;

  CategoryRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<CategoryModel>> getCategories({
    String? parentId,
    int limit = 100,
    int offset = 0,
  }) async {
    debugPrint(
      '🌐 [Remote] Fetching categories parentId: $parentId offset: $offset',
    );
    var query = supabaseClient.from('categories_table').select();

    if (parentId != null) {
      query = query.eq('parent_id', parentId);
    } else {
      query = query.filter('parent_id', 'is', null);
    }

    final response = await query.range(offset, offset + limit - 1);

    final List<dynamic> data = response as List;
    final categories = data.map((item) {
      return CategoryModel.fromJson(item as Map<String, dynamic>);
    }).toList();

    return categories;
  }
}
