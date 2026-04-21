import 'dart:convert';
import 'package:node_app/features/home/domain/entities/supplier.dart';
import 'package:node_app/core/domain/entities/location.dart';
import 'package:node_app/features/inventory/domain/entities/price_tier.dart';
import 'package:node_app/features/inventory/domain/entities/product.dart';
import 'package:node_app/features/inventory/domain/entities/product_attributes.dart';
import 'package:node_app/features/inventory/domain/entities/trading_terms.dart';
import 'package:node_app/features/profile/domain/entities/saved_product.dart';
import 'package:node_app/core/database/app_database.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// Converts a persisted BulkOrderEntry (from Drift DB) into a SavedProduct
/// so MultiProductOrderPage can display and edit its configuration.
/// ─────────────────────────────────────────────────────────────────────────────
SavedProduct bulkEntryToSavedProduct(BulkOrderEntry entry) {
  // Decode color config from configJson: [{ colorName, hexCode, sizeQtys }]
  final List<dynamic> config = safeJsonList(entry.configJson);

  // Build a fallback map of color names to hex codes from the actual configuration
  final Map<String, String> hexFallbackMap = {};
  for (final g in config) {
    if (g is Map<String, dynamic>) {
      final name = g['colorName'] as String?;
      final hex = g['hexCode'] as String?;
      if (name != null && hex != null) {
        hexFallbackMap[name.toLowerCase()] = hex.startsWith('#')
            ? hex
            : '#$hex';
      }
    }
  }

  // Decode available colors from stored rich JSON
  final List<dynamic> rawColors = safeJsonList(entry.availableColorsJson);
  List<ProductColor> colors = rawColors.map<ProductColor>((c) {
    if (c is String) {
      // Recovery logic for legacy data
      final fallbackHex = hexFallbackMap[c.toLowerCase()];
      return ProductColor(name: c, hexCode: fallbackHex ?? '#808080');
    }
    final map = c as Map<String, dynamic>;
    final name = (map['name'] ?? map['colorName']) as String? ?? 'Default';
    final hex =
        (map['hexCode'] ?? map['hex']) as String? ??
        hexFallbackMap[name.toLowerCase()] ??
        '#808080';
    return ProductColor(name: name, hexCode: hex);
  }).toList();

  // If we have no available colors list, at least show the colors currently in the config
  if (colors.isEmpty && hexFallbackMap.isNotEmpty) {
    colors = hexFallbackMap.entries.map((e) {
      return ProductColor(name: e.key, hexCode: e.value);
    }).toList();
  }

  // Decode available sizes from stored rich JSON
  final List<dynamic> rawSizes = safeJsonList(entry.availableSizesJson);
  final List<ProductSize> sizes = rawSizes.map<ProductSize>((s) {
    if (s is String) return ProductSize(name: s, abbreviation: s);
    final map = s as Map<String, dynamic>;
    return ProductSize(
      name: map['name'] as String? ?? '',
      abbreviation: map['abbreviation'] as String? ?? '',
    );
  }).toList();

  // Decode available materials from stored rich JSON
  final List<dynamic> rawMaterials = safeJsonList(
    entry.availableMaterialsJson,
  );
  final List<ProductMaterial> materials = rawMaterials.map<ProductMaterial>((
    m,
  ) {
    if (m is String) return ProductMaterial(name: m);
    final map = m as Map<String, dynamic>;
    return ProductMaterial(
      name: map['name'] as String? ?? '',
      imageUrl: map['imageUrl'] as String?,
    );
  }).toList();

  // Pull first color + first size from config for the pre-selected state
  String? firstColor;
  String? firstSize;
  int firstQty = 1;
  if (config.isNotEmpty) {
    final firstGroup = config.first as Map<String, dynamic>;
    firstColor = firstGroup['colorName'] as String?;
    final sizeQtys = firstGroup['sizeQtys'];
    if (sizeQtys is Map && sizeQtys.isNotEmpty) {
      firstSize = sizeQtys.keys.first as String?;
      firstQty = (sizeQtys.values.first as num?)?.toInt() ?? 1;
    }
  }

  // Build a minimal shell Product
  const emptySupplier = Supplier(
    id: '',
    name: '',
    imageUrl: '',
    category: '',
    location: Location(latitude: 0, longitude: 0, addressName: ''),
  );

  // Decode price tiers ["minQuantity", "price"]
  final List<dynamic> rawTiers = safeJsonList(entry.priceTiersJson);
  final List<PriceTier> priceTiers = rawTiers.map((t) {
    final map = t as Map<String, dynamic>;
    return PriceTier(
      price: (map['price'] as num).toDouble(),
      minQuantity: (map['minQuantity'] as num).toInt(),
    );
  }).toList();

  // Decode trading terms
  TradingTerms tradingTerms = const TradingTerms(
    id: 'tt_saved',
    content: 'Standard trading terms apply for saved items.',
  );
  if (entry.tradingTermsJson != null && entry.tradingTermsJson!.isNotEmpty) {
    try {
      tradingTerms = TradingTerms.fromJson(jsonDecode(entry.tradingTermsJson!));
    } catch (_) {}
  }

  final product = Product(
    id: entry.id,
    sku: entry.id,
    name: entry.productName,
    brand: entry.brand ?? '',
    priceTiers: priceTiers,
    srp: entry.srp,
    hsCode: '',
    weightKg: 0,
    volumeCbm: 0,
    originCountry: '',
    unbsNumber: '',
    denier: '',
    material: '',
    supplier: emptySupplier,
    categoryId: entry.category,
    currentStock: entry.currentStock,
    leadTimeDays: entry.leadTimeDays,
    warehouseLoc: '',
    seoTitle: '',
    seoDescription: entry.seoDescription ?? '',
    searchKeywords: const [],
    slug: entry.id,
    imageUrl: entry.imageUrl ?? '',
    availableColors: colors,
    availableSizes: sizes,
    availableMaterials: materials,
    variantLabel: entry.variantLabel,
    support: const ProductSupport(
      whatsapp: '+256 700 000 000',
      phone: '+256 000 000 000',
      email: 'support@node.app',
    ),
    tradingTerms: tradingTerms,
  );

  return SavedProduct(
    product: product,
    quantity: firstQty,
    selectedColor: firstColor,
    selectedSize: firstSize,
  );
}

List<dynamic> safeJsonList(String? json) {
  if (json == null || json.isEmpty) return [];
  try {
    final decoded = jsonDecode(json);
    return decoded is List ? decoded : [];
  } catch (_) {
    return [];
  }
}
