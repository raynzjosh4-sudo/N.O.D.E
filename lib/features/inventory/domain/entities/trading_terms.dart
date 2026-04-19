import 'package:equatable/equatable.dart';

class TradingTerms extends Equatable {
  final String id;
  final String content;
  final String? moq;
  final String? warranty;
  final String? paymentTerms;
  final String? deliveryTerms;

  const TradingTerms({
    required this.id,
    required this.content,
    this.moq,
    this.warranty,
    this.paymentTerms,
    this.deliveryTerms,
  });

  factory TradingTerms.fromJson(Map<String, dynamic> json) {
    // DB Schema Alignment
    final moq = json['moq'] as String? ?? '';
    final warranty = json['warranty'] as String? ?? '';
    final payment = json['paymentTerms'] as String? ?? '';
    final delivery = json['deliveryTerms'] as String? ?? '';

    return TradingTerms(
      id: json['id'] as String? ?? 'tt_${DateTime.now().millisecondsSinceEpoch}',
      moq: moq,
      warranty: warranty,
      paymentTerms: payment,
      deliveryTerms: delivery,
      content: json['content'] as String? ?? 
          'MOQ: $moq. Payment: $payment. Delivery: $delivery.',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'moq': moq,
        'warranty': warranty,
        'paymentTerms': paymentTerms,
        'deliveryTerms': deliveryTerms,
      };

  @override
  List<Object?> get props => [id, content, moq, warranty, paymentTerms, deliveryTerms];
}
