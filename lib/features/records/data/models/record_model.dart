class RecordModel {
  final DateTime time;
  final double total;
  final String message;
  final double balanceAfter;
  final String? reference;

  RecordModel({
    required this.time,
    required this.total,
    required this.message,
    required this.balanceAfter,
    this.reference,
  });

  RecordModel copyWith({
    DateTime? time,
    double? total,
    String? message,
    double? balanceAfter,
    String? reference,
  }) {
    return RecordModel(
      time: time ?? this.time,
      total: total ?? this.total,
      message: message ?? this.message,
      balanceAfter: balanceAfter ?? this.balanceAfter,
      reference: reference ?? this.reference,
    );
  }

  factory RecordModel.fromJson(Map<String, dynamic> json) {
    return RecordModel(
      time: DateTime.parse(json['time'] as String),
      total: (json['total'] as num).toDouble(),
      message: json['message'] as String,
      balanceAfter: (json['balance_after'] as num).toDouble(),
      reference: json['reference'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time.toIso8601String(),
      'total': total,
      'message': message,
      'balance_after': balanceAfter,
      'reference': reference,
    };
  }
}
