import 'package:equatable/equatable.dart';

class ProductColor extends Equatable {
  final String name;
  final String hexCode;

  const ProductColor({
    required this.name,
    required this.hexCode,
  });

  factory ProductColor.fromJson(Map<String, dynamic> json) => ProductColor(
        name: json['name'] as String,
        hexCode: json['hexCode'] as String,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'hexCode': hexCode,
      };

  @override
  List<Object?> get props => [name, hexCode];
}

class ProductSize extends Equatable {
  final String name;
  final String abbreviation;

  const ProductSize({
    required this.name,
    required this.abbreviation,
  });

  factory ProductSize.fromJson(Map<String, dynamic> json) => ProductSize(
        name: json['name'] as String,
        abbreviation: json['abbreviation'] as String,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'abbreviation': abbreviation,
      };

  @override
  List<Object?> get props => [name, abbreviation];
}

class ProductMaterial extends Equatable {
  final String name;
  final String? imageUrl;

  const ProductMaterial({
    required this.name,
    this.imageUrl,
  });

  factory ProductMaterial.fromJson(Map<String, dynamic> json) => ProductMaterial(
        name: json['name'] as String,
        imageUrl: json['imageUrl'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'imageUrl': imageUrl,
      };

  @override
  List<Object?> get props => [name, imageUrl];
}

class ProductSupport extends Equatable {
  final String whatsapp;
  final String phone;
  final String email;

  const ProductSupport({
    required this.whatsapp,
    required this.phone,
    required this.email,
  });

  factory ProductSupport.fromJson(Map<String, dynamic> json) => ProductSupport(
        whatsapp: json['whatsapp'] as String,
        phone: json['phone'] as String,
        email: json['email'] as String,
      );

  Map<String, dynamic> toJson() => {
        'whatsapp': whatsapp,
        'phone': phone,
        'email': email,
      };

  @override
  List<Object?> get props => [whatsapp, phone, email];
}
