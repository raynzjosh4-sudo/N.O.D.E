import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/entities/business_profile.dart';

class BusinessModel extends BusinessProfile {
  BusinessModel({
    required super.id,
    required super.legalName,
    required super.tin,
    required super.registrationNo,
    required super.tier,
    required super.status,
    required super.latitude,
    required super.longitude,
    required super.region,
    required super.physicalAddress,
    required super.creditLimit,
    required super.currentBalance,
    required super.primaryMoMoNumber,
    required super.slug,
    required super.description,
    required super.logoUrl,
  });

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    return BusinessModel(
      id: json['id'] as String,
      legalName: json['legal_name'] as String,
      tin: json['tin'] as String,
      registrationNo: json['registration_no'] as String,
      tier: BusinessTier.values.firstWhere(
        (e) => e.name == json['tier'],
        orElse: () => BusinessTier.retailer,
      ),
      status: VerificationStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => VerificationStatus.pending,
      ),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      region: json['region'] as String,
      physicalAddress: json['physical_address'] as String,
      creditLimit: (json['credit_limit'] as num).toDouble(),
      currentBalance: (json['current_balance'] as num).toDouble(),
      primaryMoMoNumber: json['primary_momo_number'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String,
      logoUrl: json['logo_url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'legal_name': legalName,
      'tin': tin,
      'registration_no': registrationNo,
      'tier': tier.name,
      'status': status.name,
      'latitude': latitude,
      'longitude': longitude,
      'region': region,
      'physical_address': physicalAddress,
      'credit_limit': creditLimit,
      'current_balance': currentBalance,
      'primary_momo_number': primaryMoMoNumber,
      'slug': slug,
      'description': description,
      'logo_url': logoUrl,
    };
  }

  factory BusinessModel.fromEntity(BusinessProfile entity) {
    return BusinessModel(
      id: entity.id,
      legalName: entity.legalName,
      tin: entity.tin,
      registrationNo: entity.registrationNo,
      tier: entity.tier,
      status: entity.status,
      latitude: entity.latitude,
      longitude: entity.longitude,
      region: entity.region,
      physicalAddress: entity.physicalAddress,
      creditLimit: entity.creditLimit,
      currentBalance: entity.currentBalance,
      primaryMoMoNumber: entity.primaryMoMoNumber,
      slug: entity.slug,
      description: entity.description,
      logoUrl: entity.logoUrl,
    );
  }

  factory BusinessModel.fromDrift(BusinessEntry entry) {
    return BusinessModel(
      id: entry.id,
      legalName: entry.legalName,
      tin: entry.tin,
      registrationNo: entry.registrationNo,
      tier: BusinessTier.values.firstWhere(
        (e) => e.name == entry.tier,
        orElse: () => BusinessTier.retailer,
      ),
      status: VerificationStatus.values.firstWhere(
        (e) => e.name == entry.status,
        orElse: () => VerificationStatus.pending,
      ),
      latitude: entry.latitude,
      longitude: entry.longitude,
      region: entry.region,
      physicalAddress: entry.physicalAddress,
      creditLimit: entry.creditLimit,
      currentBalance: entry.currentBalance,
      primaryMoMoNumber: entry.primaryMoMoNumber,
      slug: entry.slug,
      description: entry.description,
      logoUrl: entry.logoUrl ?? '',
    );
  }

  BusinessTableCompanion toDrift() {
    return BusinessTableCompanion(
      id: Value(id),
      legalName: Value(legalName),
      tin: Value(tin),
      registrationNo: Value(registrationNo),
      tier: Value(tier.name),
      status: Value(status.name),
      latitude: Value(latitude),
      longitude: Value(longitude),
      region: Value(region),
      physicalAddress: Value(physicalAddress),
      creditLimit: Value(creditLimit),
      currentBalance: Value(currentBalance),
      primaryMoMoNumber: Value(primaryMoMoNumber),
      slug: Value(slug),
      description: Value(description),
      logoUrl: Value(logoUrl),
    );
  }
}
