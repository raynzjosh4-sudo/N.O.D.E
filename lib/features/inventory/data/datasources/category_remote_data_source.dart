import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category_model.dart';

abstract class ICategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories({int limit = 100, int offset = 0});
}

class CategoryRemoteDataSourceImpl implements ICategoryRemoteDataSource {
  final SupabaseClient supabaseClient;

  CategoryRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<CategoryModel>> getCategories({
    int limit = 100,
    int offset = 0,
  }) async {
    debugPrint('🌐 [Remote] Fetching categories offset: $offset');
    final response = await supabaseClient
        .from('categories_table')
        .select()
        .range(offset, offset + limit - 1);

    final List<dynamic> data = response as List;
    final categories = data.map((item) {
      return CategoryModel.fromJson(item as Map<String, dynamic>);
    }).toList();

    return categories;
  }
}
