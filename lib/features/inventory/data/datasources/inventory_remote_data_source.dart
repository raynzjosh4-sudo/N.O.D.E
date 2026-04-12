import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product_model.dart';

abstract class IInventoryRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProductById(String id);
  Future<ProductModel> addProduct(ProductModel product);
  Future<ProductModel> updateProduct(ProductModel product);
  Future<void> deleteProduct(String id);
  Future<void> updateStock(String id, int quantity);
}

class InventoryRemoteDataSourceImpl implements IInventoryRemoteDataSource {
  final SupabaseClient supabaseClient;

  InventoryRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<ProductModel>> getProducts() async {
    final response = await supabaseClient
        .from('products')
        .select()
        .order('id', ascending: false);
    
    return (response as List).map((json) => ProductModel.fromJson(json)).toList();
  }

  @override
  Future<ProductModel> addProduct(ProductModel product) async {
    final response = await supabaseClient
        .from('products')
        .insert(product.toJson())
        .select()
        .single();
    
    return ProductModel.fromJson(response);
  }

  @override
  Future<ProductModel> updateProduct(ProductModel product) async {
    final response = await supabaseClient
        .from('products')
        .update(product.toJson())
        .eq('id', product.id)
        .select()
        .single();
    
    return ProductModel.fromJson(response);
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    final response = await supabaseClient
        .from('products')
        .select()
        .eq('id', id)
        .single();
    
    return ProductModel.fromJson(response);
  }

  @override
  Future<void> updateStock(String id, int quantity) async {
    // 👑 REAL-TIME STOCK: In production, this should be an atomic RPC 
    // to prevent race conditions during bulk wholesaler orders.
    await supabaseClient
        .from('products')
        .update({'current_stock': quantity})
        .eq('id', id);
  }

  @override
  Future<void> deleteProduct(String id) async {
    await supabaseClient.from('products').delete().eq('id', id);
  }
}
