import 'package:dartz/dartz.dart';
import 'package:node_app/features/saved_items/domain/entities/saved_item.dart';
import 'package:node_app/features/saved_items/domain/repositories/i_saved_item_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failure.dart';
import '../models/saved_item_model.dart';

class SavedItemRepositoryImpl implements ISavedItemRepository {
  final SupabaseClient _client;

  SavedItemRepositoryImpl(this._client);

  @override
  Future<Either<Failure, List<SavedItem>>> getSavedItems(String userId) async {
    try {
      final response = await _client
          .from('saved_items')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final List<dynamic> data = response as List;
      final items = data.map((json) => SavedItemModel.fromJson(json)).toList();
      return Right<Failure, List<SavedItem>>(items);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveItem(SavedItem item) async {
    try {
      final model = SavedItemModel.fromEntity(item);

      // We use upsert to handle the unique constraint:
      // user_id, product_id, selected_color, selected_size
      await _client
          .from('saved_items')
          .upsert(
            model.toJson(),
            onConflict: 'user_id, product_id, selected_color, selected_size',
          );

      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeSavedItem(String id) async {
    try {
      await _client.from('saved_items').delete().eq('id', id);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
