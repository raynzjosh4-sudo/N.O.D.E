import 'package:equatable/equatable.dart';

class TradingTerms extends Equatable {
  final String id;
  final String content;

  const TradingTerms({required this.id, required this.content});

  factory TradingTerms.fromJson(Map<String, dynamic> json) => TradingTerms(
    id: json['id'] as String,
    content: json['content'] as String,
  );

  Map<String, dynamic> toJson() => {'id': id, 'content': content};

  @override
  List<Object?> get props => [id, content];
}
