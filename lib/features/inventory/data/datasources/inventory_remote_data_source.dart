import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product_model.dart';
import '../../../../features/home/data/models/promotion_model.dart';

abstract class IInventoryRemoteDataSource {
  Future<List<ProductModel>> getProducts({
    int limit = 20,
    int offset = 0,
    String? categoryId,
    String? supplierId,
    String? searchQuery,
  });
  Future<ProductModel> getProductById(String id);
  Future<ProductModel> addProduct(ProductModel product);
  Future<ProductModel> updateProduct(ProductModel product);
  Future<void> deleteProduct(String id);
  Future<void> updateStock(String id, int quantity);
  Future<List<PromotionModel>> getPromotions();
}

class InventoryRemoteDataSourceImpl implements IInventoryRemoteDataSource {
  final SupabaseClient supabaseClient;

  InventoryRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<ProductModel>> getProducts({
    int limit = 20,
    int offset = 0,
    String? categoryId,
    String? supplierId,
    String? searchQuery,
  }) async {
    debugPrint(
      '🌐 [Remote] Fetching products range: $offset to ${offset + limit - 1}...',
    );

    var query = supabaseClient
        .from('products_table')
        .select(
          '*, supplier:users_table(id, full_name, profile_pic_url, business:business_table(legal_name, logo_url, latitude, longitude, physical_address))',
        );


    if (categoryId != null) {
      query = query.eq('category_id', categoryId);
    }
    if (supplierId != null) {
      query = query.eq('supplier_id', supplierId);
    }
    if (searchQuery != null && searchQuery.isNotEmpty) {
      // 👑 COMPOSITE SEARCH: Searches Name, Brand, and Keywords simultaneously
      // For arrays (search_keywords), we check for containment.
      // For strings (name, brand), we use case-insensitive like.
      query = query.or(
        'name.ilike.%$searchQuery%,'
        'brand.ilike.%$searchQuery%,'
        'search_keywords.cs.{"$searchQuery"}',
      );
    }

    final response = await query
        .order('id', ascending: false)
        .range(offset, offset + limit - 1);

    final List<dynamic> data = response as List;
    debugPrint(
      '🌐 [Remote] Received ${data.length} raw results. Mapping to models...',
    );

    final products = data.map((item) {
      try {
        final map = item as Map<String, dynamic>;
        // debugPrint('🌐 [Remote] Processing item ID: ${map['id']}');
        return ProductModel.fromJson(map);
      } catch (e) {
        debugPrint('🚨 [Remote] MAPPING FAILED for item: $item');
        debugPrint('🚨 [Remote] Error reason: $e');
        return null;
      }
    }).whereType<ProductModel>().toList();

    debugPrint('🌐 [Remote] Successfully mapped ${products.length} products.');
    return products;
  }

  @override
  Future<ProductModel> addProduct(ProductModel product) async {
    final response = await supabaseClient
        .from('products_table')
        .insert(product.toJson())
        .select()
        .single();

    return ProductModel.fromJson(response);
  }

  @override
  Future<ProductModel> updateProduct(ProductModel product) async {
    final response = await supabaseClient
        .from('products_table')
        .update(product.toJson())
        .eq('id', product.id)
        .select()
        .single();

    return ProductModel.fromJson(response);
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    final response = await supabaseClient
        .from('products_table')
        .select(
          '*, supplier:users_table!supplier_id(id, full_name, profile_pic_url, business:business_table(legal_name, logo_url, latitude, longitude, physical_address))',
        )
        .eq('id', id)
        .single();

    return ProductModel.fromJson(response);
  }

  @override
  Future<void> updateStock(String id, int quantity) async {
    // 👑 REAL-TIME STOCK: In production, this should be an atomic RPC
    // to prevent race conditions during bulk wholesaler orders.
    await supabaseClient
        .from('products_table')
        .update({'current_stock': quantity})
        .eq('id', id);
  }

  @override
  Future<void> deleteProduct(String id) async {
    await supabaseClient.from('products_table').delete().eq('id', id);
  }

  @override
  Future<List<PromotionModel>> getPromotions() async {
    debugPrint('🌐 [Remote] Fetching active promotions from Supabase...');
    final response = await supabaseClient
        .from('promotions_table')
        .select()
        .eq('is_active', true)
        .order('priority', ascending: false);

    final List<dynamic> data = response as List;
    final promotions = data.map((item) {
      return PromotionModel.fromJson(item as Map<String, dynamic>);
    }).toList();

    debugPrint('🌐 [Remote] Received ${promotions.length} active promotions.');
    return promotions;
  }
}
