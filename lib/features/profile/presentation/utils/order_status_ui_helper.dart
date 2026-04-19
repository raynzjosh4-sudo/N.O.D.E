import 'package:flutter/material.dart';
import '../../domain/entities/order_status.dart';

extension OrderStatusUIHelper on OrderStatus {
  Color get color {
    switch (this) {
      case OrderStatus.pending:
        return const Color(0xFF607D8B); // Blue-Grey
      case OrderStatus.submitted:
        return Colors.indigo;
      case OrderStatus.processing:
        return Colors.orange;
      case OrderStatus.shipped:
        return const Color(0xFF2196F3); // Blue
      case OrderStatus.delivered:
        return Colors.teal;
      case OrderStatus.completed:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;

    }
  }

  String get label => name.toUpperCase();

  IconData get icon {
    switch (this) {
      case OrderStatus.pending:
        return Icons.pending_actions_rounded;
      case OrderStatus.submitted:
        return Icons.check_circle_outline_rounded;
      case OrderStatus.processing:
        return Icons.precision_manufacturing_rounded;
      case OrderStatus.shipped:
        return Icons.local_shipping_rounded;
      case OrderStatus.delivered:
        return Icons.inventory_2_rounded;
      case OrderStatus.completed:
        return Icons.task_alt_rounded;
      case OrderStatus.cancelled:
        return Icons.cancel_outlined;
    }
  }

  String get message {
    switch (this) {
      case OrderStatus.pending:
        return 'AWAITING SUBMISSION';
      case OrderStatus.submitted:
        return 'OFFICIALLY SUBMITTED';
      case OrderStatus.processing:
        return 'CURRENTLY PROCESSING';
      case OrderStatus.shipped:
        return 'IN TRANSIT';
      case OrderStatus.delivered:
        return 'DELIVERED TO WAREHOUSE';
      case OrderStatus.completed:
        return 'ORDER COMPLETED';
      case OrderStatus.cancelled:
        return 'ORDER CANCELLED';
    }
  }
}
