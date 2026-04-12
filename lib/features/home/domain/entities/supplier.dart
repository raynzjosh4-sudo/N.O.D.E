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

  factory Supplier.fromJson(Map<String, dynamic> json) => Supplier(
        id: json['id'] as String,
        name: json['name'] as String,
        imageUrl: json['imageUrl'] as String,
        category: json['category'] as String,
        location: Location.fromJson(json['location'] as Map<String, dynamic>),
      );

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
