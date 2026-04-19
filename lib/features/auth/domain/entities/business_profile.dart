import 'package:equatable/equatable.dart';

class BusinessProfile extends Equatable {
  final String id;
  final String legalName;
  
  // Logistics - Matches SQL
  final String? phoneNumber;
  final double? latitude;
  final double? longitude;
  final String? region;
  final String? city;
  final String? physicalAddress;
  final DateTime? updatedAt;

  const BusinessProfile({
    required this.id,
    required this.legalName,
    this.phoneNumber,
    this.latitude,
    this.longitude,
    this.region,
    this.city,
    this.physicalAddress,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        legalName,
        phoneNumber,
        latitude,
        longitude,
        region,
        city,
        physicalAddress,
        updatedAt,
      ];
}
