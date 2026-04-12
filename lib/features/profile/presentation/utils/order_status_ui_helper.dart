import 'package:flutter/material.dart';
import '../../domain/entities/order_status.dart';

extension OrderStatusUIHelper on OrderStatus {
  Color get color {
    switch (this) {
      case OrderStatus.pending:
        return const Color(0xFF607D8B); // Blue-Grey
      case OrderStatus.processing:
        return Colors.orange;
      case OrderStatus.shipped:
        return const Color(0xFF2196F3); // Blue
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  String get label => name.toUpperCase();
}
