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

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        addressName: json['addressName'] as String,
      );

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'addressName': addressName,
      };

  @override
  List<Object?> get props => [latitude, longitude, addressName];
}
