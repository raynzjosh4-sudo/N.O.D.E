import 'package:equatable/equatable.dart';
import 'package:node_app/core/domain/entities/location.dart';

class Supplier extends Equatable {
  final String id;
  final String name;
  final String imageUrl;
  final String category;
  final Location location;

  const Supplier({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.category,
    required this.location,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> businessData = json;
    
    if (json['business'] is Map<String, dynamic>) {
      businessData = json['business'] as Map<String, dynamic>;
    } else if (json['business'] is List && (json['business'] as List).isNotEmpty) {
      final bList = json['business'] as List;
      if (bList.first is Map<String, dynamic>) {
        businessData = bList.first as Map<String, dynamic>;
      }
    }

    return Supplier(
      id: json['id'] as String? ?? json['user_id'] as String? ?? '',
      name: json['name'] as String? ??
          businessData['legal_name'] as String? ??
          json['full_name'] as String? ??
          'N.O.D.E Supplier',
      imageUrl: json['imageUrl'] as String? ??
          businessData['logo_url'] as String? ??
          json['profile_pic_url'] as String? ??
          '',
      category: json['category'] as String? ??
          businessData['industry_group'] as String? ??
          'General',
      location: json['location'] != null
          ? Location.fromJson(json['location'] as Map<String, dynamic>)
          : Location.create(
              latitude: (businessData['latitude'] as num?)?.toDouble() ??
                  (json['latitude'] as num?)?.toDouble() ??
                  0.0,
              longitude: (businessData['longitude'] as num?)?.toDouble() ??
                  (json['longitude'] as num?)?.toDouble() ??
                  0.0,
              addressName: businessData['physical_address'] as String? ??
                  json['physical_address'] as String? ??
                  'Headquarters',
            ),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'imageUrl': imageUrl,
        'category': category,
        'location': location.toJson(),
      };

  @override
  List<Object?> get props => [id, name, imageUrl, category, location];
}
