import 'package:equatable/equatable.dart';

class BusinessProfile extends Equatable {
  final String legalName;
  final String physicalAddress;
  final String city;
  final String phoneNumber;
  final String? tin;
  final String? registrationNo;
  final double? latitude;
  final double? longitude;

  const BusinessProfile({
    required this.legalName,
    required this.physicalAddress,
    required this.city,
    required this.phoneNumber,
    this.tin,
    this.registrationNo,
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [
    legalName,
    physicalAddress,
    city,
    phoneNumber,
    tin,
    registrationNo,
    latitude,
    longitude,
  ];
}
