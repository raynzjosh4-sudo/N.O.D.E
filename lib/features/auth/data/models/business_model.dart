import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/entities/business_profile.dart';

class BusinessModel extends BusinessProfile {
  const BusinessModel({
    required super.id,
    required super.legalName,
    super.phoneNumber,
    super.latitude,
    super.longitude,
    super.region,
    super.city,
    super.physicalAddress,
    super.updatedAt,
  });

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    return BusinessModel(
      id: json['user_id'] as String? ?? json['id'] as String,
      legalName: json['legal_name'] as String,
      latitude: json['latitude'] != null
          ? (json['latitude'] as num).toDouble()
          : null,
      longitude: json['longitude'] != null
          ? (json['longitude'] as num).toDouble()
          : null,
      region: json['region'] as String?,
      city: json['city'] as String?,
      physicalAddress: json['physical_address'] as String?,
      phoneNumber: json['phone_number'] as String?,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'legal_name': legalName,
      'latitude': latitude,
      'longitude': longitude,
      'region': region,
      'city': city,
      'physical_address': physicalAddress,
      'phone_number': phoneNumber,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory BusinessModel.fromEntity(BusinessProfile entity) {
    return BusinessModel(
      id: entity.id,
      legalName: entity.legalName,
      latitude: entity.latitude,
      longitude: entity.longitude,
      region: entity.region,
      city: entity.city,
      physicalAddress: entity.physicalAddress,
      phoneNumber: entity.phoneNumber,
      updatedAt: entity.updatedAt,
    );
  }

  factory BusinessModel.fromDrift(BusinessEntry entry) {
    return BusinessModel(
      id: entry.id,
      legalName: entry.legalName,
      latitude: entry.latitude,
      longitude: entry.longitude,
      region: entry.region,
      city: entry.city,
      physicalAddress: entry.physicalAddress,
      phoneNumber: entry.phoneNumber,
    );
  }

  BusinessTableCompanion toDrift() {
    return BusinessTableCompanion(
      id: Value(id),
      legalName: Value(legalName),
      latitude: Value(latitude),
      longitude: Value(longitude),
      region: Value(region),
      city: Value(city),
      physicalAddress: Value(physicalAddress),
      phoneNumber: Value(phoneNumber),
    );
  }
}
