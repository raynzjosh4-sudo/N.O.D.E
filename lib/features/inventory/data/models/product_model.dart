import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:node_app/features/home/domain/entities/supplier.dart';
import 'package:node_app/core/domain/entities/location.dart';

import '../../../../core/database/app_database.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/price_tier.dart';
import '../../domain/entities/product_attributes.dart';
import '../../domain/entities/trading_terms.dart';

class ProductModel extends Product {
  ProductModel({
    required super.id,
    required super.sku,
    required super.name,
    required super.brand,
    required super.priceTiers,
    required super.srp,
    required super.hsCode,
    required super.weightKg,
    required super.volumeCbm,
    required super.originCountry,
    required super.unbsNumber,
    required super.denier,
    required super.material,
    required super.supplier,
    required super.categoryId,
    required super.currentStock,
    required super.leadTimeDays,
    required super.warehouseLoc,
    required super.seoTitle,
    required super.seoDescription,
    required super.searchKeywords,
    required super.slug,
    required super.imageUrl,
    super.mediaUrls,
    super.aspectRatio,
    super.availableColors,
    super.availableSizes,
    super.availableMaterials,
    super.variantLabel,
    required super.support,
    required super.tradingTerms,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String? ?? '',
      sku: json['sku'] as String? ?? '',
      name: json['name'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
      priceTiers: (json['price_tiers'] as List?)
              ?.map((e) => PriceTier.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      srp: (json['srp'] as num?)?.toDouble() ?? 0.0,
      hsCode: json['hs_code'] as String? ?? '',
      weightKg: (json['weight_kg'] as num?)?.toDouble() ?? 0.0,
      volumeCbm: (json['volume_cbm'] as num?)?.toDouble() ?? 0.0,
      originCountry: json['origin_country'] as String? ?? '',
      unbsNumber: json['unbs_number'] as String? ?? '',
      denier: json['denier'] as String? ?? '',
      material: json['material'] as String? ?? '',
      supplier: json['supplier'] != null
          ? Supplier.fromJson(json['supplier'] as Map<String, dynamic>)
          : Supplier(
              id: json['supplier_id'] as String? ?? 'unknown',
              name: 'N.O.D.E Supplier',
              imageUrl: '',
              category: 'Global Wholesale',
              location: const Location(
                latitude: 0,
                longitude: 0,
                addressName: 'Regional Hub',
              ),
            ),
      categoryId: json['category_id'] as String? ?? '',
      currentStock: json['current_stock'] as int? ?? 0,
      leadTimeDays: json['lead_time_days'] as int? ?? 0,
      warehouseLoc: json['warehouse_loc'] as String? ?? '',
      seoTitle: json['seo_title'] as String? ?? '',
      seoDescription: json['seo_description'] as String? ?? '',
      searchKeywords: (json['search_keywords'] as List?)?.cast<String>() ?? [],
      slug: json['slug'] as String? ?? '',
      imageUrl: json['image_url'] as String? ?? '',
      mediaUrls: ((json['media_urls'] as List?)?.cast<String>() ?? [])
          .toSet()
          .toList(),
      aspectRatio: (json['aspect_ratio'] as num?)?.toDouble() ?? 1.0,
      availableColors:
          (json['available_colors'] as List?)
              ?.map((e) => ProductColor.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      availableSizes:
          (json['available_sizes'] as List?)
              ?.map((e) => ProductSize.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      availableMaterials:
          (json['available_materials'] as List?)
              ?.map((e) => ProductMaterial.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      variantLabel: json['variant_label'] as String? ?? 'Size',
      support: ProductSupport.fromJson(
        json['support_info'] as Map<String, dynamic>? ??
            json['support'] as Map<String, dynamic>? ??
            {
              'whatsapp': '+256 000 000 000',
              'phone': '+256 000 000 000',
              'email': 'support@node.app'
            },
      ),
      tradingTerms: TradingTerms.fromJson(
        json['trading_terms'] as Map<String, dynamic>? ??
            {
              'id': 'tt_default',
              'content':
                  'Standard trading terms apply for all wholesale transactions.'
            },
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sku': sku,
      'name': name,
      'brand': brand,
      'price_tiers': priceTiers.map((e) => e.toJson()).toList(),
      'srp': srp,
      'hs_code': hsCode,
      'weight_kg': weightKg,
      'volume_cbm': volumeCbm,
      'origin_country': originCountry,
      'unbs_number': unbsNumber,
      'denier': denier,
      'material': material,
      'supplier': supplier.toJson(),
      'category_id': categoryId,
      'current_stock': currentStock,
      'lead_time_days': leadTimeDays,
      'warehouse_loc': warehouseLoc,
      'seo_title': seoTitle,
      'seo_description': seoDescription,
      'search_keywords': searchKeywords,
      'slug': slug,
      'image_url': imageUrl,
      'media_urls': mediaUrls,
      'aspect_ratio': aspectRatio,
      'available_colors': availableColors.map((e) => e.toJson()).toList(),
      'available_sizes': availableSizes.map((e) => e.toJson()).toList(),
      'available_materials': availableMaterials.map((e) => e.toJson()).toList(),
      'variant_label': variantLabel,
      'support': support.toJson(),
      'trading_terms': tradingTerms.toJson(),
    };
  }

  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      sku: product.sku,
      name: product.name,
      brand: product.brand,
      priceTiers: product.priceTiers,
      srp: product.srp,
      hsCode: product.hsCode,
      weightKg: product.weightKg,
      volumeCbm: product.volumeCbm,
      originCountry: product.originCountry,
      unbsNumber: product.unbsNumber,
      denier: product.denier,
      material: product.material,
      supplier: product.supplier,
      categoryId: product.categoryId,
      currentStock: product.currentStock,
      leadTimeDays: product.leadTimeDays,
      warehouseLoc: product.warehouseLoc,
      seoTitle: product.seoTitle,
      seoDescription: product.seoDescription,
      searchKeywords: product.searchKeywords,
      slug: product.slug,
      imageUrl: product.imageUrl,
      mediaUrls: product.mediaUrls,
      aspectRatio: product.aspectRatio,
      availableColors: product.availableColors,
      availableSizes: product.availableSizes,
      availableMaterials: product.availableMaterials,
      variantLabel: product.variantLabel,
      support: product.support,
      tradingTerms: product.tradingTerms,
    );
  }

  factory ProductModel.fromDrift(ProductEntry entry) {
    return ProductModel(
      id: entry.id,
      sku: entry.sku,
      name: entry.name,
      brand: entry.brand,
      priceTiers: (jsonDecode(entry.priceTiers) as List)
          .map((e) => PriceTier.fromJson(e as Map<String, dynamic>))
          .toList(),
      srp: entry.srp,
      hsCode: entry.hsCode,
      weightKg: entry.weightKg,
      volumeCbm: entry.volumeCbm,
      originCountry: entry.originCountry,
      unbsNumber: entry.unbsNumber,
      denier: entry.denier,
      material: entry.material,
      supplier: Supplier.fromJson(jsonDecode(entry.supplierJson)),
      categoryId: entry.categoryId,
      currentStock: entry.currentStock,
      leadTimeDays: entry.leadTimeDays,
      warehouseLoc: entry.warehouseLoc,
      seoTitle: entry.seoTitle,
      seoDescription: entry.seoDescription,
      searchKeywords: entry.searchKeywords.split(','),
      slug: entry.slug,
      imageUrl: entry.imageUrl,
      mediaUrls: entry.mediaUrls != null
          ? (jsonDecode(entry.mediaUrls!) as List).cast<String>().toSet().toList()
          : [],
      aspectRatio: entry.aspectRatio,
      availableColors: entry.availableColors != null
          ? (jsonDecode(entry.availableColors!) as List)
                .map((e) => ProductColor.fromJson(e))
                .toList()
          : [],
      availableSizes: entry.availableSizes != null
          ? (jsonDecode(entry.availableSizes!) as List)
                .map((e) => ProductSize.fromJson(e))
                .toList()
          : [],
      availableMaterials: entry.availableMaterials != null
          ? (jsonDecode(entry.availableMaterials!) as List)
                .map((e) => ProductMaterial.fromJson(e))
                .toList()
          : [],
      support: entry.supportJson != null
          ? ProductSupport.fromJson(jsonDecode(entry.supportJson!))
          : const ProductSupport(
              whatsapp: '+256 000 000 000',
              phone: '+256 000 000 000',
              email: 'support@node.app',
            ),
      tradingTerms: entry.tradingTermsJson != null
          ? TradingTerms.fromJson(jsonDecode(entry.tradingTermsJson!))
          : const TradingTerms(
              id: 'tt_default',
              content:
                  'Standard trading terms apply for all wholesale transactions.',
            ),
    );
  }

  ProductsTableCompanion toDrift() {
    return ProductsTableCompanion(
      id: Value(id),
      sku: Value(sku),
      name: Value(name),
      brand: Value(brand),
      srp: Value(srp),
      priceTiers: Value(jsonEncode(priceTiers.map((e) => e.toJson()).toList())),
      hsCode: Value(hsCode),
      weightKg: Value(weightKg),
      volumeCbm: Value(volumeCbm),
      originCountry: Value(originCountry),
      unbsNumber: Value(unbsNumber),
      denier: Value(denier),
      material: Value(material),
      supplierId: Value(supplier.id),
      supplierJson: Value(jsonEncode(supplier.toJson())),
      categoryId: Value(categoryId),
      currentStock: Value(currentStock),
      leadTimeDays: Value(leadTimeDays),
      warehouseLoc: Value(warehouseLoc),
      seoTitle: Value(seoTitle),
      seoDescription: Value(seoDescription),
      searchKeywords: Value(searchKeywords.join(',')),
      slug: Value(slug),
      imageUrl: Value(imageUrl),
      mediaUrls: Value(jsonEncode(mediaUrls)),
      aspectRatio: Value(aspectRatio),
      availableColors: Value(
        jsonEncode(availableColors.map((e) => e.toJson()).toList()),
      ),
      availableSizes: Value(
        jsonEncode(availableSizes.map((e) => e.toJson()).toList()),
      ),
      availableMaterials: Value(
        jsonEncode(availableMaterials.map((e) => e.toJson()).toList()),
      ),
      supportJson: Value(jsonEncode(support.toJson())),
      tradingTermsJson: Value(jsonEncode(tradingTerms.toJson())),
    );
  }
}
