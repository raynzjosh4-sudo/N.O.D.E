import 'package:equatable/equatable.dart';

class PriceTier extends Equatable {
  final int minQuantity;
  final double price;
  final String? label;

  const PriceTier({required this.minQuantity, required this.price, this.label});

  factory PriceTier.fromJson(Map<String, dynamic> json) => PriceTier(
    minQuantity: json['minQuantity'] as int,
    price: (json['price'] as num).toDouble(),
    label: json['label'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'minQuantity': minQuantity,
    'price': price,
    'label': label,
  };

  @override
  List<Object?> get props => [minQuantity, price, label];
}
