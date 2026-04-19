import 'package:node_app/core/database/app_database.dart';
import 'package:node_app/features/inventory/data/models/product_model.dart';
import 'package:node_app/features/inventory/domain/entities/price_tier.dart';
import 'package:node_app/features/inventory/domain/entities/product_attributes.dart';
import 'package:node_app/features/inventory/domain/entities/trading_terms.dart';
import 'package:node_app/features/home/domain/entities/supplier.dart';
import 'package:node_app/core/domain/entities/location.dart';

class SeedDataService {
  static Future<void> seedDatabase(AppDatabase db) async {
    // 1. Seed Categories
    await _seedCategories(db);

    // 2. Seed Products
    await _seedProducts(db);

    // Note: Legal Terms are NOT seeded locally.
    // They are fetched live from Supabase via LegalTermsRepository.
  }

  /// Syncs legal terms directly from Supabase into the local DB.
  /// Does NOT fall back to hardcoded content — terms must come from the cloud.
  static Future<void> syncLegalFromRemote(
    AppDatabase db,
    dynamic repository,
  ) async {
    print('📡 [Seed] Syncing legal terms from Supabase...');
    await repository.syncToLocal(db);
    print('✅ [Seed] Legal terms synced from Supabase.');
  }

  static Future<void> _seedCategories(AppDatabase db) async {
    final categories = [];

    for (final cat in categories) {
      await db
          .into(db.categoriesTable)
          .insertOnConflictUpdate(
            CategoryEntry(
              id: cat['id'] as String,
              name: cat['name'] as String,
              parentId: cat['parentId'] as String?,
              level: cat['level'] as int,
              imageUrl: null,
              itemCount: 0,
              priority: cat['priority'] as int? ?? 0,
              usageCount: cat['usageCount'] as int? ?? 0,
              isDirty: false,
            ),
          );
    }
  }

  static Future<void> _seedProducts(AppDatabase db) async {
    final supplierAcme = const Supplier(
      id: 'sup_1',
      name: 'Acme Corp',
      imageUrl:
          'https://images.unsplash.com/photo-1565514020179-026b92b84bb6?q=80&w=400',
      category: 'Manufacturing',
      location: Location(
        latitude: 0.31628,
        longitude: 32.58219,
        addressName: 'Kampala Industrial Area',
      ),
    );

    final products = [
      ProductModel(
        id: 'p_1',
        sku: 'NODE-PERF-001',
        name: 'Node Performance Pro',
        brand: 'Node Athletics',
        priceTiers: [
          PriceTier(minQuantity: 10, price: 85000),
          PriceTier(minQuantity: 50, price: 75000),
          PriceTier(minQuantity: 100, price: 65000),
        ],
        srp: 120000,
        hsCode: '6404.11',
        weightKg: 0.8,
        volumeCbm: 0.012,
        originCountry: 'Vietnam',
        unbsNumber: 'UNBS-772',
        denier: '600D',
        material: 'Recycled Mesh / EVA',
        supplier: supplierAcme,
        categoryId: 'cat_fashion_footwear',
        currentStock: 1250,
        leadTimeDays: 14,
        warehouseLoc: 'Kampala Central',
        seoTitle: 'Wholesale Node Performance Pro Sneakers',
        seoDescription:
            'High-performance sneakers designed for bulk wholesale.',
        searchKeywords: const ['sneakers', 'running', 'sport'],
        slug: 'node-performance-pro',
        imageUrl:
            'https://images.unsplash.com/photo-1542291026-7eec264c27ff?q=80&w=800',
        availableColors: [
          ProductColor(name: 'Navy', hexCode: '#1A237E'),
          ProductColor(name: 'Black', hexCode: '#000000'),
          ProductColor(name: 'Red', hexCode: '#D32F2F'),
        ],
        availableSizes: [
          ProductSize(name: 'Medium', abbreviation: 'M'),
          ProductSize(name: 'Large', abbreviation: 'L'),
        ],
        support: const ProductSupport(
          whatsapp: '+256 746010410',
          phone: '+256 000 001',
          email: 'athletics@node.app',
        ),
        tradingTerms: const TradingTerms(
          id: 'tt_shoes',
          content: 'MOQ of 10 pairs.',
        ),
      ),
      ProductModel(
        id: 'p_2',
        sku: 'NET-EAG-001',
        name: 'Eagle Brand Mosquito Net',
        brand: 'Eagle China',
        priceTiers: [
          PriceTier(minQuantity: 50, price: 18000),
          PriceTier(minQuantity: 100, price: 16500),
        ],
        srp: 24500,
        hsCode: '6304.91',
        weightKg: 0.45,
        volumeCbm: 0.002,
        originCountry: 'China',
        unbsNumber: 'UNBS-7723',
        denier: '75D',
        material: '100% Polyester',
        supplier: supplierAcme,
        categoryId: 'cat_home',
        currentStock: 450,
        leadTimeDays: 0,
        warehouseLoc: 'Kampala Central',
        seoTitle: 'Wholesale Eagle Brand Nets',
        seoDescription: 'High quality long lasting nets',
        searchKeywords: const ['net', 'mosquito'],
        slug: 'eagle-net',
        imageUrl:
            'https://images.unsplash.com/photo-1627384113743-6bd5a479fffd?q=80&w=400',
        support: const ProductSupport(
          whatsapp: '+256 700 000 003',
          phone: '+256 300 000 003',
          email: 'nets@node.app',
        ),
        tradingTerms: const TradingTerms(
          id: 'tt_nets',
          content: 'Minimum order 50 units.',
        ),
      ),
    ];

    for (final product in products) {
      await db.into(db.productsTable).insertOnConflictUpdate(product.toDrift());
    }
  }
}
