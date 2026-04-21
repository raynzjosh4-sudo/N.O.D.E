import 'record_model.dart';
import 'record_data_model.dart';
import 'reminder_model.dart';
import 'record_detail_model.dart';

class MainRecordModel {
  final String id;
  final RecordDetailModel? detail;
  final List<RecordModel> records;
  final RecordDataModel? data;
  final ReminderModel? reminder;
  final DateTime updatedAt;
  final bool isArchived;

  MainRecordModel({
    required this.id,
    this.detail,
    required this.records,
    this.data,
    this.reminder,
    required this.updatedAt,
    this.isArchived = false,
  });

  // ── BUSINESS LOGIC HELPERS ──────────────────
  double get progress {
    if (detail == null || detail!.targetValue == 0) return 0;
    return detail!.currentValue / detail!.targetValue;
  }

  bool get isCompleted {
    if (detail == null) return false;
    return detail!.targetValue > 0 &&
        detail!.currentValue >= detail!.targetValue;
  }

  bool get isOverdue {
    if (reminder == null || reminder!.date == null) return false;
    return reminder!.date!.isBefore(DateTime.now()) && !isCompleted;
  }

  MainRecordModel copyWith({
    String? id,
    RecordDetailModel? detail,
    List<RecordModel>? records,
    RecordDataModel? data,
    ReminderModel? reminder,
    DateTime? updatedAt,
    bool? isArchived,
  }) {
    return MainRecordModel(
      id: id ?? this.id,
      detail: detail ?? this.detail,
      records: records ?? this.records,
      data: data ?? this.data,
      reminder: reminder ?? this.reminder,
      updatedAt: updatedAt ?? this.updatedAt,
      isArchived: isArchived ?? this.isArchived,
    );
  }

  factory MainRecordModel.fromJson(Map<String, dynamic> json) {
    return MainRecordModel(
      id: json['id'] as String,
      detail: json['detail'] != null
          ? RecordDetailModel.fromJson(json['detail'] as Map<String, dynamic>)
          : null,
      records:
          (json['records'] as List<dynamic>?)
              ?.map((e) => RecordModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      data: json['data'] != null
          ? RecordDataModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      reminder: json['reminder'] != null
          ? ReminderModel.fromJson(json['reminder'] as Map<String, dynamic>)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
      isArchived: json['is_archived'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'detail': detail?.toJson(),
      'records': records.map((e) => e.toJson()).toList(),
      'data': data?.toJson(),
      'reminder': reminder?.toJson(),
      'updated_at': updatedAt.toIso8601String(),
      'is_archived': isArchived,
    };
  }
}
