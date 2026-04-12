import 'package:equatable/equatable.dart';
import 'wholesale_order.dart';

class DraftOrder extends Equatable {
  final String id;
  final List<ProductOrderEntry> entries;
  final DateTime lastModified;
  final String status;

  const DraftOrder({
    required this.id,
    required this.entries,
    required this.lastModified,
    this.status = 'DRAFT',
  });

  int get totalItems => entries.length;
  int get totalUnits => entries.fold(0, (sum, e) => sum + e.totalUnits);
  double get totalAmount => entries.fold(0, (sum, e) => sum + e.totalAmount);

  @override
  List<Object?> get props => [id, entries, lastModified, status];
}
