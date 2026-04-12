import 'package:equatable/equatable.dart';
import 'package:node_app/features/home/domain/entities/supplier.dart';
import 'price_tier.dart';
import 'product_attributes.dart';
import 'trading_terms.dart';

class Product extends Equatable {
  // --- Convenience Getters ---
  String get supplierId => supplier.id;

  // --- Basic Identity ---
  final String id;
  final String sku;
  final String name;
  final String brand; // e.g., "Eagle Brand China"

  // --- Tiered Wholesale Pricing (The "Pro" Logic) ---
  final List<PriceTier> priceTiers;
  final double srp;

  // --- Logistics & Customs ---
  final String hsCode; // For Google/Customs
  final double weightKg; // Physical weight
  final double volumeCbm; // For truck space calculation
  final String originCountry; // e.g., "China"

  // --- Compliance & Trust ---
  final String unbsNumber; // Quality certification
  final String denier; // Specific to textiles/nets
  final String material; // e.g., "100% Polyester" (Legacy/Description)

  // --- Supply Chain ---
  final Supplier supplier;
  final String categoryId;
  final int currentStock;
  final int leadTimeDays; // 0 if in Kampala, >0 if in transit
  final String warehouseLoc; // Physical location

  // --- Advanced SEO & Search ---
  final String seoTitle;
  final String seoDescription;
  final List<String>
  searchKeywords; // Synonyms: "Net", "Obutimba", "Pest control"
  final String slug;
  final String imageUrl; // Required for core UI
  final List<String> mediaUrls; // Supporting multiple gallery images
  final double aspectRatio; // For masonry grid tallness (1.0, 0.75, etc.)

  // --- Rich Attributes (Place Order View) ---
  final List<ProductColor> availableColors;
  final List<ProductSize> availableSizes;
  final List<ProductMaterial> availableMaterials;
  final String variantLabel;
  final ProductSupport support;
  final TradingTerms tradingTerms;

  Product({
    required this.id,
    required this.sku,
    required this.name,
    required this.brand,
    required this.priceTiers,
    required this.srp,
    required this.hsCode,
    required this.weightKg,
    required this.volumeCbm,
    required this.originCountry,
    required this.unbsNumber,
    required this.denier,
    required this.material,
    required this.supplier,
    required this.categoryId,
    required this.currentStock,
    required this.leadTimeDays,
    required this.warehouseLoc,
    required this.seoTitle,
    required this.seoDescription,
    required this.searchKeywords,
    required this.slug,
    required this.imageUrl,
    this.mediaUrls = const [],
    this.aspectRatio = 1.0,
    this.availableColors = const [],
    this.availableSizes = const [],
    this.availableMaterials = const [],
    required this.support,
    required this.tradingTerms,
    this.variantLabel = 'Size', // Default label
  });

  Product copyWith({
    double? srp,
    int? currentStock,
    int? leadTimeDays,
    List<PriceTier>? priceTiers,
    String? seoDescription,
    TradingTerms? tradingTerms,
  }) {
    return Product(
      id: id,
      sku: sku,
      name: name,
      brand: brand,
      priceTiers: priceTiers ?? this.priceTiers,
      srp: srp ?? this.srp,
      hsCode: hsCode,
      weightKg: weightKg,
      volumeCbm: volumeCbm,
      originCountry: originCountry,
      unbsNumber: unbsNumber,
      denier: denier,
      material: material,
      supplier: supplier,
      categoryId: categoryId,
      currentStock: currentStock ?? this.currentStock,
      leadTimeDays: leadTimeDays ?? this.leadTimeDays,
      warehouseLoc: warehouseLoc,
      seoTitle: seoTitle,
      seoDescription: seoDescription ?? this.seoDescription,
      searchKeywords: searchKeywords,
      slug: slug,
      imageUrl: imageUrl,
      mediaUrls: mediaUrls,
      aspectRatio: aspectRatio,
      availableColors: availableColors,
      availableSizes: availableSizes,
      availableMaterials: availableMaterials,
      support: support,
      tradingTerms: tradingTerms ?? this.tradingTerms,
      variantLabel: variantLabel,
    );
  }

  // Business Logic: Get price based on requested quantity
  double getPriceForQuantity(int qty) {
    if (priceTiers.isEmpty) return srp; // Fallback

    // Sort tiers by quantity to be safe
    final sortedTiers = [...priceTiers]
      ..sort((a, b) => a.minQuantity.compareTo(b.minQuantity));

    double bestPrice = sortedTiers.first.price;
    for (var tier in sortedTiers) {
      if (qty >= tier.minQuantity) bestPrice = tier.price;
    }
    return bestPrice;
  }

  @override
  List<Object?> get props => [
    id,
    sku,
    name,
    brand,
    priceTiers,
    srp,
    hsCode,
    weightKg,
    volumeCbm,
    originCountry,
    unbsNumber,
    denier,
    material,
    supplier,
    categoryId,
    currentStock,
    leadTimeDays,
    warehouseLoc,
    seoTitle,
    seoDescription,
    searchKeywords,
    slug,
    imageUrl,
    mediaUrls,
    aspectRatio,
    availableColors,
    availableSizes,
    availableMaterials,
    support,
    tradingTerms,
  ];
}
