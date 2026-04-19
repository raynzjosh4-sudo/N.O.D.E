import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:node_app/core/database/app_database.dart';
import '../../domain/entities/promo_campaign.dart';

class PromotionModel extends PromoCampaign {
  PromotionModel({
    required super.id,
    required super.title,
    super.subtitle = '',
    super.actionText = '',
    required super.imageUrls,
    super.isLocal = false,
    super.priority = 0,
    super.isActive = true,
    super.startsAt,
    super.expiresAt,
  });

  factory PromotionModel.fromDrift(PromotionEntry entry) {
    return PromotionModel(
      id: entry.id,
      title: entry.title,
      subtitle: entry.subtitle ?? '',
      actionText: entry.actionText ?? '',
      imageUrls: (jsonDecode(entry.imageUrlsJson) as List).cast<String>(),
      isLocal: false,
      priority: entry.priority,
      isActive: entry.isActive,
      startsAt: entry.startsAt,
      expiresAt: entry.expiresAt,
    );
  }

  factory PromotionModel.fromJson(Map<String, dynamic> json) {
    return PromotionModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      actionText: json['action_text'] as String? ?? '',
      imageUrls: (json['image_urls'] as List?)?.cast<String>() ?? [],
      isLocal: false,
      priority: json['priority'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      startsAt: json['starts_at'] != null ? DateTime.parse(json['starts_at']) : null,
      expiresAt: json['expires_at'] != null ? DateTime.parse(json['expires_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'action_text': actionText,
      'image_urls': imageUrls,
      'priority': priority,
      'is_active': isActive,
      'starts_at': startsAt?.toIso8601String(),
      'expires_at': expiresAt?.toIso8601String(),
    };
  }

  PromotionsTableCompanion toDrift() {
    return PromotionsTableCompanion(
      id: Value(id),
      title: Value(title),
      subtitle: subtitle.isNotEmpty ? Value(subtitle) : const Value.absent(),
      actionText: actionText.isNotEmpty ? Value(actionText) : const Value.absent(),
      imageUrlsJson: Value(jsonEncode(imageUrls)),
      priority: Value(priority),
      isActive: Value(isActive),
      startsAt: startsAt != null ? Value(startsAt!) : const Value.absent(),
      expiresAt: expiresAt != null ? Value(expiresAt!) : const Value.absent(),
    );
  }
}
