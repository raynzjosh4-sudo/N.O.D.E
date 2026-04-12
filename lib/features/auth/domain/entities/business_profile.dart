import 'package:equatable/equatable.dart';

enum BusinessTier { retailer, wholesaler, distributor }
enum VerificationStatus { pending, verified, rejected }

class BusinessProfile extends Equatable {
  final String id;
  final String legalName;
  final String tin;
  final String registrationNo;
  final BusinessTier tier;
  final VerificationStatus status;

  // Logistics
  final double latitude;
  final double longitude;
  final String region; // e.g., "Mbarara City"
  final String physicalAddress;

  // Financials
  final double creditLimit;
  final double currentBalance;
  final String primaryMoMoNumber;

  // SEO
  final String slug;
  final String description;
  final String logoUrl;

  BusinessProfile({
    required this.id,
    required this.legalName,
    required this.tin,
    required this.registrationNo,
    required this.tier,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.region,
    required this.physicalAddress,
    required this.creditLimit,
    required this.currentBalance,
    required this.primaryMoMoNumber,
    required this.slug,
    required this.description,
    required this.logoUrl,
  });

  @override
  List<Object?> get props => [
        id, legalName, tin, registrationNo, tier, status,
        latitude, longitude, region, physicalAddress,
        creditLimit, currentBalance, primaryMoMoNumber,
        slug, description, logoUrl,
      ];
}
