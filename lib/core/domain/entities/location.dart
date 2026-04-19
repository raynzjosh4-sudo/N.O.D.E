import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final double latitude;
  final double longitude;
  final String addressName;

  const Location({
    required this.latitude,
    required this.longitude,
    required this.addressName,
  });

  /// 🛠 Attempts to extract coordinates from string if lat/lng are missing (0,0)
  /// Format: "Loc: 0.341, 32.583 (Kampala)"
  factory Location.create({
    required double latitude,
    required double longitude,
    required String addressName,
  }) {
    if (latitude == 0.0 && longitude == 0.0 && addressName.contains('Loc:')) {
      final regExp = RegExp(r"Loc:\s*(-?\d+\.?\d*),\s*(-?\d+\.?\d*)");
      final match = regExp.firstMatch(addressName);
      if (match != null && match.groupCount >= 2) {
        final parsedLat = double.tryParse(match.group(1) ?? '0.0') ?? 0.0;
        final parsedLng = double.tryParse(match.group(2) ?? '0.0') ?? 0.0;
        return Location(
          latitude: parsedLat,
          longitude: parsedLng,
          addressName: addressName,
        );
      }
    }
    return Location(
      latitude: latitude,
      longitude: longitude,
      addressName: addressName,
    );
  }

  factory Location.fromJson(Map<String, dynamic> json) => Location.create(
        latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
        longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
        addressName: json['addressName'] as String? ??
            json['physical_address'] as String? ??
            'Headquarters',
      );

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'addressName': addressName,
      };

  @override
  List<Object?> get props => [latitude, longitude, addressName];
}

