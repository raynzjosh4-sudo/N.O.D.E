import 'package:fpdart/fpdart.dart';
import 'package:node_app/features/profile/domain/entities/order_status.dart';
import '../../../../core/error/failure.dart';
import '../../../profile/domain/entities/wholesale_order.dart';
import '../../../profile/domain/entities/draft_order.dart';

abstract class OrderRepository {
  /// Saves a completed wholesale order to the database.
  Future<Either<Failure, void>> saveOrder(WholesaleOrder order, String userId);

  /// Saves an in-progress draft order to the database.
  Future<Either<Failure, void>> saveDraft(DraftOrder draft, String userId);

  /// Retrieves a specific order by ID.
  Future<Either<Failure, WholesaleOrder?>> getOrderById(String id);

  /// Retrieves all completed orders for a specific user.
  Future<Either<Failure, List<WholesaleOrder>>> getOrders(String userId);

  /// Retrieves all drafts for a specific user.
  Future<Either<Failure, List<DraftOrder>>> getDrafts(String userId);

  /// Deletes a specific order or draft by ID.
  Future<Either<Failure, void>> deleteOrder(String id);

  /// Updates the status of a specific order.
  Future<Either<Failure, void>> updateOrderStatus(
    String id,
    OrderStatus status,
  );
}
