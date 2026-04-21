class RecordBreakdownItemModel {
  final int quantity;
  final String name;
  final double amount;

  RecordBreakdownItemModel({
    required this.quantity,
    required this.name,
    required this.amount,
  });

  factory RecordBreakdownItemModel.fromJson(Map<String, dynamic> json) {
    return RecordBreakdownItemModel(
      quantity: json['quantity'] as int,
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'quantity': quantity, 'name': name, 'amount': amount};
  }
}

class RecordDataModel {
  final List<RecordBreakdownItemModel> items;
  final double grandTotal;

  RecordDataModel({required this.items, required this.grandTotal});

  double get itemsTotal => items.fold(0, (sum, item) => sum + item.amount);

  RecordDataModel copyWith({
    List<RecordBreakdownItemModel>? items,
    double? grandTotal,
  }) {
    return RecordDataModel(
      items: items ?? this.items,
      grandTotal: grandTotal ?? this.grandTotal,
    );
  }

  factory RecordDataModel.fromJson(Map<String, dynamic> json) {
    return RecordDataModel(
      items:
          (json['items'] as List<dynamic>?)
              ?.map(
                (e) => RecordBreakdownItemModel.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          const [],
      grandTotal: (json['grand_total'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((e) => e.toJson()).toList(),
      'grand_total': grandTotal,
    };
  }
}
