import '../../domain/types/record_types.dart';

class RecordDetailModel {
  final String contactName;
  final String itemName;
  final String? referenceTag;
  final String unit;
  final double targetValue;
  final double currentValue;
  final RecordType type;
  final String? contactImageUrl;

  RecordDetailModel({
    required this.contactName,
    required this.itemName,
    this.referenceTag,
    this.unit = 'Units',
    this.targetValue = 0,
    this.currentValue = 0,
    required this.type,
    this.contactImageUrl,
  });

  RecordDetailModel copyWith({
    String? contactName,
    String? itemName,
    String? referenceTag,
    String? unit,
    double? targetValue,
    double? currentValue,
    RecordType? type,
    String? contactImageUrl,
  }) {
    return RecordDetailModel(
      contactName: contactName ?? this.contactName,
      itemName: itemName ?? this.itemName,
      referenceTag: referenceTag ?? this.referenceTag,
      unit: unit ?? this.unit,
      targetValue: targetValue ?? this.targetValue,
      currentValue: currentValue ?? this.currentValue,
      type: type ?? this.type,
      contactImageUrl: contactImageUrl ?? this.contactImageUrl,
    );
  }

  factory RecordDetailModel.fromJson(Map<String, dynamic> json) {
    return RecordDetailModel(
      contactName: json['contact_name'] as String,
      itemName: json['item_name'] as String,
      referenceTag: json['reference_tag'] as String?,
      unit: json['unit'] as String? ?? 'Units',
      targetValue: (json['target_value'] as num?)?.toDouble() ?? 0,
      currentValue: (json['current_value'] as num?)?.toDouble() ?? 0,
      type: RecordType.values.byName(json['type'] as String? ?? 'standard'),
      contactImageUrl: json['contact_image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contact_name': contactName,
      'item_name': itemName,
      'reference_tag': referenceTag,
      'unit': unit,
      'target_value': targetValue,
      'current_value': currentValue,
      'type': type.name,
      'contact_image_url': contactImageUrl,
    };
  }
}
