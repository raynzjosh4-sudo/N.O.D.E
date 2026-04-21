// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProductsTableTable extends ProductsTable
    with TableInfo<$ProductsTableTable, ProductEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _skuMeta = const VerificationMeta('sku');
  @override
  late final GeneratedColumn<String> sku = GeneratedColumn<String>(
    'sku',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _srpMeta = const VerificationMeta('srp');
  @override
  late final GeneratedColumn<double> srp = GeneratedColumn<double>(
    'srp',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceTiersMeta = const VerificationMeta(
    'priceTiers',
  );
  @override
  late final GeneratedColumn<String> priceTiers = GeneratedColumn<String>(
    'price_tiers',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hsCodeMeta = const VerificationMeta('hsCode');
  @override
  late final GeneratedColumn<String> hsCode = GeneratedColumn<String>(
    'hs_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _volumeCbmMeta = const VerificationMeta(
    'volumeCbm',
  );
  @override
  late final GeneratedColumn<double> volumeCbm = GeneratedColumn<double>(
    'volume_cbm',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originCountryMeta = const VerificationMeta(
    'originCountry',
  );
  @override
  late final GeneratedColumn<String> originCountry = GeneratedColumn<String>(
    'origin_country',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unbsNumberMeta = const VerificationMeta(
    'unbsNumber',
  );
  @override
  late final GeneratedColumn<String> unbsNumber = GeneratedColumn<String>(
    'unbs_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _denierMeta = const VerificationMeta('denier');
  @override
  late final GeneratedColumn<String> denier = GeneratedColumn<String>(
    'denier',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _materialMeta = const VerificationMeta(
    'material',
  );
  @override
  late final GeneratedColumn<String> material = GeneratedColumn<String>(
    'material',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _supplierIdMeta = const VerificationMeta(
    'supplierId',
  );
  @override
  late final GeneratedColumn<String> supplierId = GeneratedColumn<String>(
    'supplier_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _supplierJsonMeta = const VerificationMeta(
    'supplierJson',
  );
  @override
  late final GeneratedColumn<String> supplierJson = GeneratedColumn<String>(
    'supplier_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentStockMeta = const VerificationMeta(
    'currentStock',
  );
  @override
  late final GeneratedColumn<int> currentStock = GeneratedColumn<int>(
    'current_stock',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _leadTimeDaysMeta = const VerificationMeta(
    'leadTimeDays',
  );
  @override
  late final GeneratedColumn<int> leadTimeDays = GeneratedColumn<int>(
    'lead_time_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _warehouseLocMeta = const VerificationMeta(
    'warehouseLoc',
  );
  @override
  late final GeneratedColumn<String> warehouseLoc = GeneratedColumn<String>(
    'warehouse_loc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _seoTitleMeta = const VerificationMeta(
    'seoTitle',
  );
  @override
  late final GeneratedColumn<String> seoTitle = GeneratedColumn<String>(
    'seo_title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _seoDescriptionMeta = const VerificationMeta(
    'seoDescription',
  );
  @override
  late final GeneratedColumn<String> seoDescription = GeneratedColumn<String>(
    'seo_description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _searchKeywordsMeta = const VerificationMeta(
    'searchKeywords',
  );
  @override
  late final GeneratedColumn<String> searchKeywords = GeneratedColumn<String>(
    'search_keywords',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
    'slug',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mediaUrlsMeta = const VerificationMeta(
    'mediaUrls',
  );
  @override
  late final GeneratedColumn<String> mediaUrls = GeneratedColumn<String>(
    'media_urls',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _aspectRatioMeta = const VerificationMeta(
    'aspectRatio',
  );
  @override
  late final GeneratedColumn<double> aspectRatio = GeneratedColumn<double>(
    'aspect_ratio',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.0),
  );
  static const VerificationMeta _availableColorsMeta = const VerificationMeta(
    'availableColors',
  );
  @override
  late final GeneratedColumn<String> availableColors = GeneratedColumn<String>(
    'available_colors',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _availableSizesMeta = const VerificationMeta(
    'availableSizes',
  );
  @override
  late final GeneratedColumn<String> availableSizes = GeneratedColumn<String>(
    'available_sizes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _availableMaterialsMeta =
      const VerificationMeta('availableMaterials');
  @override
  late final GeneratedColumn<String> availableMaterials =
      GeneratedColumn<String>(
        'available_materials',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _supportJsonMeta = const VerificationMeta(
    'supportJson',
  );
  @override
  late final GeneratedColumn<String> supportJson = GeneratedColumn<String>(
    'support_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tradingTermsJsonMeta = const VerificationMeta(
    'tradingTermsJson',
  );
  @override
  late final GeneratedColumn<String> tradingTermsJson = GeneratedColumn<String>(
    'trading_terms_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isDirtyMeta = const VerificationMeta(
    'isDirty',
  );
  @override
  late final GeneratedColumn<bool> isDirty = GeneratedColumn<bool>(
    'is_dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_dirty" IN (0, 1))',
    ),
    defaultValue: Constant(false),
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sku,
    name,
    brand,
    srp,
    priceTiers,
    hsCode,
    weightKg,
    volumeCbm,
    originCountry,
    unbsNumber,
    denier,
    material,
    supplierId,
    supplierJson,
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
    supportJson,
    tradingTermsJson,
    isDirty,
    lastSyncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('sku')) {
      context.handle(
        _skuMeta,
        sku.isAcceptableOrUnknown(data['sku']!, _skuMeta),
      );
    } else if (isInserting) {
      context.missing(_skuMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    } else if (isInserting) {
      context.missing(_brandMeta);
    }
    if (data.containsKey('srp')) {
      context.handle(
        _srpMeta,
        srp.isAcceptableOrUnknown(data['srp']!, _srpMeta),
      );
    } else if (isInserting) {
      context.missing(_srpMeta);
    }
    if (data.containsKey('price_tiers')) {
      context.handle(
        _priceTiersMeta,
        priceTiers.isAcceptableOrUnknown(data['price_tiers']!, _priceTiersMeta),
      );
    } else if (isInserting) {
      context.missing(_priceTiersMeta);
    }
    if (data.containsKey('hs_code')) {
      context.handle(
        _hsCodeMeta,
        hsCode.isAcceptableOrUnknown(data['hs_code']!, _hsCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_hsCodeMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('volume_cbm')) {
      context.handle(
        _volumeCbmMeta,
        volumeCbm.isAcceptableOrUnknown(data['volume_cbm']!, _volumeCbmMeta),
      );
    } else if (isInserting) {
      context.missing(_volumeCbmMeta);
    }
    if (data.containsKey('origin_country')) {
      context.handle(
        _originCountryMeta,
        originCountry.isAcceptableOrUnknown(
          data['origin_country']!,
          _originCountryMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originCountryMeta);
    }
    if (data.containsKey('unbs_number')) {
      context.handle(
        _unbsNumberMeta,
        unbsNumber.isAcceptableOrUnknown(data['unbs_number']!, _unbsNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_unbsNumberMeta);
    }
    if (data.containsKey('denier')) {
      context.handle(
        _denierMeta,
        denier.isAcceptableOrUnknown(data['denier']!, _denierMeta),
      );
    } else if (isInserting) {
      context.missing(_denierMeta);
    }
    if (data.containsKey('material')) {
      context.handle(
        _materialMeta,
        material.isAcceptableOrUnknown(data['material']!, _materialMeta),
      );
    } else if (isInserting) {
      context.missing(_materialMeta);
    }
    if (data.containsKey('supplier_id')) {
      context.handle(
        _supplierIdMeta,
        supplierId.isAcceptableOrUnknown(data['supplier_id']!, _supplierIdMeta),
      );
    } else if (isInserting) {
      context.missing(_supplierIdMeta);
    }
    if (data.containsKey('supplier_json')) {
      context.handle(
        _supplierJsonMeta,
        supplierJson.isAcceptableOrUnknown(
          data['supplier_json']!,
          _supplierJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_supplierJsonMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('current_stock')) {
      context.handle(
        _currentStockMeta,
        currentStock.isAcceptableOrUnknown(
          data['current_stock']!,
          _currentStockMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentStockMeta);
    }
    if (data.containsKey('lead_time_days')) {
      context.handle(
        _leadTimeDaysMeta,
        leadTimeDays.isAcceptableOrUnknown(
          data['lead_time_days']!,
          _leadTimeDaysMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_leadTimeDaysMeta);
    }
    if (data.containsKey('warehouse_loc')) {
      context.handle(
        _warehouseLocMeta,
        warehouseLoc.isAcceptableOrUnknown(
          data['warehouse_loc']!,
          _warehouseLocMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_warehouseLocMeta);
    }
    if (data.containsKey('seo_title')) {
      context.handle(
        _seoTitleMeta,
        seoTitle.isAcceptableOrUnknown(data['seo_title']!, _seoTitleMeta),
      );
    } else if (isInserting) {
      context.missing(_seoTitleMeta);
    }
    if (data.containsKey('seo_description')) {
      context.handle(
        _seoDescriptionMeta,
        seoDescription.isAcceptableOrUnknown(
          data['seo_description']!,
          _seoDescriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_seoDescriptionMeta);
    }
    if (data.containsKey('search_keywords')) {
      context.handle(
        _searchKeywordsMeta,
        searchKeywords.isAcceptableOrUnknown(
          data['search_keywords']!,
          _searchKeywordsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_searchKeywordsMeta);
    }
    if (data.containsKey('slug')) {
      context.handle(
        _slugMeta,
        slug.isAcceptableOrUnknown(data['slug']!, _slugMeta),
      );
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_imageUrlMeta);
    }
    if (data.containsKey('media_urls')) {
      context.handle(
        _mediaUrlsMeta,
        mediaUrls.isAcceptableOrUnknown(data['media_urls']!, _mediaUrlsMeta),
      );
    }
    if (data.containsKey('aspect_ratio')) {
      context.handle(
        _aspectRatioMeta,
        aspectRatio.isAcceptableOrUnknown(
          data['aspect_ratio']!,
          _aspectRatioMeta,
        ),
      );
    }
    if (data.containsKey('available_colors')) {
      context.handle(
        _availableColorsMeta,
        availableColors.isAcceptableOrUnknown(
          data['available_colors']!,
          _availableColorsMeta,
        ),
      );
    }
    if (data.containsKey('available_sizes')) {
      context.handle(
        _availableSizesMeta,
        availableSizes.isAcceptableOrUnknown(
          data['available_sizes']!,
          _availableSizesMeta,
        ),
      );
    }
    if (data.containsKey('available_materials')) {
      context.handle(
        _availableMaterialsMeta,
        availableMaterials.isAcceptableOrUnknown(
          data['available_materials']!,
          _availableMaterialsMeta,
        ),
      );
    }
    if (data.containsKey('support_json')) {
      context.handle(
        _supportJsonMeta,
        supportJson.isAcceptableOrUnknown(
          data['support_json']!,
          _supportJsonMeta,
        ),
      );
    }
    if (data.containsKey('trading_terms_json')) {
      context.handle(
        _tradingTermsJsonMeta,
        tradingTermsJson.isAcceptableOrUnknown(
          data['trading_terms_json']!,
          _tradingTermsJsonMeta,
        ),
      );
    }
    if (data.containsKey('is_dirty')) {
      context.handle(
        _isDirtyMeta,
        isDirty.isAcceptableOrUnknown(data['is_dirty']!, _isDirtyMeta),
      );
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sku: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sku'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      )!,
      srp: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}srp'],
      )!,
      priceTiers: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}price_tiers'],
      )!,
      hsCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hs_code'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      )!,
      volumeCbm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}volume_cbm'],
      )!,
      originCountry: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}origin_country'],
      )!,
      unbsNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unbs_number'],
      )!,
      denier: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}denier'],
      )!,
      material: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}material'],
      )!,
      supplierId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplier_id'],
      )!,
      supplierJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplier_json'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      currentStock: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_stock'],
      )!,
      leadTimeDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lead_time_days'],
      )!,
      warehouseLoc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}warehouse_loc'],
      )!,
      seoTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}seo_title'],
      )!,
      seoDescription: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}seo_description'],
      )!,
      searchKeywords: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}search_keywords'],
      )!,
      slug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slug'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      )!,
      mediaUrls: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_urls'],
      ),
      aspectRatio: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}aspect_ratio'],
      )!,
      availableColors: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}available_colors'],
      ),
      availableSizes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}available_sizes'],
      ),
      availableMaterials: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}available_materials'],
      ),
      supportJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}support_json'],
      ),
      tradingTermsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trading_terms_json'],
      ),
      isDirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_dirty'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      ),
    );
  }

  @override
  $ProductsTableTable createAlias(String alias) {
    return $ProductsTableTable(attachedDatabase, alias);
  }
}

class ProductEntry extends DataClass implements Insertable<ProductEntry> {
  final String id;
  final String sku;
  final String name;
  final String brand;
  final double srp;
  final String priceTiers;
  final String hsCode;
  final double weightKg;
  final double volumeCbm;
  final String originCountry;
  final String unbsNumber;
  final String denier;
  final String material;
  final String supplierId;
  final String supplierJson;
  final String categoryId;
  final int currentStock;
  final int leadTimeDays;
  final String warehouseLoc;
  final String seoTitle;
  final String seoDescription;
  final String searchKeywords;
  final String slug;
  final String imageUrl;
  final String? mediaUrls;
  final double aspectRatio;
  final String? availableColors;
  final String? availableSizes;
  final String? availableMaterials;
  final String? supportJson;
  final String? tradingTermsJson;
  final bool isDirty;
  final DateTime? lastSyncedAt;
  const ProductEntry({
    required this.id,
    required this.sku,
    required this.name,
    required this.brand,
    required this.srp,
    required this.priceTiers,
    required this.hsCode,
    required this.weightKg,
    required this.volumeCbm,
    required this.originCountry,
    required this.unbsNumber,
    required this.denier,
    required this.material,
    required this.supplierId,
    required this.supplierJson,
    required this.categoryId,
    required this.currentStock,
    required this.leadTimeDays,
    required this.warehouseLoc,
    required this.seoTitle,
    required this.seoDescription,
    required this.searchKeywords,
    required this.slug,
    required this.imageUrl,
    this.mediaUrls,
    required this.aspectRatio,
    this.availableColors,
    this.availableSizes,
    this.availableMaterials,
    this.supportJson,
    this.tradingTermsJson,
    required this.isDirty,
    this.lastSyncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sku'] = Variable<String>(sku);
    map['name'] = Variable<String>(name);
    map['brand'] = Variable<String>(brand);
    map['srp'] = Variable<double>(srp);
    map['price_tiers'] = Variable<String>(priceTiers);
    map['hs_code'] = Variable<String>(hsCode);
    map['weight_kg'] = Variable<double>(weightKg);
    map['volume_cbm'] = Variable<double>(volumeCbm);
    map['origin_country'] = Variable<String>(originCountry);
    map['unbs_number'] = Variable<String>(unbsNumber);
    map['denier'] = Variable<String>(denier);
    map['material'] = Variable<String>(material);
    map['supplier_id'] = Variable<String>(supplierId);
    map['supplier_json'] = Variable<String>(supplierJson);
    map['category_id'] = Variable<String>(categoryId);
    map['current_stock'] = Variable<int>(currentStock);
    map['lead_time_days'] = Variable<int>(leadTimeDays);
    map['warehouse_loc'] = Variable<String>(warehouseLoc);
    map['seo_title'] = Variable<String>(seoTitle);
    map['seo_description'] = Variable<String>(seoDescription);
    map['search_keywords'] = Variable<String>(searchKeywords);
    map['slug'] = Variable<String>(slug);
    map['image_url'] = Variable<String>(imageUrl);
    if (!nullToAbsent || mediaUrls != null) {
      map['media_urls'] = Variable<String>(mediaUrls);
    }
    map['aspect_ratio'] = Variable<double>(aspectRatio);
    if (!nullToAbsent || availableColors != null) {
      map['available_colors'] = Variable<String>(availableColors);
    }
    if (!nullToAbsent || availableSizes != null) {
      map['available_sizes'] = Variable<String>(availableSizes);
    }
    if (!nullToAbsent || availableMaterials != null) {
      map['available_materials'] = Variable<String>(availableMaterials);
    }
    if (!nullToAbsent || supportJson != null) {
      map['support_json'] = Variable<String>(supportJson);
    }
    if (!nullToAbsent || tradingTermsJson != null) {
      map['trading_terms_json'] = Variable<String>(tradingTermsJson);
    }
    map['is_dirty'] = Variable<bool>(isDirty);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    return map;
  }

  ProductsTableCompanion toCompanion(bool nullToAbsent) {
    return ProductsTableCompanion(
      id: Value(id),
      sku: Value(sku),
      name: Value(name),
      brand: Value(brand),
      srp: Value(srp),
      priceTiers: Value(priceTiers),
      hsCode: Value(hsCode),
      weightKg: Value(weightKg),
      volumeCbm: Value(volumeCbm),
      originCountry: Value(originCountry),
      unbsNumber: Value(unbsNumber),
      denier: Value(denier),
      material: Value(material),
      supplierId: Value(supplierId),
      supplierJson: Value(supplierJson),
      categoryId: Value(categoryId),
      currentStock: Value(currentStock),
      leadTimeDays: Value(leadTimeDays),
      warehouseLoc: Value(warehouseLoc),
      seoTitle: Value(seoTitle),
      seoDescription: Value(seoDescription),
      searchKeywords: Value(searchKeywords),
      slug: Value(slug),
      imageUrl: Value(imageUrl),
      mediaUrls: mediaUrls == null && nullToAbsent
          ? const Value.absent()
          : Value(mediaUrls),
      aspectRatio: Value(aspectRatio),
      availableColors: availableColors == null && nullToAbsent
          ? const Value.absent()
          : Value(availableColors),
      availableSizes: availableSizes == null && nullToAbsent
          ? const Value.absent()
          : Value(availableSizes),
      availableMaterials: availableMaterials == null && nullToAbsent
          ? const Value.absent()
          : Value(availableMaterials),
      supportJson: supportJson == null && nullToAbsent
          ? const Value.absent()
          : Value(supportJson),
      tradingTermsJson: tradingTermsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(tradingTermsJson),
      isDirty: Value(isDirty),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
    );
  }

  factory ProductEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductEntry(
      id: serializer.fromJson<String>(json['id']),
      sku: serializer.fromJson<String>(json['sku']),
      name: serializer.fromJson<String>(json['name']),
      brand: serializer.fromJson<String>(json['brand']),
      srp: serializer.fromJson<double>(json['srp']),
      priceTiers: serializer.fromJson<String>(json['priceTiers']),
      hsCode: serializer.fromJson<String>(json['hsCode']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      volumeCbm: serializer.fromJson<double>(json['volumeCbm']),
      originCountry: serializer.fromJson<String>(json['originCountry']),
      unbsNumber: serializer.fromJson<String>(json['unbsNumber']),
      denier: serializer.fromJson<String>(json['denier']),
      material: serializer.fromJson<String>(json['material']),
      supplierId: serializer.fromJson<String>(json['supplierId']),
      supplierJson: serializer.fromJson<String>(json['supplierJson']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      currentStock: serializer.fromJson<int>(json['currentStock']),
      leadTimeDays: serializer.fromJson<int>(json['leadTimeDays']),
      warehouseLoc: serializer.fromJson<String>(json['warehouseLoc']),
      seoTitle: serializer.fromJson<String>(json['seoTitle']),
      seoDescription: serializer.fromJson<String>(json['seoDescription']),
      searchKeywords: serializer.fromJson<String>(json['searchKeywords']),
      slug: serializer.fromJson<String>(json['slug']),
      imageUrl: serializer.fromJson<String>(json['imageUrl']),
      mediaUrls: serializer.fromJson<String?>(json['mediaUrls']),
      aspectRatio: serializer.fromJson<double>(json['aspectRatio']),
      availableColors: serializer.fromJson<String?>(json['availableColors']),
      availableSizes: serializer.fromJson<String?>(json['availableSizes']),
      availableMaterials: serializer.fromJson<String?>(
        json['availableMaterials'],
      ),
      supportJson: serializer.fromJson<String?>(json['supportJson']),
      tradingTermsJson: serializer.fromJson<String?>(json['tradingTermsJson']),
      isDirty: serializer.fromJson<bool>(json['isDirty']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sku': serializer.toJson<String>(sku),
      'name': serializer.toJson<String>(name),
      'brand': serializer.toJson<String>(brand),
      'srp': serializer.toJson<double>(srp),
      'priceTiers': serializer.toJson<String>(priceTiers),
      'hsCode': serializer.toJson<String>(hsCode),
      'weightKg': serializer.toJson<double>(weightKg),
      'volumeCbm': serializer.toJson<double>(volumeCbm),
      'originCountry': serializer.toJson<String>(originCountry),
      'unbsNumber': serializer.toJson<String>(unbsNumber),
      'denier': serializer.toJson<String>(denier),
      'material': serializer.toJson<String>(material),
      'supplierId': serializer.toJson<String>(supplierId),
      'supplierJson': serializer.toJson<String>(supplierJson),
      'categoryId': serializer.toJson<String>(categoryId),
      'currentStock': serializer.toJson<int>(currentStock),
      'leadTimeDays': serializer.toJson<int>(leadTimeDays),
      'warehouseLoc': serializer.toJson<String>(warehouseLoc),
      'seoTitle': serializer.toJson<String>(seoTitle),
      'seoDescription': serializer.toJson<String>(seoDescription),
      'searchKeywords': serializer.toJson<String>(searchKeywords),
      'slug': serializer.toJson<String>(slug),
      'imageUrl': serializer.toJson<String>(imageUrl),
      'mediaUrls': serializer.toJson<String?>(mediaUrls),
      'aspectRatio': serializer.toJson<double>(aspectRatio),
      'availableColors': serializer.toJson<String?>(availableColors),
      'availableSizes': serializer.toJson<String?>(availableSizes),
      'availableMaterials': serializer.toJson<String?>(availableMaterials),
      'supportJson': serializer.toJson<String?>(supportJson),
      'tradingTermsJson': serializer.toJson<String?>(tradingTermsJson),
      'isDirty': serializer.toJson<bool>(isDirty),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
    };
  }

  ProductEntry copyWith({
    String? id,
    String? sku,
    String? name,
    String? brand,
    double? srp,
    String? priceTiers,
    String? hsCode,
    double? weightKg,
    double? volumeCbm,
    String? originCountry,
    String? unbsNumber,
    String? denier,
    String? material,
    String? supplierId,
    String? supplierJson,
    String? categoryId,
    int? currentStock,
    int? leadTimeDays,
    String? warehouseLoc,
    String? seoTitle,
    String? seoDescription,
    String? searchKeywords,
    String? slug,
    String? imageUrl,
    Value<String?> mediaUrls = const Value.absent(),
    double? aspectRatio,
    Value<String?> availableColors = const Value.absent(),
    Value<String?> availableSizes = const Value.absent(),
    Value<String?> availableMaterials = const Value.absent(),
    Value<String?> supportJson = const Value.absent(),
    Value<String?> tradingTermsJson = const Value.absent(),
    bool? isDirty,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
  }) => ProductEntry(
    id: id ?? this.id,
    sku: sku ?? this.sku,
    name: name ?? this.name,
    brand: brand ?? this.brand,
    srp: srp ?? this.srp,
    priceTiers: priceTiers ?? this.priceTiers,
    hsCode: hsCode ?? this.hsCode,
    weightKg: weightKg ?? this.weightKg,
    volumeCbm: volumeCbm ?? this.volumeCbm,
    originCountry: originCountry ?? this.originCountry,
    unbsNumber: unbsNumber ?? this.unbsNumber,
    denier: denier ?? this.denier,
    material: material ?? this.material,
    supplierId: supplierId ?? this.supplierId,
    supplierJson: supplierJson ?? this.supplierJson,
    categoryId: categoryId ?? this.categoryId,
    currentStock: currentStock ?? this.currentStock,
    leadTimeDays: leadTimeDays ?? this.leadTimeDays,
    warehouseLoc: warehouseLoc ?? this.warehouseLoc,
    seoTitle: seoTitle ?? this.seoTitle,
    seoDescription: seoDescription ?? this.seoDescription,
    searchKeywords: searchKeywords ?? this.searchKeywords,
    slug: slug ?? this.slug,
    imageUrl: imageUrl ?? this.imageUrl,
    mediaUrls: mediaUrls.present ? mediaUrls.value : this.mediaUrls,
    aspectRatio: aspectRatio ?? this.aspectRatio,
    availableColors: availableColors.present
        ? availableColors.value
        : this.availableColors,
    availableSizes: availableSizes.present
        ? availableSizes.value
        : this.availableSizes,
    availableMaterials: availableMaterials.present
        ? availableMaterials.value
        : this.availableMaterials,
    supportJson: supportJson.present ? supportJson.value : this.supportJson,
    tradingTermsJson: tradingTermsJson.present
        ? tradingTermsJson.value
        : this.tradingTermsJson,
    isDirty: isDirty ?? this.isDirty,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
  );
  ProductEntry copyWithCompanion(ProductsTableCompanion data) {
    return ProductEntry(
      id: data.id.present ? data.id.value : this.id,
      sku: data.sku.present ? data.sku.value : this.sku,
      name: data.name.present ? data.name.value : this.name,
      brand: data.brand.present ? data.brand.value : this.brand,
      srp: data.srp.present ? data.srp.value : this.srp,
      priceTiers: data.priceTiers.present
          ? data.priceTiers.value
          : this.priceTiers,
      hsCode: data.hsCode.present ? data.hsCode.value : this.hsCode,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      volumeCbm: data.volumeCbm.present ? data.volumeCbm.value : this.volumeCbm,
      originCountry: data.originCountry.present
          ? data.originCountry.value
          : this.originCountry,
      unbsNumber: data.unbsNumber.present
          ? data.unbsNumber.value
          : this.unbsNumber,
      denier: data.denier.present ? data.denier.value : this.denier,
      material: data.material.present ? data.material.value : this.material,
      supplierId: data.supplierId.present
          ? data.supplierId.value
          : this.supplierId,
      supplierJson: data.supplierJson.present
          ? data.supplierJson.value
          : this.supplierJson,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      currentStock: data.currentStock.present
          ? data.currentStock.value
          : this.currentStock,
      leadTimeDays: data.leadTimeDays.present
          ? data.leadTimeDays.value
          : this.leadTimeDays,
      warehouseLoc: data.warehouseLoc.present
          ? data.warehouseLoc.value
          : this.warehouseLoc,
      seoTitle: data.seoTitle.present ? data.seoTitle.value : this.seoTitle,
      seoDescription: data.seoDescription.present
          ? data.seoDescription.value
          : this.seoDescription,
      searchKeywords: data.searchKeywords.present
          ? data.searchKeywords.value
          : this.searchKeywords,
      slug: data.slug.present ? data.slug.value : this.slug,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      mediaUrls: data.mediaUrls.present ? data.mediaUrls.value : this.mediaUrls,
      aspectRatio: data.aspectRatio.present
          ? data.aspectRatio.value
          : this.aspectRatio,
      availableColors: data.availableColors.present
          ? data.availableColors.value
          : this.availableColors,
      availableSizes: data.availableSizes.present
          ? data.availableSizes.value
          : this.availableSizes,
      availableMaterials: data.availableMaterials.present
          ? data.availableMaterials.value
          : this.availableMaterials,
      supportJson: data.supportJson.present
          ? data.supportJson.value
          : this.supportJson,
      tradingTermsJson: data.tradingTermsJson.present
          ? data.tradingTermsJson.value
          : this.tradingTermsJson,
      isDirty: data.isDirty.present ? data.isDirty.value : this.isDirty,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductEntry(')
          ..write('id: $id, ')
          ..write('sku: $sku, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('srp: $srp, ')
          ..write('priceTiers: $priceTiers, ')
          ..write('hsCode: $hsCode, ')
          ..write('weightKg: $weightKg, ')
          ..write('volumeCbm: $volumeCbm, ')
          ..write('originCountry: $originCountry, ')
          ..write('unbsNumber: $unbsNumber, ')
          ..write('denier: $denier, ')
          ..write('material: $material, ')
          ..write('supplierId: $supplierId, ')
          ..write('supplierJson: $supplierJson, ')
          ..write('categoryId: $categoryId, ')
          ..write('currentStock: $currentStock, ')
          ..write('leadTimeDays: $leadTimeDays, ')
          ..write('warehouseLoc: $warehouseLoc, ')
          ..write('seoTitle: $seoTitle, ')
          ..write('seoDescription: $seoDescription, ')
          ..write('searchKeywords: $searchKeywords, ')
          ..write('slug: $slug, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('mediaUrls: $mediaUrls, ')
          ..write('aspectRatio: $aspectRatio, ')
          ..write('availableColors: $availableColors, ')
          ..write('availableSizes: $availableSizes, ')
          ..write('availableMaterials: $availableMaterials, ')
          ..write('supportJson: $supportJson, ')
          ..write('tradingTermsJson: $tradingTermsJson, ')
          ..write('isDirty: $isDirty, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    sku,
    name,
    brand,
    srp,
    priceTiers,
    hsCode,
    weightKg,
    volumeCbm,
    originCountry,
    unbsNumber,
    denier,
    material,
    supplierId,
    supplierJson,
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
    supportJson,
    tradingTermsJson,
    isDirty,
    lastSyncedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductEntry &&
          other.id == this.id &&
          other.sku == this.sku &&
          other.name == this.name &&
          other.brand == this.brand &&
          other.srp == this.srp &&
          other.priceTiers == this.priceTiers &&
          other.hsCode == this.hsCode &&
          other.weightKg == this.weightKg &&
          other.volumeCbm == this.volumeCbm &&
          other.originCountry == this.originCountry &&
          other.unbsNumber == this.unbsNumber &&
          other.denier == this.denier &&
          other.material == this.material &&
          other.supplierId == this.supplierId &&
          other.supplierJson == this.supplierJson &&
          other.categoryId == this.categoryId &&
          other.currentStock == this.currentStock &&
          other.leadTimeDays == this.leadTimeDays &&
          other.warehouseLoc == this.warehouseLoc &&
          other.seoTitle == this.seoTitle &&
          other.seoDescription == this.seoDescription &&
          other.searchKeywords == this.searchKeywords &&
          other.slug == this.slug &&
          other.imageUrl == this.imageUrl &&
          other.mediaUrls == this.mediaUrls &&
          other.aspectRatio == this.aspectRatio &&
          other.availableColors == this.availableColors &&
          other.availableSizes == this.availableSizes &&
          other.availableMaterials == this.availableMaterials &&
          other.supportJson == this.supportJson &&
          other.tradingTermsJson == this.tradingTermsJson &&
          other.isDirty == this.isDirty &&
          other.lastSyncedAt == this.lastSyncedAt);
}

class ProductsTableCompanion extends UpdateCompanion<ProductEntry> {
  final Value<String> id;
  final Value<String> sku;
  final Value<String> name;
  final Value<String> brand;
  final Value<double> srp;
  final Value<String> priceTiers;
  final Value<String> hsCode;
  final Value<double> weightKg;
  final Value<double> volumeCbm;
  final Value<String> originCountry;
  final Value<String> unbsNumber;
  final Value<String> denier;
  final Value<String> material;
  final Value<String> supplierId;
  final Value<String> supplierJson;
  final Value<String> categoryId;
  final Value<int> currentStock;
  final Value<int> leadTimeDays;
  final Value<String> warehouseLoc;
  final Value<String> seoTitle;
  final Value<String> seoDescription;
  final Value<String> searchKeywords;
  final Value<String> slug;
  final Value<String> imageUrl;
  final Value<String?> mediaUrls;
  final Value<double> aspectRatio;
  final Value<String?> availableColors;
  final Value<String?> availableSizes;
  final Value<String?> availableMaterials;
  final Value<String?> supportJson;
  final Value<String?> tradingTermsJson;
  final Value<bool> isDirty;
  final Value<DateTime?> lastSyncedAt;
  final Value<int> rowid;
  const ProductsTableCompanion({
    this.id = const Value.absent(),
    this.sku = const Value.absent(),
    this.name = const Value.absent(),
    this.brand = const Value.absent(),
    this.srp = const Value.absent(),
    this.priceTiers = const Value.absent(),
    this.hsCode = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.volumeCbm = const Value.absent(),
    this.originCountry = const Value.absent(),
    this.unbsNumber = const Value.absent(),
    this.denier = const Value.absent(),
    this.material = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.supplierJson = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.currentStock = const Value.absent(),
    this.leadTimeDays = const Value.absent(),
    this.warehouseLoc = const Value.absent(),
    this.seoTitle = const Value.absent(),
    this.seoDescription = const Value.absent(),
    this.searchKeywords = const Value.absent(),
    this.slug = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.mediaUrls = const Value.absent(),
    this.aspectRatio = const Value.absent(),
    this.availableColors = const Value.absent(),
    this.availableSizes = const Value.absent(),
    this.availableMaterials = const Value.absent(),
    this.supportJson = const Value.absent(),
    this.tradingTermsJson = const Value.absent(),
    this.isDirty = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductsTableCompanion.insert({
    required String id,
    required String sku,
    required String name,
    required String brand,
    required double srp,
    required String priceTiers,
    required String hsCode,
    required double weightKg,
    required double volumeCbm,
    required String originCountry,
    required String unbsNumber,
    required String denier,
    required String material,
    required String supplierId,
    required String supplierJson,
    required String categoryId,
    required int currentStock,
    required int leadTimeDays,
    required String warehouseLoc,
    required String seoTitle,
    required String seoDescription,
    required String searchKeywords,
    required String slug,
    required String imageUrl,
    this.mediaUrls = const Value.absent(),
    this.aspectRatio = const Value.absent(),
    this.availableColors = const Value.absent(),
    this.availableSizes = const Value.absent(),
    this.availableMaterials = const Value.absent(),
    this.supportJson = const Value.absent(),
    this.tradingTermsJson = const Value.absent(),
    this.isDirty = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sku = Value(sku),
       name = Value(name),
       brand = Value(brand),
       srp = Value(srp),
       priceTiers = Value(priceTiers),
       hsCode = Value(hsCode),
       weightKg = Value(weightKg),
       volumeCbm = Value(volumeCbm),
       originCountry = Value(originCountry),
       unbsNumber = Value(unbsNumber),
       denier = Value(denier),
       material = Value(material),
       supplierId = Value(supplierId),
       supplierJson = Value(supplierJson),
       categoryId = Value(categoryId),
       currentStock = Value(currentStock),
       leadTimeDays = Value(leadTimeDays),
       warehouseLoc = Value(warehouseLoc),
       seoTitle = Value(seoTitle),
       seoDescription = Value(seoDescription),
       searchKeywords = Value(searchKeywords),
       slug = Value(slug),
       imageUrl = Value(imageUrl);
  static Insertable<ProductEntry> custom({
    Expression<String>? id,
    Expression<String>? sku,
    Expression<String>? name,
    Expression<String>? brand,
    Expression<double>? srp,
    Expression<String>? priceTiers,
    Expression<String>? hsCode,
    Expression<double>? weightKg,
    Expression<double>? volumeCbm,
    Expression<String>? originCountry,
    Expression<String>? unbsNumber,
    Expression<String>? denier,
    Expression<String>? material,
    Expression<String>? supplierId,
    Expression<String>? supplierJson,
    Expression<String>? categoryId,
    Expression<int>? currentStock,
    Expression<int>? leadTimeDays,
    Expression<String>? warehouseLoc,
    Expression<String>? seoTitle,
    Expression<String>? seoDescription,
    Expression<String>? searchKeywords,
    Expression<String>? slug,
    Expression<String>? imageUrl,
    Expression<String>? mediaUrls,
    Expression<double>? aspectRatio,
    Expression<String>? availableColors,
    Expression<String>? availableSizes,
    Expression<String>? availableMaterials,
    Expression<String>? supportJson,
    Expression<String>? tradingTermsJson,
    Expression<bool>? isDirty,
    Expression<DateTime>? lastSyncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sku != null) 'sku': sku,
      if (name != null) 'name': name,
      if (brand != null) 'brand': brand,
      if (srp != null) 'srp': srp,
      if (priceTiers != null) 'price_tiers': priceTiers,
      if (hsCode != null) 'hs_code': hsCode,
      if (weightKg != null) 'weight_kg': weightKg,
      if (volumeCbm != null) 'volume_cbm': volumeCbm,
      if (originCountry != null) 'origin_country': originCountry,
      if (unbsNumber != null) 'unbs_number': unbsNumber,
      if (denier != null) 'denier': denier,
      if (material != null) 'material': material,
      if (supplierId != null) 'supplier_id': supplierId,
      if (supplierJson != null) 'supplier_json': supplierJson,
      if (categoryId != null) 'category_id': categoryId,
      if (currentStock != null) 'current_stock': currentStock,
      if (leadTimeDays != null) 'lead_time_days': leadTimeDays,
      if (warehouseLoc != null) 'warehouse_loc': warehouseLoc,
      if (seoTitle != null) 'seo_title': seoTitle,
      if (seoDescription != null) 'seo_description': seoDescription,
      if (searchKeywords != null) 'search_keywords': searchKeywords,
      if (slug != null) 'slug': slug,
      if (imageUrl != null) 'image_url': imageUrl,
      if (mediaUrls != null) 'media_urls': mediaUrls,
      if (aspectRatio != null) 'aspect_ratio': aspectRatio,
      if (availableColors != null) 'available_colors': availableColors,
      if (availableSizes != null) 'available_sizes': availableSizes,
      if (availableMaterials != null) 'available_materials': availableMaterials,
      if (supportJson != null) 'support_json': supportJson,
      if (tradingTermsJson != null) 'trading_terms_json': tradingTermsJson,
      if (isDirty != null) 'is_dirty': isDirty,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? sku,
    Value<String>? name,
    Value<String>? brand,
    Value<double>? srp,
    Value<String>? priceTiers,
    Value<String>? hsCode,
    Value<double>? weightKg,
    Value<double>? volumeCbm,
    Value<String>? originCountry,
    Value<String>? unbsNumber,
    Value<String>? denier,
    Value<String>? material,
    Value<String>? supplierId,
    Value<String>? supplierJson,
    Value<String>? categoryId,
    Value<int>? currentStock,
    Value<int>? leadTimeDays,
    Value<String>? warehouseLoc,
    Value<String>? seoTitle,
    Value<String>? seoDescription,
    Value<String>? searchKeywords,
    Value<String>? slug,
    Value<String>? imageUrl,
    Value<String?>? mediaUrls,
    Value<double>? aspectRatio,
    Value<String?>? availableColors,
    Value<String?>? availableSizes,
    Value<String?>? availableMaterials,
    Value<String?>? supportJson,
    Value<String?>? tradingTermsJson,
    Value<bool>? isDirty,
    Value<DateTime?>? lastSyncedAt,
    Value<int>? rowid,
  }) {
    return ProductsTableCompanion(
      id: id ?? this.id,
      sku: sku ?? this.sku,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      srp: srp ?? this.srp,
      priceTiers: priceTiers ?? this.priceTiers,
      hsCode: hsCode ?? this.hsCode,
      weightKg: weightKg ?? this.weightKg,
      volumeCbm: volumeCbm ?? this.volumeCbm,
      originCountry: originCountry ?? this.originCountry,
      unbsNumber: unbsNumber ?? this.unbsNumber,
      denier: denier ?? this.denier,
      material: material ?? this.material,
      supplierId: supplierId ?? this.supplierId,
      supplierJson: supplierJson ?? this.supplierJson,
      categoryId: categoryId ?? this.categoryId,
      currentStock: currentStock ?? this.currentStock,
      leadTimeDays: leadTimeDays ?? this.leadTimeDays,
      warehouseLoc: warehouseLoc ?? this.warehouseLoc,
      seoTitle: seoTitle ?? this.seoTitle,
      seoDescription: seoDescription ?? this.seoDescription,
      searchKeywords: searchKeywords ?? this.searchKeywords,
      slug: slug ?? this.slug,
      imageUrl: imageUrl ?? this.imageUrl,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      availableColors: availableColors ?? this.availableColors,
      availableSizes: availableSizes ?? this.availableSizes,
      availableMaterials: availableMaterials ?? this.availableMaterials,
      supportJson: supportJson ?? this.supportJson,
      tradingTermsJson: tradingTermsJson ?? this.tradingTermsJson,
      isDirty: isDirty ?? this.isDirty,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sku.present) {
      map['sku'] = Variable<String>(sku.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (srp.present) {
      map['srp'] = Variable<double>(srp.value);
    }
    if (priceTiers.present) {
      map['price_tiers'] = Variable<String>(priceTiers.value);
    }
    if (hsCode.present) {
      map['hs_code'] = Variable<String>(hsCode.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (volumeCbm.present) {
      map['volume_cbm'] = Variable<double>(volumeCbm.value);
    }
    if (originCountry.present) {
      map['origin_country'] = Variable<String>(originCountry.value);
    }
    if (unbsNumber.present) {
      map['unbs_number'] = Variable<String>(unbsNumber.value);
    }
    if (denier.present) {
      map['denier'] = Variable<String>(denier.value);
    }
    if (material.present) {
      map['material'] = Variable<String>(material.value);
    }
    if (supplierId.present) {
      map['supplier_id'] = Variable<String>(supplierId.value);
    }
    if (supplierJson.present) {
      map['supplier_json'] = Variable<String>(supplierJson.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (currentStock.present) {
      map['current_stock'] = Variable<int>(currentStock.value);
    }
    if (leadTimeDays.present) {
      map['lead_time_days'] = Variable<int>(leadTimeDays.value);
    }
    if (warehouseLoc.present) {
      map['warehouse_loc'] = Variable<String>(warehouseLoc.value);
    }
    if (seoTitle.present) {
      map['seo_title'] = Variable<String>(seoTitle.value);
    }
    if (seoDescription.present) {
      map['seo_description'] = Variable<String>(seoDescription.value);
    }
    if (searchKeywords.present) {
      map['search_keywords'] = Variable<String>(searchKeywords.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (mediaUrls.present) {
      map['media_urls'] = Variable<String>(mediaUrls.value);
    }
    if (aspectRatio.present) {
      map['aspect_ratio'] = Variable<double>(aspectRatio.value);
    }
    if (availableColors.present) {
      map['available_colors'] = Variable<String>(availableColors.value);
    }
    if (availableSizes.present) {
      map['available_sizes'] = Variable<String>(availableSizes.value);
    }
    if (availableMaterials.present) {
      map['available_materials'] = Variable<String>(availableMaterials.value);
    }
    if (supportJson.present) {
      map['support_json'] = Variable<String>(supportJson.value);
    }
    if (tradingTermsJson.present) {
      map['trading_terms_json'] = Variable<String>(tradingTermsJson.value);
    }
    if (isDirty.present) {
      map['is_dirty'] = Variable<bool>(isDirty.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsTableCompanion(')
          ..write('id: $id, ')
          ..write('sku: $sku, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('srp: $srp, ')
          ..write('priceTiers: $priceTiers, ')
          ..write('hsCode: $hsCode, ')
          ..write('weightKg: $weightKg, ')
          ..write('volumeCbm: $volumeCbm, ')
          ..write('originCountry: $originCountry, ')
          ..write('unbsNumber: $unbsNumber, ')
          ..write('denier: $denier, ')
          ..write('material: $material, ')
          ..write('supplierId: $supplierId, ')
          ..write('supplierJson: $supplierJson, ')
          ..write('categoryId: $categoryId, ')
          ..write('currentStock: $currentStock, ')
          ..write('leadTimeDays: $leadTimeDays, ')
          ..write('warehouseLoc: $warehouseLoc, ')
          ..write('seoTitle: $seoTitle, ')
          ..write('seoDescription: $seoDescription, ')
          ..write('searchKeywords: $searchKeywords, ')
          ..write('slug: $slug, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('mediaUrls: $mediaUrls, ')
          ..write('aspectRatio: $aspectRatio, ')
          ..write('availableColors: $availableColors, ')
          ..write('availableSizes: $availableSizes, ')
          ..write('availableMaterials: $availableMaterials, ')
          ..write('supportJson: $supportJson, ')
          ..write('tradingTermsJson: $tradingTermsJson, ')
          ..write('isDirty: $isDirty, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTableTable extends CategoriesTable
    with TableInfo<$CategoriesTableTable, CategoryEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: Constant(0),
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _itemCountMeta = const VerificationMeta(
    'itemCount',
  );
  @override
  late final GeneratedColumn<int> itemCount = GeneratedColumn<int>(
    'item_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: Constant(0),
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: Constant(0),
  );
  static const VerificationMeta _usageCountMeta = const VerificationMeta(
    'usageCount',
  );
  @override
  late final GeneratedColumn<int> usageCount = GeneratedColumn<int>(
    'usage_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: Constant(0),
  );
  static const VerificationMeta _isDirtyMeta = const VerificationMeta(
    'isDirty',
  );
  @override
  late final GeneratedColumn<bool> isDirty = GeneratedColumn<bool>(
    'is_dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_dirty" IN (0, 1))',
    ),
    defaultValue: Constant(false),
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    parentId,
    level,
    imageUrl,
    itemCount,
    priority,
    usageCount,
    isDirty,
    lastSyncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('item_count')) {
      context.handle(
        _itemCountMeta,
        itemCount.isAcceptableOrUnknown(data['item_count']!, _itemCountMeta),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('usage_count')) {
      context.handle(
        _usageCountMeta,
        usageCount.isAcceptableOrUnknown(data['usage_count']!, _usageCountMeta),
      );
    }
    if (data.containsKey('is_dirty')) {
      context.handle(
        _isDirtyMeta,
        isDirty.isAcceptableOrUnknown(data['is_dirty']!, _isDirtyMeta),
      );
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      ),
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      itemCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}item_count'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      )!,
      usageCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}usage_count'],
      )!,
      isDirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_dirty'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      ),
    );
  }

  @override
  $CategoriesTableTable createAlias(String alias) {
    return $CategoriesTableTable(attachedDatabase, alias);
  }
}

class CategoryEntry extends DataClass implements Insertable<CategoryEntry> {
  final String id;
  final String name;
  final String? parentId;
  final int level;
  final String? imageUrl;
  final int itemCount;
  final int priority;
  final int usageCount;
  final bool isDirty;
  final DateTime? lastSyncedAt;
  const CategoryEntry({
    required this.id,
    required this.name,
    this.parentId,
    required this.level,
    this.imageUrl,
    required this.itemCount,
    required this.priority,
    required this.usageCount,
    required this.isDirty,
    this.lastSyncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    map['level'] = Variable<int>(level);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    map['item_count'] = Variable<int>(itemCount);
    map['priority'] = Variable<int>(priority);
    map['usage_count'] = Variable<int>(usageCount);
    map['is_dirty'] = Variable<bool>(isDirty);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    return map;
  }

  CategoriesTableCompanion toCompanion(bool nullToAbsent) {
    return CategoriesTableCompanion(
      id: Value(id),
      name: Value(name),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      level: Value(level),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      itemCount: Value(itemCount),
      priority: Value(priority),
      usageCount: Value(usageCount),
      isDirty: Value(isDirty),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
    );
  }

  factory CategoryEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryEntry(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      level: serializer.fromJson<int>(json['level']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      itemCount: serializer.fromJson<int>(json['itemCount']),
      priority: serializer.fromJson<int>(json['priority']),
      usageCount: serializer.fromJson<int>(json['usageCount']),
      isDirty: serializer.fromJson<bool>(json['isDirty']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'parentId': serializer.toJson<String?>(parentId),
      'level': serializer.toJson<int>(level),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'itemCount': serializer.toJson<int>(itemCount),
      'priority': serializer.toJson<int>(priority),
      'usageCount': serializer.toJson<int>(usageCount),
      'isDirty': serializer.toJson<bool>(isDirty),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
    };
  }

  CategoryEntry copyWith({
    String? id,
    String? name,
    Value<String?> parentId = const Value.absent(),
    int? level,
    Value<String?> imageUrl = const Value.absent(),
    int? itemCount,
    int? priority,
    int? usageCount,
    bool? isDirty,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
  }) => CategoryEntry(
    id: id ?? this.id,
    name: name ?? this.name,
    parentId: parentId.present ? parentId.value : this.parentId,
    level: level ?? this.level,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    itemCount: itemCount ?? this.itemCount,
    priority: priority ?? this.priority,
    usageCount: usageCount ?? this.usageCount,
    isDirty: isDirty ?? this.isDirty,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
  );
  CategoryEntry copyWithCompanion(CategoriesTableCompanion data) {
    return CategoryEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      level: data.level.present ? data.level.value : this.level,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      itemCount: data.itemCount.present ? data.itemCount.value : this.itemCount,
      priority: data.priority.present ? data.priority.value : this.priority,
      usageCount: data.usageCount.present
          ? data.usageCount.value
          : this.usageCount,
      isDirty: data.isDirty.present ? data.isDirty.value : this.isDirty,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('level: $level, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('itemCount: $itemCount, ')
          ..write('priority: $priority, ')
          ..write('usageCount: $usageCount, ')
          ..write('isDirty: $isDirty, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    parentId,
    level,
    imageUrl,
    itemCount,
    priority,
    usageCount,
    isDirty,
    lastSyncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.parentId == this.parentId &&
          other.level == this.level &&
          other.imageUrl == this.imageUrl &&
          other.itemCount == this.itemCount &&
          other.priority == this.priority &&
          other.usageCount == this.usageCount &&
          other.isDirty == this.isDirty &&
          other.lastSyncedAt == this.lastSyncedAt);
}

class CategoriesTableCompanion extends UpdateCompanion<CategoryEntry> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> parentId;
  final Value<int> level;
  final Value<String?> imageUrl;
  final Value<int> itemCount;
  final Value<int> priority;
  final Value<int> usageCount;
  final Value<bool> isDirty;
  final Value<DateTime?> lastSyncedAt;
  final Value<int> rowid;
  const CategoriesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.parentId = const Value.absent(),
    this.level = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.itemCount = const Value.absent(),
    this.priority = const Value.absent(),
    this.usageCount = const Value.absent(),
    this.isDirty = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesTableCompanion.insert({
    required String id,
    required String name,
    this.parentId = const Value.absent(),
    this.level = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.itemCount = const Value.absent(),
    this.priority = const Value.absent(),
    this.usageCount = const Value.absent(),
    this.isDirty = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<CategoryEntry> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? parentId,
    Expression<int>? level,
    Expression<String>? imageUrl,
    Expression<int>? itemCount,
    Expression<int>? priority,
    Expression<int>? usageCount,
    Expression<bool>? isDirty,
    Expression<DateTime>? lastSyncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (parentId != null) 'parent_id': parentId,
      if (level != null) 'level': level,
      if (imageUrl != null) 'image_url': imageUrl,
      if (itemCount != null) 'item_count': itemCount,
      if (priority != null) 'priority': priority,
      if (usageCount != null) 'usage_count': usageCount,
      if (isDirty != null) 'is_dirty': isDirty,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? parentId,
    Value<int>? level,
    Value<String?>? imageUrl,
    Value<int>? itemCount,
    Value<int>? priority,
    Value<int>? usageCount,
    Value<bool>? isDirty,
    Value<DateTime?>? lastSyncedAt,
    Value<int>? rowid,
  }) {
    return CategoriesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      parentId: parentId ?? this.parentId,
      level: level ?? this.level,
      imageUrl: imageUrl ?? this.imageUrl,
      itemCount: itemCount ?? this.itemCount,
      priority: priority ?? this.priority,
      usageCount: usageCount ?? this.usageCount,
      isDirty: isDirty ?? this.isDirty,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (itemCount.present) {
      map['item_count'] = Variable<int>(itemCount.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (usageCount.present) {
      map['usage_count'] = Variable<int>(usageCount.value);
    }
    if (isDirty.present) {
      map['is_dirty'] = Variable<bool>(isDirty.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('parentId: $parentId, ')
          ..write('level: $level, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('itemCount: $itemCount, ')
          ..write('priority: $priority, ')
          ..write('usageCount: $usageCount, ')
          ..write('isDirty: $isDirty, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PriceTiersTableTable extends PriceTiersTable
    with TableInfo<$PriceTiersTableTable, PriceTierEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PriceTiersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, productId, quantity, price];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'price_tiers_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PriceTierEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PriceTierEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PriceTierEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
    );
  }

  @override
  $PriceTiersTableTable createAlias(String alias) {
    return $PriceTiersTableTable(attachedDatabase, alias);
  }
}

class PriceTierEntry extends DataClass implements Insertable<PriceTierEntry> {
  final int id;
  final String productId;
  final int quantity;
  final double price;
  const PriceTierEntry({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.price,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['product_id'] = Variable<String>(productId);
    map['quantity'] = Variable<int>(quantity);
    map['price'] = Variable<double>(price);
    return map;
  }

  PriceTiersTableCompanion toCompanion(bool nullToAbsent) {
    return PriceTiersTableCompanion(
      id: Value(id),
      productId: Value(productId),
      quantity: Value(quantity),
      price: Value(price),
    );
  }

  factory PriceTierEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PriceTierEntry(
      id: serializer.fromJson<int>(json['id']),
      productId: serializer.fromJson<String>(json['productId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      price: serializer.fromJson<double>(json['price']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'productId': serializer.toJson<String>(productId),
      'quantity': serializer.toJson<int>(quantity),
      'price': serializer.toJson<double>(price),
    };
  }

  PriceTierEntry copyWith({
    int? id,
    String? productId,
    int? quantity,
    double? price,
  }) => PriceTierEntry(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    quantity: quantity ?? this.quantity,
    price: price ?? this.price,
  );
  PriceTierEntry copyWithCompanion(PriceTiersTableCompanion data) {
    return PriceTierEntry(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      price: data.price.present ? data.price.value : this.price,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PriceTierEntry(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('price: $price')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, productId, quantity, price);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PriceTierEntry &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.quantity == this.quantity &&
          other.price == this.price);
}

class PriceTiersTableCompanion extends UpdateCompanion<PriceTierEntry> {
  final Value<int> id;
  final Value<String> productId;
  final Value<int> quantity;
  final Value<double> price;
  const PriceTiersTableCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.price = const Value.absent(),
  });
  PriceTiersTableCompanion.insert({
    this.id = const Value.absent(),
    required String productId,
    required int quantity,
    required double price,
  }) : productId = Value(productId),
       quantity = Value(quantity),
       price = Value(price);
  static Insertable<PriceTierEntry> custom({
    Expression<int>? id,
    Expression<String>? productId,
    Expression<int>? quantity,
    Expression<double>? price,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (quantity != null) 'quantity': quantity,
      if (price != null) 'price': price,
    });
  }

  PriceTiersTableCompanion copyWith({
    Value<int>? id,
    Value<String>? productId,
    Value<int>? quantity,
    Value<double>? price,
  }) {
    return PriceTiersTableCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PriceTiersTableCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('quantity: $quantity, ')
          ..write('price: $price')
          ..write(')'))
        .toString();
  }
}

class $BusinessTableTable extends BusinessTable
    with TableInfo<$BusinessTableTable, BusinessEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BusinessTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _legalNameMeta = const VerificationMeta(
    'legalName',
  );
  @override
  late final GeneratedColumn<String> legalName = GeneratedColumn<String>(
    'legal_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneNumberMeta = const VerificationMeta(
    'phoneNumber',
  );
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
    'phone_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _regionMeta = const VerificationMeta('region');
  @override
  late final GeneratedColumn<String> region = GeneratedColumn<String>(
    'region',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _physicalAddressMeta = const VerificationMeta(
    'physicalAddress',
  );
  @override
  late final GeneratedColumn<String> physicalAddress = GeneratedColumn<String>(
    'physical_address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isDirtyMeta = const VerificationMeta(
    'isDirty',
  );
  @override
  late final GeneratedColumn<bool> isDirty = GeneratedColumn<bool>(
    'is_dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_dirty" IN (0, 1))',
    ),
    defaultValue: Constant(false),
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    legalName,
    phoneNumber,
    latitude,
    longitude,
    region,
    city,
    physicalAddress,
    updatedAt,
    isDirty,
    lastSyncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'business_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<BusinessEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('legal_name')) {
      context.handle(
        _legalNameMeta,
        legalName.isAcceptableOrUnknown(data['legal_name']!, _legalNameMeta),
      );
    } else if (isInserting) {
      context.missing(_legalNameMeta);
    }
    if (data.containsKey('phone_number')) {
      context.handle(
        _phoneNumberMeta,
        phoneNumber.isAcceptableOrUnknown(
          data['phone_number']!,
          _phoneNumberMeta,
        ),
      );
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    }
    if (data.containsKey('region')) {
      context.handle(
        _regionMeta,
        region.isAcceptableOrUnknown(data['region']!, _regionMeta),
      );
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    }
    if (data.containsKey('physical_address')) {
      context.handle(
        _physicalAddressMeta,
        physicalAddress.isAcceptableOrUnknown(
          data['physical_address']!,
          _physicalAddressMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('is_dirty')) {
      context.handle(
        _isDirtyMeta,
        isDirty.isAcceptableOrUnknown(data['is_dirty']!, _isDirtyMeta),
      );
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BusinessEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BusinessEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      legalName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}legal_name'],
      )!,
      phoneNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_number'],
      ),
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      ),
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      ),
      region: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}region'],
      ),
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      ),
      physicalAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}physical_address'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
      isDirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_dirty'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      ),
    );
  }

  @override
  $BusinessTableTable createAlias(String alias) {
    return $BusinessTableTable(attachedDatabase, alias);
  }
}

class BusinessEntry extends DataClass implements Insertable<BusinessEntry> {
  final String id;
  final String legalName;
  final String? phoneNumber;
  final double? latitude;
  final double? longitude;
  final String? region;
  final String? city;
  final String? physicalAddress;
  final DateTime? updatedAt;
  final bool isDirty;
  final DateTime? lastSyncedAt;
  const BusinessEntry({
    required this.id,
    required this.legalName,
    this.phoneNumber,
    this.latitude,
    this.longitude,
    this.region,
    this.city,
    this.physicalAddress,
    this.updatedAt,
    required this.isDirty,
    this.lastSyncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['legal_name'] = Variable<String>(legalName);
    if (!nullToAbsent || phoneNumber != null) {
      map['phone_number'] = Variable<String>(phoneNumber);
    }
    if (!nullToAbsent || latitude != null) {
      map['latitude'] = Variable<double>(latitude);
    }
    if (!nullToAbsent || longitude != null) {
      map['longitude'] = Variable<double>(longitude);
    }
    if (!nullToAbsent || region != null) {
      map['region'] = Variable<String>(region);
    }
    if (!nullToAbsent || city != null) {
      map['city'] = Variable<String>(city);
    }
    if (!nullToAbsent || physicalAddress != null) {
      map['physical_address'] = Variable<String>(physicalAddress);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    map['is_dirty'] = Variable<bool>(isDirty);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    return map;
  }

  BusinessTableCompanion toCompanion(bool nullToAbsent) {
    return BusinessTableCompanion(
      id: Value(id),
      legalName: Value(legalName),
      phoneNumber: phoneNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(phoneNumber),
      latitude: latitude == null && nullToAbsent
          ? const Value.absent()
          : Value(latitude),
      longitude: longitude == null && nullToAbsent
          ? const Value.absent()
          : Value(longitude),
      region: region == null && nullToAbsent
          ? const Value.absent()
          : Value(region),
      city: city == null && nullToAbsent ? const Value.absent() : Value(city),
      physicalAddress: physicalAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(physicalAddress),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
      isDirty: Value(isDirty),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
    );
  }

  factory BusinessEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BusinessEntry(
      id: serializer.fromJson<String>(json['id']),
      legalName: serializer.fromJson<String>(json['legalName']),
      phoneNumber: serializer.fromJson<String?>(json['phoneNumber']),
      latitude: serializer.fromJson<double?>(json['latitude']),
      longitude: serializer.fromJson<double?>(json['longitude']),
      region: serializer.fromJson<String?>(json['region']),
      city: serializer.fromJson<String?>(json['city']),
      physicalAddress: serializer.fromJson<String?>(json['physicalAddress']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
      isDirty: serializer.fromJson<bool>(json['isDirty']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'legalName': serializer.toJson<String>(legalName),
      'phoneNumber': serializer.toJson<String?>(phoneNumber),
      'latitude': serializer.toJson<double?>(latitude),
      'longitude': serializer.toJson<double?>(longitude),
      'region': serializer.toJson<String?>(region),
      'city': serializer.toJson<String?>(city),
      'physicalAddress': serializer.toJson<String?>(physicalAddress),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
      'isDirty': serializer.toJson<bool>(isDirty),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
    };
  }

  BusinessEntry copyWith({
    String? id,
    String? legalName,
    Value<String?> phoneNumber = const Value.absent(),
    Value<double?> latitude = const Value.absent(),
    Value<double?> longitude = const Value.absent(),
    Value<String?> region = const Value.absent(),
    Value<String?> city = const Value.absent(),
    Value<String?> physicalAddress = const Value.absent(),
    Value<DateTime?> updatedAt = const Value.absent(),
    bool? isDirty,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
  }) => BusinessEntry(
    id: id ?? this.id,
    legalName: legalName ?? this.legalName,
    phoneNumber: phoneNumber.present ? phoneNumber.value : this.phoneNumber,
    latitude: latitude.present ? latitude.value : this.latitude,
    longitude: longitude.present ? longitude.value : this.longitude,
    region: region.present ? region.value : this.region,
    city: city.present ? city.value : this.city,
    physicalAddress: physicalAddress.present
        ? physicalAddress.value
        : this.physicalAddress,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
    isDirty: isDirty ?? this.isDirty,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
  );
  BusinessEntry copyWithCompanion(BusinessTableCompanion data) {
    return BusinessEntry(
      id: data.id.present ? data.id.value : this.id,
      legalName: data.legalName.present ? data.legalName.value : this.legalName,
      phoneNumber: data.phoneNumber.present
          ? data.phoneNumber.value
          : this.phoneNumber,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      region: data.region.present ? data.region.value : this.region,
      city: data.city.present ? data.city.value : this.city,
      physicalAddress: data.physicalAddress.present
          ? data.physicalAddress.value
          : this.physicalAddress,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isDirty: data.isDirty.present ? data.isDirty.value : this.isDirty,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BusinessEntry(')
          ..write('id: $id, ')
          ..write('legalName: $legalName, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('region: $region, ')
          ..write('city: $city, ')
          ..write('physicalAddress: $physicalAddress, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDirty: $isDirty, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    legalName,
    phoneNumber,
    latitude,
    longitude,
    region,
    city,
    physicalAddress,
    updatedAt,
    isDirty,
    lastSyncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BusinessEntry &&
          other.id == this.id &&
          other.legalName == this.legalName &&
          other.phoneNumber == this.phoneNumber &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.region == this.region &&
          other.city == this.city &&
          other.physicalAddress == this.physicalAddress &&
          other.updatedAt == this.updatedAt &&
          other.isDirty == this.isDirty &&
          other.lastSyncedAt == this.lastSyncedAt);
}

class BusinessTableCompanion extends UpdateCompanion<BusinessEntry> {
  final Value<String> id;
  final Value<String> legalName;
  final Value<String?> phoneNumber;
  final Value<double?> latitude;
  final Value<double?> longitude;
  final Value<String?> region;
  final Value<String?> city;
  final Value<String?> physicalAddress;
  final Value<DateTime?> updatedAt;
  final Value<bool> isDirty;
  final Value<DateTime?> lastSyncedAt;
  final Value<int> rowid;
  const BusinessTableCompanion({
    this.id = const Value.absent(),
    this.legalName = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.region = const Value.absent(),
    this.city = const Value.absent(),
    this.physicalAddress = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isDirty = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BusinessTableCompanion.insert({
    required String id,
    required String legalName,
    this.phoneNumber = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.region = const Value.absent(),
    this.city = const Value.absent(),
    this.physicalAddress = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isDirty = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       legalName = Value(legalName);
  static Insertable<BusinessEntry> custom({
    Expression<String>? id,
    Expression<String>? legalName,
    Expression<String>? phoneNumber,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? region,
    Expression<String>? city,
    Expression<String>? physicalAddress,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isDirty,
    Expression<DateTime>? lastSyncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (legalName != null) 'legal_name': legalName,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (region != null) 'region': region,
      if (city != null) 'city': city,
      if (physicalAddress != null) 'physical_address': physicalAddress,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isDirty != null) 'is_dirty': isDirty,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BusinessTableCompanion copyWith({
    Value<String>? id,
    Value<String>? legalName,
    Value<String?>? phoneNumber,
    Value<double?>? latitude,
    Value<double?>? longitude,
    Value<String?>? region,
    Value<String?>? city,
    Value<String?>? physicalAddress,
    Value<DateTime?>? updatedAt,
    Value<bool>? isDirty,
    Value<DateTime?>? lastSyncedAt,
    Value<int>? rowid,
  }) {
    return BusinessTableCompanion(
      id: id ?? this.id,
      legalName: legalName ?? this.legalName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      region: region ?? this.region,
      city: city ?? this.city,
      physicalAddress: physicalAddress ?? this.physicalAddress,
      updatedAt: updatedAt ?? this.updatedAt,
      isDirty: isDirty ?? this.isDirty,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (legalName.present) {
      map['legal_name'] = Variable<String>(legalName.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (region.present) {
      map['region'] = Variable<String>(region.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (physicalAddress.present) {
      map['physical_address'] = Variable<String>(physicalAddress.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isDirty.present) {
      map['is_dirty'] = Variable<bool>(isDirty.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BusinessTableCompanion(')
          ..write('id: $id, ')
          ..write('legalName: $legalName, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('region: $region, ')
          ..write('city: $city, ')
          ..write('physicalAddress: $physicalAddress, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isDirty: $isDirty, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsersTableTable extends UsersTable
    with TableInfo<$UsersTableTable, UserEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('customer'),
  );
  static const VerificationMeta _profilePicUrlMeta = const VerificationMeta(
    'profilePicUrl',
  );
  @override
  late final GeneratedColumn<String> profilePicUrl = GeneratedColumn<String>(
    'profile_pic_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fullName,
    email,
    role,
    profilePicUrl,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    }
    if (data.containsKey('profile_pic_url')) {
      context.handle(
        _profilePicUrlMeta,
        profilePicUrl.isAcceptableOrUnknown(
          data['profile_pic_url']!,
          _profilePicUrlMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      profilePicUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_pic_url'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UsersTableTable createAlias(String alias) {
    return $UsersTableTable(attachedDatabase, alias);
  }
}

class UserEntry extends DataClass implements Insertable<UserEntry> {
  final String id;
  final String fullName;
  final String? email;
  final String role;
  final String? profilePicUrl;
  final DateTime updatedAt;
  const UserEntry({
    required this.id,
    required this.fullName,
    this.email,
    required this.role,
    this.profilePicUrl,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['full_name'] = Variable<String>(fullName);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    map['role'] = Variable<String>(role);
    if (!nullToAbsent || profilePicUrl != null) {
      map['profile_pic_url'] = Variable<String>(profilePicUrl);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UsersTableCompanion toCompanion(bool nullToAbsent) {
    return UsersTableCompanion(
      id: Value(id),
      fullName: Value(fullName),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      role: Value(role),
      profilePicUrl: profilePicUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(profilePicUrl),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserEntry(
      id: serializer.fromJson<String>(json['id']),
      fullName: serializer.fromJson<String>(json['fullName']),
      email: serializer.fromJson<String?>(json['email']),
      role: serializer.fromJson<String>(json['role']),
      profilePicUrl: serializer.fromJson<String?>(json['profilePicUrl']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'fullName': serializer.toJson<String>(fullName),
      'email': serializer.toJson<String?>(email),
      'role': serializer.toJson<String>(role),
      'profilePicUrl': serializer.toJson<String?>(profilePicUrl),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserEntry copyWith({
    String? id,
    String? fullName,
    Value<String?> email = const Value.absent(),
    String? role,
    Value<String?> profilePicUrl = const Value.absent(),
    DateTime? updatedAt,
  }) => UserEntry(
    id: id ?? this.id,
    fullName: fullName ?? this.fullName,
    email: email.present ? email.value : this.email,
    role: role ?? this.role,
    profilePicUrl: profilePicUrl.present
        ? profilePicUrl.value
        : this.profilePicUrl,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UserEntry copyWithCompanion(UsersTableCompanion data) {
    return UserEntry(
      id: data.id.present ? data.id.value : this.id,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      email: data.email.present ? data.email.value : this.email,
      role: data.role.present ? data.role.value : this.role,
      profilePicUrl: data.profilePicUrl.present
          ? data.profilePicUrl.value
          : this.profilePicUrl,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserEntry(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('email: $email, ')
          ..write('role: $role, ')
          ..write('profilePicUrl: $profilePicUrl, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, fullName, email, role, profilePicUrl, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserEntry &&
          other.id == this.id &&
          other.fullName == this.fullName &&
          other.email == this.email &&
          other.role == this.role &&
          other.profilePicUrl == this.profilePicUrl &&
          other.updatedAt == this.updatedAt);
}

class UsersTableCompanion extends UpdateCompanion<UserEntry> {
  final Value<String> id;
  final Value<String> fullName;
  final Value<String?> email;
  final Value<String> role;
  final Value<String?> profilePicUrl;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const UsersTableCompanion({
    this.id = const Value.absent(),
    this.fullName = const Value.absent(),
    this.email = const Value.absent(),
    this.role = const Value.absent(),
    this.profilePicUrl = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersTableCompanion.insert({
    required String id,
    required String fullName,
    this.email = const Value.absent(),
    this.role = const Value.absent(),
    this.profilePicUrl = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       fullName = Value(fullName);
  static Insertable<UserEntry> custom({
    Expression<String>? id,
    Expression<String>? fullName,
    Expression<String>? email,
    Expression<String>? role,
    Expression<String>? profilePicUrl,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fullName != null) 'full_name': fullName,
      if (email != null) 'email': email,
      if (role != null) 'role': role,
      if (profilePicUrl != null) 'profile_pic_url': profilePicUrl,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersTableCompanion copyWith({
    Value<String>? id,
    Value<String>? fullName,
    Value<String?>? email,
    Value<String>? role,
    Value<String?>? profilePicUrl,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return UsersTableCompanion(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (profilePicUrl.present) {
      map['profile_pic_url'] = Variable<String>(profilePicUrl.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersTableCompanion(')
          ..write('id: $id, ')
          ..write('fullName: $fullName, ')
          ..write('email: $email, ')
          ..write('role: $role, ')
          ..write('profilePicUrl: $profilePicUrl, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BulkOrdersTableTable extends BulkOrdersTable
    with TableInfo<$BulkOrdersTableTable, BulkOrderEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BulkOrdersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _groupNameMeta = const VerificationMeta(
    'groupName',
  );
  @override
  late final GeneratedColumn<String> groupName = GeneratedColumn<String>(
    'group_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _productNameMeta = const VerificationMeta(
    'productName',
  );
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
    'product_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subCategoryMeta = const VerificationMeta(
    'subCategory',
  );
  @override
  late final GeneratedColumn<String> subCategory = GeneratedColumn<String>(
    'sub_category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _availableColorsJsonMeta =
      const VerificationMeta('availableColorsJson');
  @override
  late final GeneratedColumn<String> availableColorsJson =
      GeneratedColumn<String>(
        'available_colors_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _availableSizesJsonMeta =
      const VerificationMeta('availableSizesJson');
  @override
  late final GeneratedColumn<String> availableSizesJson =
      GeneratedColumn<String>(
        'available_sizes_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _variantLabelMeta = const VerificationMeta(
    'variantLabel',
  );
  @override
  late final GeneratedColumn<String> variantLabel = GeneratedColumn<String>(
    'variant_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _configJsonMeta = const VerificationMeta(
    'configJson',
  );
  @override
  late final GeneratedColumn<String> configJson = GeneratedColumn<String>(
    'config_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalUnitsMeta = const VerificationMeta(
    'totalUnits',
  );
  @override
  late final GeneratedColumn<int> totalUnits = GeneratedColumn<int>(
    'total_units',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _srpMeta = const VerificationMeta('srp');
  @override
  late final GeneratedColumn<double> srp = GeneratedColumn<double>(
    'srp',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _priceTiersJsonMeta = const VerificationMeta(
    'priceTiersJson',
  );
  @override
  late final GeneratedColumn<String> priceTiersJson = GeneratedColumn<String>(
    'price_tiers_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _availableMaterialsJsonMeta =
      const VerificationMeta('availableMaterialsJson');
  @override
  late final GeneratedColumn<String> availableMaterialsJson =
      GeneratedColumn<String>(
        'available_materials_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _currentStockMeta = const VerificationMeta(
    'currentStock',
  );
  @override
  late final GeneratedColumn<int> currentStock = GeneratedColumn<int>(
    'current_stock',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _leadTimeDaysMeta = const VerificationMeta(
    'leadTimeDays',
  );
  @override
  late final GeneratedColumn<int> leadTimeDays = GeneratedColumn<int>(
    'lead_time_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _seoDescriptionMeta = const VerificationMeta(
    'seoDescription',
  );
  @override
  late final GeneratedColumn<String> seoDescription = GeneratedColumn<String>(
    'seo_description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tradingTermsJsonMeta = const VerificationMeta(
    'tradingTermsJson',
  );
  @override
  late final GeneratedColumn<String> tradingTermsJson = GeneratedColumn<String>(
    'trading_terms_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    groupName,
    productName,
    brand,
    category,
    subCategory,
    imageUrl,
    availableColorsJson,
    availableSizesJson,
    variantLabel,
    configJson,
    totalUnits,
    srp,
    priceTiersJson,
    availableMaterialsJson,
    currentStock,
    leadTimeDays,
    seoDescription,
    tradingTermsJson,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bulk_orders_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<BulkOrderEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('group_name')) {
      context.handle(
        _groupNameMeta,
        groupName.isAcceptableOrUnknown(data['group_name']!, _groupNameMeta),
      );
    }
    if (data.containsKey('product_name')) {
      context.handle(
        _productNameMeta,
        productName.isAcceptableOrUnknown(
          data['product_name']!,
          _productNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productNameMeta);
    }
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('sub_category')) {
      context.handle(
        _subCategoryMeta,
        subCategory.isAcceptableOrUnknown(
          data['sub_category']!,
          _subCategoryMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_subCategoryMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('available_colors_json')) {
      context.handle(
        _availableColorsJsonMeta,
        availableColorsJson.isAcceptableOrUnknown(
          data['available_colors_json']!,
          _availableColorsJsonMeta,
        ),
      );
    }
    if (data.containsKey('available_sizes_json')) {
      context.handle(
        _availableSizesJsonMeta,
        availableSizesJson.isAcceptableOrUnknown(
          data['available_sizes_json']!,
          _availableSizesJsonMeta,
        ),
      );
    }
    if (data.containsKey('variant_label')) {
      context.handle(
        _variantLabelMeta,
        variantLabel.isAcceptableOrUnknown(
          data['variant_label']!,
          _variantLabelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_variantLabelMeta);
    }
    if (data.containsKey('config_json')) {
      context.handle(
        _configJsonMeta,
        configJson.isAcceptableOrUnknown(data['config_json']!, _configJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_configJsonMeta);
    }
    if (data.containsKey('total_units')) {
      context.handle(
        _totalUnitsMeta,
        totalUnits.isAcceptableOrUnknown(data['total_units']!, _totalUnitsMeta),
      );
    } else if (isInserting) {
      context.missing(_totalUnitsMeta);
    }
    if (data.containsKey('srp')) {
      context.handle(
        _srpMeta,
        srp.isAcceptableOrUnknown(data['srp']!, _srpMeta),
      );
    }
    if (data.containsKey('price_tiers_json')) {
      context.handle(
        _priceTiersJsonMeta,
        priceTiersJson.isAcceptableOrUnknown(
          data['price_tiers_json']!,
          _priceTiersJsonMeta,
        ),
      );
    }
    if (data.containsKey('available_materials_json')) {
      context.handle(
        _availableMaterialsJsonMeta,
        availableMaterialsJson.isAcceptableOrUnknown(
          data['available_materials_json']!,
          _availableMaterialsJsonMeta,
        ),
      );
    }
    if (data.containsKey('current_stock')) {
      context.handle(
        _currentStockMeta,
        currentStock.isAcceptableOrUnknown(
          data['current_stock']!,
          _currentStockMeta,
        ),
      );
    }
    if (data.containsKey('lead_time_days')) {
      context.handle(
        _leadTimeDaysMeta,
        leadTimeDays.isAcceptableOrUnknown(
          data['lead_time_days']!,
          _leadTimeDaysMeta,
        ),
      );
    }
    if (data.containsKey('seo_description')) {
      context.handle(
        _seoDescriptionMeta,
        seoDescription.isAcceptableOrUnknown(
          data['seo_description']!,
          _seoDescriptionMeta,
        ),
      );
    }
    if (data.containsKey('trading_terms_json')) {
      context.handle(
        _tradingTermsJsonMeta,
        tradingTermsJson.isAcceptableOrUnknown(
          data['trading_terms_json']!,
          _tradingTermsJsonMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BulkOrderEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BulkOrderEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      groupName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_name'],
      ),
      productName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_name'],
      )!,
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      ),
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      subCategory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sub_category'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      availableColorsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}available_colors_json'],
      ),
      availableSizesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}available_sizes_json'],
      ),
      variantLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}variant_label'],
      )!,
      configJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}config_json'],
      )!,
      totalUnits: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_units'],
      )!,
      srp: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}srp'],
      )!,
      priceTiersJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}price_tiers_json'],
      ),
      availableMaterialsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}available_materials_json'],
      ),
      currentStock: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_stock'],
      )!,
      leadTimeDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lead_time_days'],
      )!,
      seoDescription: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}seo_description'],
      ),
      tradingTermsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trading_terms_json'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BulkOrdersTableTable createAlias(String alias) {
    return $BulkOrdersTableTable(attachedDatabase, alias);
  }
}

class BulkOrderEntry extends DataClass implements Insertable<BulkOrderEntry> {
  final String id;
  final String? groupName;
  final String productName;
  final String? brand;
  final String category;
  final String subCategory;
  final String? imageUrl;
  final String? availableColorsJson;
  final String? availableSizesJson;
  final String variantLabel;
  final String configJson;
  final int totalUnits;
  final double srp;
  final String? priceTiersJson;
  final String? availableMaterialsJson;
  final int currentStock;
  final int leadTimeDays;
  final String? seoDescription;
  final String? tradingTermsJson;
  final DateTime createdAt;
  const BulkOrderEntry({
    required this.id,
    this.groupName,
    required this.productName,
    this.brand,
    required this.category,
    required this.subCategory,
    this.imageUrl,
    this.availableColorsJson,
    this.availableSizesJson,
    required this.variantLabel,
    required this.configJson,
    required this.totalUnits,
    required this.srp,
    this.priceTiersJson,
    this.availableMaterialsJson,
    required this.currentStock,
    required this.leadTimeDays,
    this.seoDescription,
    this.tradingTermsJson,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || groupName != null) {
      map['group_name'] = Variable<String>(groupName);
    }
    map['product_name'] = Variable<String>(productName);
    if (!nullToAbsent || brand != null) {
      map['brand'] = Variable<String>(brand);
    }
    map['category'] = Variable<String>(category);
    map['sub_category'] = Variable<String>(subCategory);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    if (!nullToAbsent || availableColorsJson != null) {
      map['available_colors_json'] = Variable<String>(availableColorsJson);
    }
    if (!nullToAbsent || availableSizesJson != null) {
      map['available_sizes_json'] = Variable<String>(availableSizesJson);
    }
    map['variant_label'] = Variable<String>(variantLabel);
    map['config_json'] = Variable<String>(configJson);
    map['total_units'] = Variable<int>(totalUnits);
    map['srp'] = Variable<double>(srp);
    if (!nullToAbsent || priceTiersJson != null) {
      map['price_tiers_json'] = Variable<String>(priceTiersJson);
    }
    if (!nullToAbsent || availableMaterialsJson != null) {
      map['available_materials_json'] = Variable<String>(
        availableMaterialsJson,
      );
    }
    map['current_stock'] = Variable<int>(currentStock);
    map['lead_time_days'] = Variable<int>(leadTimeDays);
    if (!nullToAbsent || seoDescription != null) {
      map['seo_description'] = Variable<String>(seoDescription);
    }
    if (!nullToAbsent || tradingTermsJson != null) {
      map['trading_terms_json'] = Variable<String>(tradingTermsJson);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BulkOrdersTableCompanion toCompanion(bool nullToAbsent) {
    return BulkOrdersTableCompanion(
      id: Value(id),
      groupName: groupName == null && nullToAbsent
          ? const Value.absent()
          : Value(groupName),
      productName: Value(productName),
      brand: brand == null && nullToAbsent
          ? const Value.absent()
          : Value(brand),
      category: Value(category),
      subCategory: Value(subCategory),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      availableColorsJson: availableColorsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(availableColorsJson),
      availableSizesJson: availableSizesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(availableSizesJson),
      variantLabel: Value(variantLabel),
      configJson: Value(configJson),
      totalUnits: Value(totalUnits),
      srp: Value(srp),
      priceTiersJson: priceTiersJson == null && nullToAbsent
          ? const Value.absent()
          : Value(priceTiersJson),
      availableMaterialsJson: availableMaterialsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(availableMaterialsJson),
      currentStock: Value(currentStock),
      leadTimeDays: Value(leadTimeDays),
      seoDescription: seoDescription == null && nullToAbsent
          ? const Value.absent()
          : Value(seoDescription),
      tradingTermsJson: tradingTermsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(tradingTermsJson),
      createdAt: Value(createdAt),
    );
  }

  factory BulkOrderEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BulkOrderEntry(
      id: serializer.fromJson<String>(json['id']),
      groupName: serializer.fromJson<String?>(json['groupName']),
      productName: serializer.fromJson<String>(json['productName']),
      brand: serializer.fromJson<String?>(json['brand']),
      category: serializer.fromJson<String>(json['category']),
      subCategory: serializer.fromJson<String>(json['subCategory']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      availableColorsJson: serializer.fromJson<String?>(
        json['availableColorsJson'],
      ),
      availableSizesJson: serializer.fromJson<String?>(
        json['availableSizesJson'],
      ),
      variantLabel: serializer.fromJson<String>(json['variantLabel']),
      configJson: serializer.fromJson<String>(json['configJson']),
      totalUnits: serializer.fromJson<int>(json['totalUnits']),
      srp: serializer.fromJson<double>(json['srp']),
      priceTiersJson: serializer.fromJson<String?>(json['priceTiersJson']),
      availableMaterialsJson: serializer.fromJson<String?>(
        json['availableMaterialsJson'],
      ),
      currentStock: serializer.fromJson<int>(json['currentStock']),
      leadTimeDays: serializer.fromJson<int>(json['leadTimeDays']),
      seoDescription: serializer.fromJson<String?>(json['seoDescription']),
      tradingTermsJson: serializer.fromJson<String?>(json['tradingTermsJson']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'groupName': serializer.toJson<String?>(groupName),
      'productName': serializer.toJson<String>(productName),
      'brand': serializer.toJson<String?>(brand),
      'category': serializer.toJson<String>(category),
      'subCategory': serializer.toJson<String>(subCategory),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'availableColorsJson': serializer.toJson<String?>(availableColorsJson),
      'availableSizesJson': serializer.toJson<String?>(availableSizesJson),
      'variantLabel': serializer.toJson<String>(variantLabel),
      'configJson': serializer.toJson<String>(configJson),
      'totalUnits': serializer.toJson<int>(totalUnits),
      'srp': serializer.toJson<double>(srp),
      'priceTiersJson': serializer.toJson<String?>(priceTiersJson),
      'availableMaterialsJson': serializer.toJson<String?>(
        availableMaterialsJson,
      ),
      'currentStock': serializer.toJson<int>(currentStock),
      'leadTimeDays': serializer.toJson<int>(leadTimeDays),
      'seoDescription': serializer.toJson<String?>(seoDescription),
      'tradingTermsJson': serializer.toJson<String?>(tradingTermsJson),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BulkOrderEntry copyWith({
    String? id,
    Value<String?> groupName = const Value.absent(),
    String? productName,
    Value<String?> brand = const Value.absent(),
    String? category,
    String? subCategory,
    Value<String?> imageUrl = const Value.absent(),
    Value<String?> availableColorsJson = const Value.absent(),
    Value<String?> availableSizesJson = const Value.absent(),
    String? variantLabel,
    String? configJson,
    int? totalUnits,
    double? srp,
    Value<String?> priceTiersJson = const Value.absent(),
    Value<String?> availableMaterialsJson = const Value.absent(),
    int? currentStock,
    int? leadTimeDays,
    Value<String?> seoDescription = const Value.absent(),
    Value<String?> tradingTermsJson = const Value.absent(),
    DateTime? createdAt,
  }) => BulkOrderEntry(
    id: id ?? this.id,
    groupName: groupName.present ? groupName.value : this.groupName,
    productName: productName ?? this.productName,
    brand: brand.present ? brand.value : this.brand,
    category: category ?? this.category,
    subCategory: subCategory ?? this.subCategory,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    availableColorsJson: availableColorsJson.present
        ? availableColorsJson.value
        : this.availableColorsJson,
    availableSizesJson: availableSizesJson.present
        ? availableSizesJson.value
        : this.availableSizesJson,
    variantLabel: variantLabel ?? this.variantLabel,
    configJson: configJson ?? this.configJson,
    totalUnits: totalUnits ?? this.totalUnits,
    srp: srp ?? this.srp,
    priceTiersJson: priceTiersJson.present
        ? priceTiersJson.value
        : this.priceTiersJson,
    availableMaterialsJson: availableMaterialsJson.present
        ? availableMaterialsJson.value
        : this.availableMaterialsJson,
    currentStock: currentStock ?? this.currentStock,
    leadTimeDays: leadTimeDays ?? this.leadTimeDays,
    seoDescription: seoDescription.present
        ? seoDescription.value
        : this.seoDescription,
    tradingTermsJson: tradingTermsJson.present
        ? tradingTermsJson.value
        : this.tradingTermsJson,
    createdAt: createdAt ?? this.createdAt,
  );
  BulkOrderEntry copyWithCompanion(BulkOrdersTableCompanion data) {
    return BulkOrderEntry(
      id: data.id.present ? data.id.value : this.id,
      groupName: data.groupName.present ? data.groupName.value : this.groupName,
      productName: data.productName.present
          ? data.productName.value
          : this.productName,
      brand: data.brand.present ? data.brand.value : this.brand,
      category: data.category.present ? data.category.value : this.category,
      subCategory: data.subCategory.present
          ? data.subCategory.value
          : this.subCategory,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      availableColorsJson: data.availableColorsJson.present
          ? data.availableColorsJson.value
          : this.availableColorsJson,
      availableSizesJson: data.availableSizesJson.present
          ? data.availableSizesJson.value
          : this.availableSizesJson,
      variantLabel: data.variantLabel.present
          ? data.variantLabel.value
          : this.variantLabel,
      configJson: data.configJson.present
          ? data.configJson.value
          : this.configJson,
      totalUnits: data.totalUnits.present
          ? data.totalUnits.value
          : this.totalUnits,
      srp: data.srp.present ? data.srp.value : this.srp,
      priceTiersJson: data.priceTiersJson.present
          ? data.priceTiersJson.value
          : this.priceTiersJson,
      availableMaterialsJson: data.availableMaterialsJson.present
          ? data.availableMaterialsJson.value
          : this.availableMaterialsJson,
      currentStock: data.currentStock.present
          ? data.currentStock.value
          : this.currentStock,
      leadTimeDays: data.leadTimeDays.present
          ? data.leadTimeDays.value
          : this.leadTimeDays,
      seoDescription: data.seoDescription.present
          ? data.seoDescription.value
          : this.seoDescription,
      tradingTermsJson: data.tradingTermsJson.present
          ? data.tradingTermsJson.value
          : this.tradingTermsJson,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BulkOrderEntry(')
          ..write('id: $id, ')
          ..write('groupName: $groupName, ')
          ..write('productName: $productName, ')
          ..write('brand: $brand, ')
          ..write('category: $category, ')
          ..write('subCategory: $subCategory, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('availableColorsJson: $availableColorsJson, ')
          ..write('availableSizesJson: $availableSizesJson, ')
          ..write('variantLabel: $variantLabel, ')
          ..write('configJson: $configJson, ')
          ..write('totalUnits: $totalUnits, ')
          ..write('srp: $srp, ')
          ..write('priceTiersJson: $priceTiersJson, ')
          ..write('availableMaterialsJson: $availableMaterialsJson, ')
          ..write('currentStock: $currentStock, ')
          ..write('leadTimeDays: $leadTimeDays, ')
          ..write('seoDescription: $seoDescription, ')
          ..write('tradingTermsJson: $tradingTermsJson, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    groupName,
    productName,
    brand,
    category,
    subCategory,
    imageUrl,
    availableColorsJson,
    availableSizesJson,
    variantLabel,
    configJson,
    totalUnits,
    srp,
    priceTiersJson,
    availableMaterialsJson,
    currentStock,
    leadTimeDays,
    seoDescription,
    tradingTermsJson,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BulkOrderEntry &&
          other.id == this.id &&
          other.groupName == this.groupName &&
          other.productName == this.productName &&
          other.brand == this.brand &&
          other.category == this.category &&
          other.subCategory == this.subCategory &&
          other.imageUrl == this.imageUrl &&
          other.availableColorsJson == this.availableColorsJson &&
          other.availableSizesJson == this.availableSizesJson &&
          other.variantLabel == this.variantLabel &&
          other.configJson == this.configJson &&
          other.totalUnits == this.totalUnits &&
          other.srp == this.srp &&
          other.priceTiersJson == this.priceTiersJson &&
          other.availableMaterialsJson == this.availableMaterialsJson &&
          other.currentStock == this.currentStock &&
          other.leadTimeDays == this.leadTimeDays &&
          other.seoDescription == this.seoDescription &&
          other.tradingTermsJson == this.tradingTermsJson &&
          other.createdAt == this.createdAt);
}

class BulkOrdersTableCompanion extends UpdateCompanion<BulkOrderEntry> {
  final Value<String> id;
  final Value<String?> groupName;
  final Value<String> productName;
  final Value<String?> brand;
  final Value<String> category;
  final Value<String> subCategory;
  final Value<String?> imageUrl;
  final Value<String?> availableColorsJson;
  final Value<String?> availableSizesJson;
  final Value<String> variantLabel;
  final Value<String> configJson;
  final Value<int> totalUnits;
  final Value<double> srp;
  final Value<String?> priceTiersJson;
  final Value<String?> availableMaterialsJson;
  final Value<int> currentStock;
  final Value<int> leadTimeDays;
  final Value<String?> seoDescription;
  final Value<String?> tradingTermsJson;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const BulkOrdersTableCompanion({
    this.id = const Value.absent(),
    this.groupName = const Value.absent(),
    this.productName = const Value.absent(),
    this.brand = const Value.absent(),
    this.category = const Value.absent(),
    this.subCategory = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.availableColorsJson = const Value.absent(),
    this.availableSizesJson = const Value.absent(),
    this.variantLabel = const Value.absent(),
    this.configJson = const Value.absent(),
    this.totalUnits = const Value.absent(),
    this.srp = const Value.absent(),
    this.priceTiersJson = const Value.absent(),
    this.availableMaterialsJson = const Value.absent(),
    this.currentStock = const Value.absent(),
    this.leadTimeDays = const Value.absent(),
    this.seoDescription = const Value.absent(),
    this.tradingTermsJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BulkOrdersTableCompanion.insert({
    required String id,
    this.groupName = const Value.absent(),
    required String productName,
    this.brand = const Value.absent(),
    required String category,
    required String subCategory,
    this.imageUrl = const Value.absent(),
    this.availableColorsJson = const Value.absent(),
    this.availableSizesJson = const Value.absent(),
    required String variantLabel,
    required String configJson,
    required int totalUnits,
    this.srp = const Value.absent(),
    this.priceTiersJson = const Value.absent(),
    this.availableMaterialsJson = const Value.absent(),
    this.currentStock = const Value.absent(),
    this.leadTimeDays = const Value.absent(),
    this.seoDescription = const Value.absent(),
    this.tradingTermsJson = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       productName = Value(productName),
       category = Value(category),
       subCategory = Value(subCategory),
       variantLabel = Value(variantLabel),
       configJson = Value(configJson),
       totalUnits = Value(totalUnits);
  static Insertable<BulkOrderEntry> custom({
    Expression<String>? id,
    Expression<String>? groupName,
    Expression<String>? productName,
    Expression<String>? brand,
    Expression<String>? category,
    Expression<String>? subCategory,
    Expression<String>? imageUrl,
    Expression<String>? availableColorsJson,
    Expression<String>? availableSizesJson,
    Expression<String>? variantLabel,
    Expression<String>? configJson,
    Expression<int>? totalUnits,
    Expression<double>? srp,
    Expression<String>? priceTiersJson,
    Expression<String>? availableMaterialsJson,
    Expression<int>? currentStock,
    Expression<int>? leadTimeDays,
    Expression<String>? seoDescription,
    Expression<String>? tradingTermsJson,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (groupName != null) 'group_name': groupName,
      if (productName != null) 'product_name': productName,
      if (brand != null) 'brand': brand,
      if (category != null) 'category': category,
      if (subCategory != null) 'sub_category': subCategory,
      if (imageUrl != null) 'image_url': imageUrl,
      if (availableColorsJson != null)
        'available_colors_json': availableColorsJson,
      if (availableSizesJson != null)
        'available_sizes_json': availableSizesJson,
      if (variantLabel != null) 'variant_label': variantLabel,
      if (configJson != null) 'config_json': configJson,
      if (totalUnits != null) 'total_units': totalUnits,
      if (srp != null) 'srp': srp,
      if (priceTiersJson != null) 'price_tiers_json': priceTiersJson,
      if (availableMaterialsJson != null)
        'available_materials_json': availableMaterialsJson,
      if (currentStock != null) 'current_stock': currentStock,
      if (leadTimeDays != null) 'lead_time_days': leadTimeDays,
      if (seoDescription != null) 'seo_description': seoDescription,
      if (tradingTermsJson != null) 'trading_terms_json': tradingTermsJson,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BulkOrdersTableCompanion copyWith({
    Value<String>? id,
    Value<String?>? groupName,
    Value<String>? productName,
    Value<String?>? brand,
    Value<String>? category,
    Value<String>? subCategory,
    Value<String?>? imageUrl,
    Value<String?>? availableColorsJson,
    Value<String?>? availableSizesJson,
    Value<String>? variantLabel,
    Value<String>? configJson,
    Value<int>? totalUnits,
    Value<double>? srp,
    Value<String?>? priceTiersJson,
    Value<String?>? availableMaterialsJson,
    Value<int>? currentStock,
    Value<int>? leadTimeDays,
    Value<String?>? seoDescription,
    Value<String?>? tradingTermsJson,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return BulkOrdersTableCompanion(
      id: id ?? this.id,
      groupName: groupName ?? this.groupName,
      productName: productName ?? this.productName,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      imageUrl: imageUrl ?? this.imageUrl,
      availableColorsJson: availableColorsJson ?? this.availableColorsJson,
      availableSizesJson: availableSizesJson ?? this.availableSizesJson,
      variantLabel: variantLabel ?? this.variantLabel,
      configJson: configJson ?? this.configJson,
      totalUnits: totalUnits ?? this.totalUnits,
      srp: srp ?? this.srp,
      priceTiersJson: priceTiersJson ?? this.priceTiersJson,
      availableMaterialsJson:
          availableMaterialsJson ?? this.availableMaterialsJson,
      currentStock: currentStock ?? this.currentStock,
      leadTimeDays: leadTimeDays ?? this.leadTimeDays,
      seoDescription: seoDescription ?? this.seoDescription,
      tradingTermsJson: tradingTermsJson ?? this.tradingTermsJson,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (groupName.present) {
      map['group_name'] = Variable<String>(groupName.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (subCategory.present) {
      map['sub_category'] = Variable<String>(subCategory.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (availableColorsJson.present) {
      map['available_colors_json'] = Variable<String>(
        availableColorsJson.value,
      );
    }
    if (availableSizesJson.present) {
      map['available_sizes_json'] = Variable<String>(availableSizesJson.value);
    }
    if (variantLabel.present) {
      map['variant_label'] = Variable<String>(variantLabel.value);
    }
    if (configJson.present) {
      map['config_json'] = Variable<String>(configJson.value);
    }
    if (totalUnits.present) {
      map['total_units'] = Variable<int>(totalUnits.value);
    }
    if (srp.present) {
      map['srp'] = Variable<double>(srp.value);
    }
    if (priceTiersJson.present) {
      map['price_tiers_json'] = Variable<String>(priceTiersJson.value);
    }
    if (availableMaterialsJson.present) {
      map['available_materials_json'] = Variable<String>(
        availableMaterialsJson.value,
      );
    }
    if (currentStock.present) {
      map['current_stock'] = Variable<int>(currentStock.value);
    }
    if (leadTimeDays.present) {
      map['lead_time_days'] = Variable<int>(leadTimeDays.value);
    }
    if (seoDescription.present) {
      map['seo_description'] = Variable<String>(seoDescription.value);
    }
    if (tradingTermsJson.present) {
      map['trading_terms_json'] = Variable<String>(tradingTermsJson.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BulkOrdersTableCompanion(')
          ..write('id: $id, ')
          ..write('groupName: $groupName, ')
          ..write('productName: $productName, ')
          ..write('brand: $brand, ')
          ..write('category: $category, ')
          ..write('subCategory: $subCategory, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('availableColorsJson: $availableColorsJson, ')
          ..write('availableSizesJson: $availableSizesJson, ')
          ..write('variantLabel: $variantLabel, ')
          ..write('configJson: $configJson, ')
          ..write('totalUnits: $totalUnits, ')
          ..write('srp: $srp, ')
          ..write('priceTiersJson: $priceTiersJson, ')
          ..write('availableMaterialsJson: $availableMaterialsJson, ')
          ..write('currentStock: $currentStock, ')
          ..write('leadTimeDays: $leadTimeDays, ')
          ..write('seoDescription: $seoDescription, ')
          ..write('tradingTermsJson: $tradingTermsJson, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OrdersTableTable extends OrdersTable
    with TableInfo<$OrdersTableTable, WholesaleOrderEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrdersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemsJsonMeta = const VerificationMeta(
    'itemsJson',
  );
  @override
  late final GeneratedColumn<String> itemsJson = GeneratedColumn<String>(
    'items_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalAmountMeta = const VerificationMeta(
    'totalAmount',
  );
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
    'total_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalUnitsMeta = const VerificationMeta(
    'totalUnits',
  );
  @override
  late final GeneratedColumn<int> totalUnits = GeneratedColumn<int>(
    'total_units',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('PROCESSING'),
  );
  static const VerificationMeta _isDraftMeta = const VerificationMeta(
    'isDraft',
  );
  @override
  late final GeneratedColumn<bool> isDraft = GeneratedColumn<bool>(
    'is_draft',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_draft" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _pdfIdMeta = const VerificationMeta('pdfId');
  @override
  late final GeneratedColumn<String> pdfId = GeneratedColumn<String>(
    'pdf_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _supplierIdMeta = const VerificationMeta(
    'supplierId',
  );
  @override
  late final GeneratedColumn<String> supplierId = GeneratedColumn<String>(
    'supplier_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    itemsJson,
    totalAmount,
    totalUnits,
    status,
    isDraft,
    pdfId,
    productId,
    supplierId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'orders_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<WholesaleOrderEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('items_json')) {
      context.handle(
        _itemsJsonMeta,
        itemsJson.isAcceptableOrUnknown(data['items_json']!, _itemsJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_itemsJsonMeta);
    }
    if (data.containsKey('total_amount')) {
      context.handle(
        _totalAmountMeta,
        totalAmount.isAcceptableOrUnknown(
          data['total_amount']!,
          _totalAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
    }
    if (data.containsKey('total_units')) {
      context.handle(
        _totalUnitsMeta,
        totalUnits.isAcceptableOrUnknown(data['total_units']!, _totalUnitsMeta),
      );
    } else if (isInserting) {
      context.missing(_totalUnitsMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('is_draft')) {
      context.handle(
        _isDraftMeta,
        isDraft.isAcceptableOrUnknown(data['is_draft']!, _isDraftMeta),
      );
    }
    if (data.containsKey('pdf_id')) {
      context.handle(
        _pdfIdMeta,
        pdfId.isAcceptableOrUnknown(data['pdf_id']!, _pdfIdMeta),
      );
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    }
    if (data.containsKey('supplier_id')) {
      context.handle(
        _supplierIdMeta,
        supplierId.isAcceptableOrUnknown(data['supplier_id']!, _supplierIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WholesaleOrderEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WholesaleOrderEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      itemsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}items_json'],
      )!,
      totalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_amount'],
      )!,
      totalUnits: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_units'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      isDraft: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_draft'],
      )!,
      pdfId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pdf_id'],
      ),
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      ),
      supplierId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplier_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $OrdersTableTable createAlias(String alias) {
    return $OrdersTableTable(attachedDatabase, alias);
  }
}

class WholesaleOrderEntry extends DataClass
    implements Insertable<WholesaleOrderEntry> {
  final String id;
  final String userId;
  final String itemsJson;
  final double totalAmount;
  final int totalUnits;
  final String status;
  final bool isDraft;
  final String? pdfId;
  final String? productId;
  final String? supplierId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const WholesaleOrderEntry({
    required this.id,
    required this.userId,
    required this.itemsJson,
    required this.totalAmount,
    required this.totalUnits,
    required this.status,
    required this.isDraft,
    this.pdfId,
    this.productId,
    this.supplierId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['items_json'] = Variable<String>(itemsJson);
    map['total_amount'] = Variable<double>(totalAmount);
    map['total_units'] = Variable<int>(totalUnits);
    map['status'] = Variable<String>(status);
    map['is_draft'] = Variable<bool>(isDraft);
    if (!nullToAbsent || pdfId != null) {
      map['pdf_id'] = Variable<String>(pdfId);
    }
    if (!nullToAbsent || productId != null) {
      map['product_id'] = Variable<String>(productId);
    }
    if (!nullToAbsent || supplierId != null) {
      map['supplier_id'] = Variable<String>(supplierId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  OrdersTableCompanion toCompanion(bool nullToAbsent) {
    return OrdersTableCompanion(
      id: Value(id),
      userId: Value(userId),
      itemsJson: Value(itemsJson),
      totalAmount: Value(totalAmount),
      totalUnits: Value(totalUnits),
      status: Value(status),
      isDraft: Value(isDraft),
      pdfId: pdfId == null && nullToAbsent
          ? const Value.absent()
          : Value(pdfId),
      productId: productId == null && nullToAbsent
          ? const Value.absent()
          : Value(productId),
      supplierId: supplierId == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory WholesaleOrderEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WholesaleOrderEntry(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      itemsJson: serializer.fromJson<String>(json['itemsJson']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      totalUnits: serializer.fromJson<int>(json['totalUnits']),
      status: serializer.fromJson<String>(json['status']),
      isDraft: serializer.fromJson<bool>(json['isDraft']),
      pdfId: serializer.fromJson<String?>(json['pdfId']),
      productId: serializer.fromJson<String?>(json['productId']),
      supplierId: serializer.fromJson<String?>(json['supplierId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'itemsJson': serializer.toJson<String>(itemsJson),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'totalUnits': serializer.toJson<int>(totalUnits),
      'status': serializer.toJson<String>(status),
      'isDraft': serializer.toJson<bool>(isDraft),
      'pdfId': serializer.toJson<String?>(pdfId),
      'productId': serializer.toJson<String?>(productId),
      'supplierId': serializer.toJson<String?>(supplierId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  WholesaleOrderEntry copyWith({
    String? id,
    String? userId,
    String? itemsJson,
    double? totalAmount,
    int? totalUnits,
    String? status,
    bool? isDraft,
    Value<String?> pdfId = const Value.absent(),
    Value<String?> productId = const Value.absent(),
    Value<String?> supplierId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => WholesaleOrderEntry(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    itemsJson: itemsJson ?? this.itemsJson,
    totalAmount: totalAmount ?? this.totalAmount,
    totalUnits: totalUnits ?? this.totalUnits,
    status: status ?? this.status,
    isDraft: isDraft ?? this.isDraft,
    pdfId: pdfId.present ? pdfId.value : this.pdfId,
    productId: productId.present ? productId.value : this.productId,
    supplierId: supplierId.present ? supplierId.value : this.supplierId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  WholesaleOrderEntry copyWithCompanion(OrdersTableCompanion data) {
    return WholesaleOrderEntry(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      itemsJson: data.itemsJson.present ? data.itemsJson.value : this.itemsJson,
      totalAmount: data.totalAmount.present
          ? data.totalAmount.value
          : this.totalAmount,
      totalUnits: data.totalUnits.present
          ? data.totalUnits.value
          : this.totalUnits,
      status: data.status.present ? data.status.value : this.status,
      isDraft: data.isDraft.present ? data.isDraft.value : this.isDraft,
      pdfId: data.pdfId.present ? data.pdfId.value : this.pdfId,
      productId: data.productId.present ? data.productId.value : this.productId,
      supplierId: data.supplierId.present
          ? data.supplierId.value
          : this.supplierId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WholesaleOrderEntry(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('itemsJson: $itemsJson, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('totalUnits: $totalUnits, ')
          ..write('status: $status, ')
          ..write('isDraft: $isDraft, ')
          ..write('pdfId: $pdfId, ')
          ..write('productId: $productId, ')
          ..write('supplierId: $supplierId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    itemsJson,
    totalAmount,
    totalUnits,
    status,
    isDraft,
    pdfId,
    productId,
    supplierId,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WholesaleOrderEntry &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.itemsJson == this.itemsJson &&
          other.totalAmount == this.totalAmount &&
          other.totalUnits == this.totalUnits &&
          other.status == this.status &&
          other.isDraft == this.isDraft &&
          other.pdfId == this.pdfId &&
          other.productId == this.productId &&
          other.supplierId == this.supplierId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class OrdersTableCompanion extends UpdateCompanion<WholesaleOrderEntry> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> itemsJson;
  final Value<double> totalAmount;
  final Value<int> totalUnits;
  final Value<String> status;
  final Value<bool> isDraft;
  final Value<String?> pdfId;
  final Value<String?> productId;
  final Value<String?> supplierId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const OrdersTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.itemsJson = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.totalUnits = const Value.absent(),
    this.status = const Value.absent(),
    this.isDraft = const Value.absent(),
    this.pdfId = const Value.absent(),
    this.productId = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrdersTableCompanion.insert({
    required String id,
    required String userId,
    required String itemsJson,
    required double totalAmount,
    required int totalUnits,
    this.status = const Value.absent(),
    this.isDraft = const Value.absent(),
    this.pdfId = const Value.absent(),
    this.productId = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       itemsJson = Value(itemsJson),
       totalAmount = Value(totalAmount),
       totalUnits = Value(totalUnits);
  static Insertable<WholesaleOrderEntry> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? itemsJson,
    Expression<double>? totalAmount,
    Expression<int>? totalUnits,
    Expression<String>? status,
    Expression<bool>? isDraft,
    Expression<String>? pdfId,
    Expression<String>? productId,
    Expression<String>? supplierId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (itemsJson != null) 'items_json': itemsJson,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (totalUnits != null) 'total_units': totalUnits,
      if (status != null) 'status': status,
      if (isDraft != null) 'is_draft': isDraft,
      if (pdfId != null) 'pdf_id': pdfId,
      if (productId != null) 'product_id': productId,
      if (supplierId != null) 'supplier_id': supplierId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrdersTableCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? itemsJson,
    Value<double>? totalAmount,
    Value<int>? totalUnits,
    Value<String>? status,
    Value<bool>? isDraft,
    Value<String?>? pdfId,
    Value<String?>? productId,
    Value<String?>? supplierId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return OrdersTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      itemsJson: itemsJson ?? this.itemsJson,
      totalAmount: totalAmount ?? this.totalAmount,
      totalUnits: totalUnits ?? this.totalUnits,
      status: status ?? this.status,
      isDraft: isDraft ?? this.isDraft,
      pdfId: pdfId ?? this.pdfId,
      productId: productId ?? this.productId,
      supplierId: supplierId ?? this.supplierId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (itemsJson.present) {
      map['items_json'] = Variable<String>(itemsJson.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (totalUnits.present) {
      map['total_units'] = Variable<int>(totalUnits.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (isDraft.present) {
      map['is_draft'] = Variable<bool>(isDraft.value);
    }
    if (pdfId.present) {
      map['pdf_id'] = Variable<String>(pdfId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (supplierId.present) {
      map['supplier_id'] = Variable<String>(supplierId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrdersTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('itemsJson: $itemsJson, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('totalUnits: $totalUnits, ')
          ..write('status: $status, ')
          ..write('isDraft: $isDraft, ')
          ..write('pdfId: $pdfId, ')
          ..write('productId: $productId, ')
          ..write('supplierId: $supplierId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GeneratedPdfsTableTable extends GeneratedPdfsTable
    with TableInfo<$GeneratedPdfsTableTable, GeneratedPdfEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GeneratedPdfsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fileSizeMeta = const VerificationMeta(
    'fileSize',
  );
  @override
  late final GeneratedColumn<String> fileSize = GeneratedColumn<String>(
    'file_size',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    title,
    filePath,
    fileSize,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'generated_pdfs_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<GeneratedPdfEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('file_size')) {
      context.handle(
        _fileSizeMeta,
        fileSize.isAcceptableOrUnknown(data['file_size']!, _fileSizeMeta),
      );
    } else if (isInserting) {
      context.missing(_fileSizeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GeneratedPdfEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GeneratedPdfEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      fileSize: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_size'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $GeneratedPdfsTableTable createAlias(String alias) {
    return $GeneratedPdfsTableTable(attachedDatabase, alias);
  }
}

class GeneratedPdfEntry extends DataClass
    implements Insertable<GeneratedPdfEntry> {
  final String id;
  final String userId;
  final String title;
  final String filePath;
  final String fileSize;
  final DateTime createdAt;
  const GeneratedPdfEntry({
    required this.id,
    required this.userId,
    required this.title,
    required this.filePath,
    required this.fileSize,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['title'] = Variable<String>(title);
    map['file_path'] = Variable<String>(filePath);
    map['file_size'] = Variable<String>(fileSize);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  GeneratedPdfsTableCompanion toCompanion(bool nullToAbsent) {
    return GeneratedPdfsTableCompanion(
      id: Value(id),
      userId: Value(userId),
      title: Value(title),
      filePath: Value(filePath),
      fileSize: Value(fileSize),
      createdAt: Value(createdAt),
    );
  }

  factory GeneratedPdfEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GeneratedPdfEntry(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      title: serializer.fromJson<String>(json['title']),
      filePath: serializer.fromJson<String>(json['filePath']),
      fileSize: serializer.fromJson<String>(json['fileSize']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'title': serializer.toJson<String>(title),
      'filePath': serializer.toJson<String>(filePath),
      'fileSize': serializer.toJson<String>(fileSize),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  GeneratedPdfEntry copyWith({
    String? id,
    String? userId,
    String? title,
    String? filePath,
    String? fileSize,
    DateTime? createdAt,
  }) => GeneratedPdfEntry(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    title: title ?? this.title,
    filePath: filePath ?? this.filePath,
    fileSize: fileSize ?? this.fileSize,
    createdAt: createdAt ?? this.createdAt,
  );
  GeneratedPdfEntry copyWithCompanion(GeneratedPdfsTableCompanion data) {
    return GeneratedPdfEntry(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      title: data.title.present ? data.title.value : this.title,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      fileSize: data.fileSize.present ? data.fileSize.value : this.fileSize,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GeneratedPdfEntry(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('filePath: $filePath, ')
          ..write('fileSize: $fileSize, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, title, filePath, fileSize, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GeneratedPdfEntry &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.title == this.title &&
          other.filePath == this.filePath &&
          other.fileSize == this.fileSize &&
          other.createdAt == this.createdAt);
}

class GeneratedPdfsTableCompanion extends UpdateCompanion<GeneratedPdfEntry> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> title;
  final Value<String> filePath;
  final Value<String> fileSize;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const GeneratedPdfsTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.title = const Value.absent(),
    this.filePath = const Value.absent(),
    this.fileSize = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GeneratedPdfsTableCompanion.insert({
    required String id,
    required String userId,
    required String title,
    required String filePath,
    required String fileSize,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       title = Value(title),
       filePath = Value(filePath),
       fileSize = Value(fileSize);
  static Insertable<GeneratedPdfEntry> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? title,
    Expression<String>? filePath,
    Expression<String>? fileSize,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (title != null) 'title': title,
      if (filePath != null) 'file_path': filePath,
      if (fileSize != null) 'file_size': fileSize,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GeneratedPdfsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? title,
    Value<String>? filePath,
    Value<String>? fileSize,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return GeneratedPdfsTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      filePath: filePath ?? this.filePath,
      fileSize: fileSize ?? this.fileSize,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (fileSize.present) {
      map['file_size'] = Variable<String>(fileSize.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GeneratedPdfsTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('title: $title, ')
          ..write('filePath: $filePath, ')
          ..write('fileSize: $fileSize, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SearchHistoryTableTable extends SearchHistoryTable
    with TableInfo<$SearchHistoryTableTable, SearchHistoryEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SearchHistoryTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _queryMeta = const VerificationMeta('query');
  @override
  late final GeneratedColumn<String> query = GeneratedColumn<String>(
    'query',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, userId, query, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'search_history_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SearchHistoryEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('query')) {
      context.handle(
        _queryMeta,
        query.isAcceptableOrUnknown(data['query']!, _queryMeta),
      );
    } else if (isInserting) {
      context.missing(_queryMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SearchHistoryEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SearchHistoryEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      query: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}query'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SearchHistoryTableTable createAlias(String alias) {
    return $SearchHistoryTableTable(attachedDatabase, alias);
  }
}

class SearchHistoryEntry extends DataClass
    implements Insertable<SearchHistoryEntry> {
  final String id;
  final String userId;
  final String query;
  final DateTime createdAt;
  const SearchHistoryEntry({
    required this.id,
    required this.userId,
    required this.query,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['query'] = Variable<String>(query);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SearchHistoryTableCompanion toCompanion(bool nullToAbsent) {
    return SearchHistoryTableCompanion(
      id: Value(id),
      userId: Value(userId),
      query: Value(query),
      createdAt: Value(createdAt),
    );
  }

  factory SearchHistoryEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SearchHistoryEntry(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      query: serializer.fromJson<String>(json['query']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'query': serializer.toJson<String>(query),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SearchHistoryEntry copyWith({
    String? id,
    String? userId,
    String? query,
    DateTime? createdAt,
  }) => SearchHistoryEntry(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    query: query ?? this.query,
    createdAt: createdAt ?? this.createdAt,
  );
  SearchHistoryEntry copyWithCompanion(SearchHistoryTableCompanion data) {
    return SearchHistoryEntry(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      query: data.query.present ? data.query.value : this.query,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SearchHistoryEntry(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('query: $query, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, query, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SearchHistoryEntry &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.query == this.query &&
          other.createdAt == this.createdAt);
}

class SearchHistoryTableCompanion extends UpdateCompanion<SearchHistoryEntry> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> query;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SearchHistoryTableCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.query = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SearchHistoryTableCompanion.insert({
    required String id,
    required String userId,
    required String query,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       query = Value(query);
  static Insertable<SearchHistoryEntry> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? query,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (query != null) 'query': query,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SearchHistoryTableCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? query,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return SearchHistoryTableCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      query: query ?? this.query,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (query.present) {
      map['query'] = Variable<String>(query.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SearchHistoryTableCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('query: $query, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PromotionsTableTable extends PromotionsTable
    with TableInfo<$PromotionsTableTable, PromotionEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PromotionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subtitleMeta = const VerificationMeta(
    'subtitle',
  );
  @override
  late final GeneratedColumn<String> subtitle = GeneratedColumn<String>(
    'subtitle',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actionTextMeta = const VerificationMeta(
    'actionText',
  );
  @override
  late final GeneratedColumn<String> actionText = GeneratedColumn<String>(
    'action_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageUrlsJsonMeta = const VerificationMeta(
    'imageUrlsJson',
  );
  @override
  late final GeneratedColumn<String> imageUrlsJson = GeneratedColumn<String>(
    'image_urls_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _startsAtMeta = const VerificationMeta(
    'startsAt',
  );
  @override
  late final GeneratedColumn<DateTime> startsAt = GeneratedColumn<DateTime>(
    'starts_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    subtitle,
    actionText,
    imageUrlsJson,
    priority,
    isActive,
    startsAt,
    expiresAt,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'promotions_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PromotionEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('subtitle')) {
      context.handle(
        _subtitleMeta,
        subtitle.isAcceptableOrUnknown(data['subtitle']!, _subtitleMeta),
      );
    }
    if (data.containsKey('action_text')) {
      context.handle(
        _actionTextMeta,
        actionText.isAcceptableOrUnknown(data['action_text']!, _actionTextMeta),
      );
    }
    if (data.containsKey('image_urls_json')) {
      context.handle(
        _imageUrlsJsonMeta,
        imageUrlsJson.isAcceptableOrUnknown(
          data['image_urls_json']!,
          _imageUrlsJsonMeta,
        ),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('starts_at')) {
      context.handle(
        _startsAtMeta,
        startsAt.isAcceptableOrUnknown(data['starts_at']!, _startsAtMeta),
      );
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PromotionEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PromotionEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      subtitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subtitle'],
      ),
      actionText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action_text'],
      ),
      imageUrlsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_urls_json'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      startsAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}starts_at'],
      ),
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PromotionsTableTable createAlias(String alias) {
    return $PromotionsTableTable(attachedDatabase, alias);
  }
}

class PromotionEntry extends DataClass implements Insertable<PromotionEntry> {
  final String id;
  final String title;
  final String? subtitle;
  final String? actionText;
  final String imageUrlsJson;
  final int priority;
  final bool isActive;
  final DateTime? startsAt;
  final DateTime? expiresAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PromotionEntry({
    required this.id,
    required this.title,
    this.subtitle,
    this.actionText,
    required this.imageUrlsJson,
    required this.priority,
    required this.isActive,
    this.startsAt,
    this.expiresAt,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || subtitle != null) {
      map['subtitle'] = Variable<String>(subtitle);
    }
    if (!nullToAbsent || actionText != null) {
      map['action_text'] = Variable<String>(actionText);
    }
    map['image_urls_json'] = Variable<String>(imageUrlsJson);
    map['priority'] = Variable<int>(priority);
    map['is_active'] = Variable<bool>(isActive);
    if (!nullToAbsent || startsAt != null) {
      map['starts_at'] = Variable<DateTime>(startsAt);
    }
    if (!nullToAbsent || expiresAt != null) {
      map['expires_at'] = Variable<DateTime>(expiresAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PromotionsTableCompanion toCompanion(bool nullToAbsent) {
    return PromotionsTableCompanion(
      id: Value(id),
      title: Value(title),
      subtitle: subtitle == null && nullToAbsent
          ? const Value.absent()
          : Value(subtitle),
      actionText: actionText == null && nullToAbsent
          ? const Value.absent()
          : Value(actionText),
      imageUrlsJson: Value(imageUrlsJson),
      priority: Value(priority),
      isActive: Value(isActive),
      startsAt: startsAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startsAt),
      expiresAt: expiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expiresAt),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PromotionEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PromotionEntry(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      subtitle: serializer.fromJson<String?>(json['subtitle']),
      actionText: serializer.fromJson<String?>(json['actionText']),
      imageUrlsJson: serializer.fromJson<String>(json['imageUrlsJson']),
      priority: serializer.fromJson<int>(json['priority']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      startsAt: serializer.fromJson<DateTime?>(json['startsAt']),
      expiresAt: serializer.fromJson<DateTime?>(json['expiresAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'subtitle': serializer.toJson<String?>(subtitle),
      'actionText': serializer.toJson<String?>(actionText),
      'imageUrlsJson': serializer.toJson<String>(imageUrlsJson),
      'priority': serializer.toJson<int>(priority),
      'isActive': serializer.toJson<bool>(isActive),
      'startsAt': serializer.toJson<DateTime?>(startsAt),
      'expiresAt': serializer.toJson<DateTime?>(expiresAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PromotionEntry copyWith({
    String? id,
    String? title,
    Value<String?> subtitle = const Value.absent(),
    Value<String?> actionText = const Value.absent(),
    String? imageUrlsJson,
    int? priority,
    bool? isActive,
    Value<DateTime?> startsAt = const Value.absent(),
    Value<DateTime?> expiresAt = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PromotionEntry(
    id: id ?? this.id,
    title: title ?? this.title,
    subtitle: subtitle.present ? subtitle.value : this.subtitle,
    actionText: actionText.present ? actionText.value : this.actionText,
    imageUrlsJson: imageUrlsJson ?? this.imageUrlsJson,
    priority: priority ?? this.priority,
    isActive: isActive ?? this.isActive,
    startsAt: startsAt.present ? startsAt.value : this.startsAt,
    expiresAt: expiresAt.present ? expiresAt.value : this.expiresAt,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PromotionEntry copyWithCompanion(PromotionsTableCompanion data) {
    return PromotionEntry(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      subtitle: data.subtitle.present ? data.subtitle.value : this.subtitle,
      actionText: data.actionText.present
          ? data.actionText.value
          : this.actionText,
      imageUrlsJson: data.imageUrlsJson.present
          ? data.imageUrlsJson.value
          : this.imageUrlsJson,
      priority: data.priority.present ? data.priority.value : this.priority,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      startsAt: data.startsAt.present ? data.startsAt.value : this.startsAt,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PromotionEntry(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('subtitle: $subtitle, ')
          ..write('actionText: $actionText, ')
          ..write('imageUrlsJson: $imageUrlsJson, ')
          ..write('priority: $priority, ')
          ..write('isActive: $isActive, ')
          ..write('startsAt: $startsAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    subtitle,
    actionText,
    imageUrlsJson,
    priority,
    isActive,
    startsAt,
    expiresAt,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PromotionEntry &&
          other.id == this.id &&
          other.title == this.title &&
          other.subtitle == this.subtitle &&
          other.actionText == this.actionText &&
          other.imageUrlsJson == this.imageUrlsJson &&
          other.priority == this.priority &&
          other.isActive == this.isActive &&
          other.startsAt == this.startsAt &&
          other.expiresAt == this.expiresAt &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PromotionsTableCompanion extends UpdateCompanion<PromotionEntry> {
  final Value<String> id;
  final Value<String> title;
  final Value<String?> subtitle;
  final Value<String?> actionText;
  final Value<String> imageUrlsJson;
  final Value<int> priority;
  final Value<bool> isActive;
  final Value<DateTime?> startsAt;
  final Value<DateTime?> expiresAt;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PromotionsTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.subtitle = const Value.absent(),
    this.actionText = const Value.absent(),
    this.imageUrlsJson = const Value.absent(),
    this.priority = const Value.absent(),
    this.isActive = const Value.absent(),
    this.startsAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PromotionsTableCompanion.insert({
    required String id,
    required String title,
    this.subtitle = const Value.absent(),
    this.actionText = const Value.absent(),
    this.imageUrlsJson = const Value.absent(),
    this.priority = const Value.absent(),
    this.isActive = const Value.absent(),
    this.startsAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title);
  static Insertable<PromotionEntry> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? subtitle,
    Expression<String>? actionText,
    Expression<String>? imageUrlsJson,
    Expression<int>? priority,
    Expression<bool>? isActive,
    Expression<DateTime>? startsAt,
    Expression<DateTime>? expiresAt,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (subtitle != null) 'subtitle': subtitle,
      if (actionText != null) 'action_text': actionText,
      if (imageUrlsJson != null) 'image_urls_json': imageUrlsJson,
      if (priority != null) 'priority': priority,
      if (isActive != null) 'is_active': isActive,
      if (startsAt != null) 'starts_at': startsAt,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PromotionsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String?>? subtitle,
    Value<String?>? actionText,
    Value<String>? imageUrlsJson,
    Value<int>? priority,
    Value<bool>? isActive,
    Value<DateTime?>? startsAt,
    Value<DateTime?>? expiresAt,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PromotionsTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      actionText: actionText ?? this.actionText,
      imageUrlsJson: imageUrlsJson ?? this.imageUrlsJson,
      priority: priority ?? this.priority,
      isActive: isActive ?? this.isActive,
      startsAt: startsAt ?? this.startsAt,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (subtitle.present) {
      map['subtitle'] = Variable<String>(subtitle.value);
    }
    if (actionText.present) {
      map['action_text'] = Variable<String>(actionText.value);
    }
    if (imageUrlsJson.present) {
      map['image_urls_json'] = Variable<String>(imageUrlsJson.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (startsAt.present) {
      map['starts_at'] = Variable<DateTime>(startsAt.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PromotionsTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('subtitle: $subtitle, ')
          ..write('actionText: $actionText, ')
          ..write('imageUrlsJson: $imageUrlsJson, ')
          ..write('priority: $priority, ')
          ..write('isActive: $isActive, ')
          ..write('startsAt: $startsAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TradingTermsTableTable extends TradingTermsTable
    with TableInfo<$TradingTermsTableTable, TradingTermsEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TradingTermsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _moqMeta = const VerificationMeta('moq');
  @override
  late final GeneratedColumn<String> moq = GeneratedColumn<String>(
    'moq',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _warrantyMeta = const VerificationMeta(
    'warranty',
  );
  @override
  late final GeneratedColumn<String> warranty = GeneratedColumn<String>(
    'warranty',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _paymentTermsMeta = const VerificationMeta(
    'paymentTerms',
  );
  @override
  late final GeneratedColumn<String> paymentTerms = GeneratedColumn<String>(
    'payment_terms',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deliveryTermsMeta = const VerificationMeta(
    'deliveryTerms',
  );
  @override
  late final GeneratedColumn<String> deliveryTerms = GeneratedColumn<String>(
    'delivery_terms',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    content,
    moq,
    warranty,
    paymentTerms,
    deliveryTerms,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trading_terms_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TradingTermsEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('moq')) {
      context.handle(
        _moqMeta,
        moq.isAcceptableOrUnknown(data['moq']!, _moqMeta),
      );
    }
    if (data.containsKey('warranty')) {
      context.handle(
        _warrantyMeta,
        warranty.isAcceptableOrUnknown(data['warranty']!, _warrantyMeta),
      );
    }
    if (data.containsKey('payment_terms')) {
      context.handle(
        _paymentTermsMeta,
        paymentTerms.isAcceptableOrUnknown(
          data['payment_terms']!,
          _paymentTermsMeta,
        ),
      );
    }
    if (data.containsKey('delivery_terms')) {
      context.handle(
        _deliveryTermsMeta,
        deliveryTerms.isAcceptableOrUnknown(
          data['delivery_terms']!,
          _deliveryTermsMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TradingTermsEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TradingTermsEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      moq: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}moq'],
      ),
      warranty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}warranty'],
      ),
      paymentTerms: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_terms'],
      ),
      deliveryTerms: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}delivery_terms'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TradingTermsTableTable createAlias(String alias) {
    return $TradingTermsTableTable(attachedDatabase, alias);
  }
}

class TradingTermsEntry extends DataClass
    implements Insertable<TradingTermsEntry> {
  final String id;
  final String content;
  final String? moq;
  final String? warranty;
  final String? paymentTerms;
  final String? deliveryTerms;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TradingTermsEntry({
    required this.id,
    required this.content,
    this.moq,
    this.warranty,
    this.paymentTerms,
    this.deliveryTerms,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || moq != null) {
      map['moq'] = Variable<String>(moq);
    }
    if (!nullToAbsent || warranty != null) {
      map['warranty'] = Variable<String>(warranty);
    }
    if (!nullToAbsent || paymentTerms != null) {
      map['payment_terms'] = Variable<String>(paymentTerms);
    }
    if (!nullToAbsent || deliveryTerms != null) {
      map['delivery_terms'] = Variable<String>(deliveryTerms);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TradingTermsTableCompanion toCompanion(bool nullToAbsent) {
    return TradingTermsTableCompanion(
      id: Value(id),
      content: Value(content),
      moq: moq == null && nullToAbsent ? const Value.absent() : Value(moq),
      warranty: warranty == null && nullToAbsent
          ? const Value.absent()
          : Value(warranty),
      paymentTerms: paymentTerms == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentTerms),
      deliveryTerms: deliveryTerms == null && nullToAbsent
          ? const Value.absent()
          : Value(deliveryTerms),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TradingTermsEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TradingTermsEntry(
      id: serializer.fromJson<String>(json['id']),
      content: serializer.fromJson<String>(json['content']),
      moq: serializer.fromJson<String?>(json['moq']),
      warranty: serializer.fromJson<String?>(json['warranty']),
      paymentTerms: serializer.fromJson<String?>(json['paymentTerms']),
      deliveryTerms: serializer.fromJson<String?>(json['deliveryTerms']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'content': serializer.toJson<String>(content),
      'moq': serializer.toJson<String?>(moq),
      'warranty': serializer.toJson<String?>(warranty),
      'paymentTerms': serializer.toJson<String?>(paymentTerms),
      'deliveryTerms': serializer.toJson<String?>(deliveryTerms),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TradingTermsEntry copyWith({
    String? id,
    String? content,
    Value<String?> moq = const Value.absent(),
    Value<String?> warranty = const Value.absent(),
    Value<String?> paymentTerms = const Value.absent(),
    Value<String?> deliveryTerms = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TradingTermsEntry(
    id: id ?? this.id,
    content: content ?? this.content,
    moq: moq.present ? moq.value : this.moq,
    warranty: warranty.present ? warranty.value : this.warranty,
    paymentTerms: paymentTerms.present ? paymentTerms.value : this.paymentTerms,
    deliveryTerms: deliveryTerms.present
        ? deliveryTerms.value
        : this.deliveryTerms,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TradingTermsEntry copyWithCompanion(TradingTermsTableCompanion data) {
    return TradingTermsEntry(
      id: data.id.present ? data.id.value : this.id,
      content: data.content.present ? data.content.value : this.content,
      moq: data.moq.present ? data.moq.value : this.moq,
      warranty: data.warranty.present ? data.warranty.value : this.warranty,
      paymentTerms: data.paymentTerms.present
          ? data.paymentTerms.value
          : this.paymentTerms,
      deliveryTerms: data.deliveryTerms.present
          ? data.deliveryTerms.value
          : this.deliveryTerms,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TradingTermsEntry(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('moq: $moq, ')
          ..write('warranty: $warranty, ')
          ..write('paymentTerms: $paymentTerms, ')
          ..write('deliveryTerms: $deliveryTerms, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    content,
    moq,
    warranty,
    paymentTerms,
    deliveryTerms,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TradingTermsEntry &&
          other.id == this.id &&
          other.content == this.content &&
          other.moq == this.moq &&
          other.warranty == this.warranty &&
          other.paymentTerms == this.paymentTerms &&
          other.deliveryTerms == this.deliveryTerms &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TradingTermsTableCompanion extends UpdateCompanion<TradingTermsEntry> {
  final Value<String> id;
  final Value<String> content;
  final Value<String?> moq;
  final Value<String?> warranty;
  final Value<String?> paymentTerms;
  final Value<String?> deliveryTerms;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TradingTermsTableCompanion({
    this.id = const Value.absent(),
    this.content = const Value.absent(),
    this.moq = const Value.absent(),
    this.warranty = const Value.absent(),
    this.paymentTerms = const Value.absent(),
    this.deliveryTerms = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TradingTermsTableCompanion.insert({
    required String id,
    required String content,
    this.moq = const Value.absent(),
    this.warranty = const Value.absent(),
    this.paymentTerms = const Value.absent(),
    this.deliveryTerms = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       content = Value(content);
  static Insertable<TradingTermsEntry> custom({
    Expression<String>? id,
    Expression<String>? content,
    Expression<String>? moq,
    Expression<String>? warranty,
    Expression<String>? paymentTerms,
    Expression<String>? deliveryTerms,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (content != null) 'content': content,
      if (moq != null) 'moq': moq,
      if (warranty != null) 'warranty': warranty,
      if (paymentTerms != null) 'payment_terms': paymentTerms,
      if (deliveryTerms != null) 'delivery_terms': deliveryTerms,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TradingTermsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? content,
    Value<String?>? moq,
    Value<String?>? warranty,
    Value<String?>? paymentTerms,
    Value<String?>? deliveryTerms,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return TradingTermsTableCompanion(
      id: id ?? this.id,
      content: content ?? this.content,
      moq: moq ?? this.moq,
      warranty: warranty ?? this.warranty,
      paymentTerms: paymentTerms ?? this.paymentTerms,
      deliveryTerms: deliveryTerms ?? this.deliveryTerms,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (moq.present) {
      map['moq'] = Variable<String>(moq.value);
    }
    if (warranty.present) {
      map['warranty'] = Variable<String>(warranty.value);
    }
    if (paymentTerms.present) {
      map['payment_terms'] = Variable<String>(paymentTerms.value);
    }
    if (deliveryTerms.present) {
      map['delivery_terms'] = Variable<String>(deliveryTerms.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TradingTermsTableCompanion(')
          ..write('id: $id, ')
          ..write('content: $content, ')
          ..write('moq: $moq, ')
          ..write('warranty: $warranty, ')
          ..write('paymentTerms: $paymentTerms, ')
          ..write('deliveryTerms: $deliveryTerms, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LegalTermsTableTable extends LegalTermsTable
    with TableInfo<$LegalTermsTableTable, LegalTermEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LegalTermsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentMeta = const VerificationMeta(
    'content',
  );
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
    'content',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, title, content, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'legal_terms_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<LegalTermEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('content')) {
      context.handle(
        _contentMeta,
        content.isAcceptableOrUnknown(data['content']!, _contentMeta),
      );
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LegalTermEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LegalTermEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      content: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LegalTermsTableTable createAlias(String alias) {
    return $LegalTermsTableTable(attachedDatabase, alias);
  }
}

class LegalTermEntry extends DataClass implements Insertable<LegalTermEntry> {
  final String id;
  final String title;
  final String content;
  final DateTime updatedAt;
  const LegalTermEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['content'] = Variable<String>(content);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LegalTermsTableCompanion toCompanion(bool nullToAbsent) {
    return LegalTermsTableCompanion(
      id: Value(id),
      title: Value(title),
      content: Value(content),
      updatedAt: Value(updatedAt),
    );
  }

  factory LegalTermEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LegalTermEntry(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'content': serializer.toJson<String>(content),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LegalTermEntry copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? updatedAt,
  }) => LegalTermEntry(
    id: id ?? this.id,
    title: title ?? this.title,
    content: content ?? this.content,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LegalTermEntry copyWithCompanion(LegalTermsTableCompanion data) {
    return LegalTermEntry(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LegalTermEntry(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, content, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LegalTermEntry &&
          other.id == this.id &&
          other.title == this.title &&
          other.content == this.content &&
          other.updatedAt == this.updatedAt);
}

class LegalTermsTableCompanion extends UpdateCompanion<LegalTermEntry> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> content;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LegalTermsTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LegalTermsTableCompanion.insert({
    required String id,
    required String title,
    required String content,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       content = Value(content);
  static Insertable<LegalTermEntry> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? content,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LegalTermsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? content,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LegalTermsTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LegalTermsTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecordsTableTable extends RecordsTable
    with TableInfo<$RecordsTableTable, RecordEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecordsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _detailJsonMeta = const VerificationMeta(
    'detailJson',
  );
  @override
  late final GeneratedColumn<String> detailJson = GeneratedColumn<String>(
    'detail_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _recordsHistoryJsonMeta =
      const VerificationMeta('recordsHistoryJson');
  @override
  late final GeneratedColumn<String> recordsHistoryJson =
      GeneratedColumn<String>(
        'records_history_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  static const VerificationMeta _dataJsonMeta = const VerificationMeta(
    'dataJson',
  );
  @override
  late final GeneratedColumn<String> dataJson = GeneratedColumn<String>(
    'data_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reminderJsonMeta = const VerificationMeta(
    'reminderJson',
  );
  @override
  late final GeneratedColumn<String> reminderJson = GeneratedColumn<String>(
    'reminder_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    detailJson,
    recordsHistoryJson,
    dataJson,
    reminderJson,
    updatedAt,
    isArchived,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'records_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecordEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('detail_json')) {
      context.handle(
        _detailJsonMeta,
        detailJson.isAcceptableOrUnknown(data['detail_json']!, _detailJsonMeta),
      );
    }
    if (data.containsKey('records_history_json')) {
      context.handle(
        _recordsHistoryJsonMeta,
        recordsHistoryJson.isAcceptableOrUnknown(
          data['records_history_json']!,
          _recordsHistoryJsonMeta,
        ),
      );
    }
    if (data.containsKey('data_json')) {
      context.handle(
        _dataJsonMeta,
        dataJson.isAcceptableOrUnknown(data['data_json']!, _dataJsonMeta),
      );
    }
    if (data.containsKey('reminder_json')) {
      context.handle(
        _reminderJsonMeta,
        reminderJson.isAcceptableOrUnknown(
          data['reminder_json']!,
          _reminderJsonMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecordEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecordEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      detailJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}detail_json'],
      ),
      recordsHistoryJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}records_history_json'],
      )!,
      dataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data_json'],
      ),
      reminderJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reminder_json'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
    );
  }

  @override
  $RecordsTableTable createAlias(String alias) {
    return $RecordsTableTable(attachedDatabase, alias);
  }
}

class RecordEntry extends DataClass implements Insertable<RecordEntry> {
  final String id;
  final String? detailJson;
  final String recordsHistoryJson;
  final String? dataJson;
  final String? reminderJson;
  final DateTime updatedAt;
  final bool isArchived;
  const RecordEntry({
    required this.id,
    this.detailJson,
    required this.recordsHistoryJson,
    this.dataJson,
    this.reminderJson,
    required this.updatedAt,
    required this.isArchived,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || detailJson != null) {
      map['detail_json'] = Variable<String>(detailJson);
    }
    map['records_history_json'] = Variable<String>(recordsHistoryJson);
    if (!nullToAbsent || dataJson != null) {
      map['data_json'] = Variable<String>(dataJson);
    }
    if (!nullToAbsent || reminderJson != null) {
      map['reminder_json'] = Variable<String>(reminderJson);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['is_archived'] = Variable<bool>(isArchived);
    return map;
  }

  RecordsTableCompanion toCompanion(bool nullToAbsent) {
    return RecordsTableCompanion(
      id: Value(id),
      detailJson: detailJson == null && nullToAbsent
          ? const Value.absent()
          : Value(detailJson),
      recordsHistoryJson: Value(recordsHistoryJson),
      dataJson: dataJson == null && nullToAbsent
          ? const Value.absent()
          : Value(dataJson),
      reminderJson: reminderJson == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderJson),
      updatedAt: Value(updatedAt),
      isArchived: Value(isArchived),
    );
  }

  factory RecordEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecordEntry(
      id: serializer.fromJson<String>(json['id']),
      detailJson: serializer.fromJson<String?>(json['detailJson']),
      recordsHistoryJson: serializer.fromJson<String>(
        json['recordsHistoryJson'],
      ),
      dataJson: serializer.fromJson<String?>(json['dataJson']),
      reminderJson: serializer.fromJson<String?>(json['reminderJson']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'detailJson': serializer.toJson<String?>(detailJson),
      'recordsHistoryJson': serializer.toJson<String>(recordsHistoryJson),
      'dataJson': serializer.toJson<String?>(dataJson),
      'reminderJson': serializer.toJson<String?>(reminderJson),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'isArchived': serializer.toJson<bool>(isArchived),
    };
  }

  RecordEntry copyWith({
    String? id,
    Value<String?> detailJson = const Value.absent(),
    String? recordsHistoryJson,
    Value<String?> dataJson = const Value.absent(),
    Value<String?> reminderJson = const Value.absent(),
    DateTime? updatedAt,
    bool? isArchived,
  }) => RecordEntry(
    id: id ?? this.id,
    detailJson: detailJson.present ? detailJson.value : this.detailJson,
    recordsHistoryJson: recordsHistoryJson ?? this.recordsHistoryJson,
    dataJson: dataJson.present ? dataJson.value : this.dataJson,
    reminderJson: reminderJson.present ? reminderJson.value : this.reminderJson,
    updatedAt: updatedAt ?? this.updatedAt,
    isArchived: isArchived ?? this.isArchived,
  );
  RecordEntry copyWithCompanion(RecordsTableCompanion data) {
    return RecordEntry(
      id: data.id.present ? data.id.value : this.id,
      detailJson: data.detailJson.present
          ? data.detailJson.value
          : this.detailJson,
      recordsHistoryJson: data.recordsHistoryJson.present
          ? data.recordsHistoryJson.value
          : this.recordsHistoryJson,
      dataJson: data.dataJson.present ? data.dataJson.value : this.dataJson,
      reminderJson: data.reminderJson.present
          ? data.reminderJson.value
          : this.reminderJson,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecordEntry(')
          ..write('id: $id, ')
          ..write('detailJson: $detailJson, ')
          ..write('recordsHistoryJson: $recordsHistoryJson, ')
          ..write('dataJson: $dataJson, ')
          ..write('reminderJson: $reminderJson, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isArchived: $isArchived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    detailJson,
    recordsHistoryJson,
    dataJson,
    reminderJson,
    updatedAt,
    isArchived,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecordEntry &&
          other.id == this.id &&
          other.detailJson == this.detailJson &&
          other.recordsHistoryJson == this.recordsHistoryJson &&
          other.dataJson == this.dataJson &&
          other.reminderJson == this.reminderJson &&
          other.updatedAt == this.updatedAt &&
          other.isArchived == this.isArchived);
}

class RecordsTableCompanion extends UpdateCompanion<RecordEntry> {
  final Value<String> id;
  final Value<String?> detailJson;
  final Value<String> recordsHistoryJson;
  final Value<String?> dataJson;
  final Value<String?> reminderJson;
  final Value<DateTime> updatedAt;
  final Value<bool> isArchived;
  final Value<int> rowid;
  const RecordsTableCompanion({
    this.id = const Value.absent(),
    this.detailJson = const Value.absent(),
    this.recordsHistoryJson = const Value.absent(),
    this.dataJson = const Value.absent(),
    this.reminderJson = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecordsTableCompanion.insert({
    required String id,
    this.detailJson = const Value.absent(),
    this.recordsHistoryJson = const Value.absent(),
    this.dataJson = const Value.absent(),
    this.reminderJson = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<RecordEntry> custom({
    Expression<String>? id,
    Expression<String>? detailJson,
    Expression<String>? recordsHistoryJson,
    Expression<String>? dataJson,
    Expression<String>? reminderJson,
    Expression<DateTime>? updatedAt,
    Expression<bool>? isArchived,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (detailJson != null) 'detail_json': detailJson,
      if (recordsHistoryJson != null)
        'records_history_json': recordsHistoryJson,
      if (dataJson != null) 'data_json': dataJson,
      if (reminderJson != null) 'reminder_json': reminderJson,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (isArchived != null) 'is_archived': isArchived,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecordsTableCompanion copyWith({
    Value<String>? id,
    Value<String?>? detailJson,
    Value<String>? recordsHistoryJson,
    Value<String?>? dataJson,
    Value<String?>? reminderJson,
    Value<DateTime>? updatedAt,
    Value<bool>? isArchived,
    Value<int>? rowid,
  }) {
    return RecordsTableCompanion(
      id: id ?? this.id,
      detailJson: detailJson ?? this.detailJson,
      recordsHistoryJson: recordsHistoryJson ?? this.recordsHistoryJson,
      dataJson: dataJson ?? this.dataJson,
      reminderJson: reminderJson ?? this.reminderJson,
      updatedAt: updatedAt ?? this.updatedAt,
      isArchived: isArchived ?? this.isArchived,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (detailJson.present) {
      map['detail_json'] = Variable<String>(detailJson.value);
    }
    if (recordsHistoryJson.present) {
      map['records_history_json'] = Variable<String>(recordsHistoryJson.value);
    }
    if (dataJson.present) {
      map['data_json'] = Variable<String>(dataJson.value);
    }
    if (reminderJson.present) {
      map['reminder_json'] = Variable<String>(reminderJson.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecordsTableCompanion(')
          ..write('id: $id, ')
          ..write('detailJson: $detailJson, ')
          ..write('recordsHistoryJson: $recordsHistoryJson, ')
          ..write('dataJson: $dataJson, ')
          ..write('reminderJson: $reminderJson, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('isArchived: $isArchived, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProductsTableTable productsTable = $ProductsTableTable(this);
  late final $CategoriesTableTable categoriesTable = $CategoriesTableTable(
    this,
  );
  late final $PriceTiersTableTable priceTiersTable = $PriceTiersTableTable(
    this,
  );
  late final $BusinessTableTable businessTable = $BusinessTableTable(this);
  late final $UsersTableTable usersTable = $UsersTableTable(this);
  late final $BulkOrdersTableTable bulkOrdersTable = $BulkOrdersTableTable(
    this,
  );
  late final $OrdersTableTable ordersTable = $OrdersTableTable(this);
  late final $GeneratedPdfsTableTable generatedPdfsTable =
      $GeneratedPdfsTableTable(this);
  late final $SearchHistoryTableTable searchHistoryTable =
      $SearchHistoryTableTable(this);
  late final $PromotionsTableTable promotionsTable = $PromotionsTableTable(
    this,
  );
  late final $TradingTermsTableTable tradingTermsTable =
      $TradingTermsTableTable(this);
  late final $LegalTermsTableTable legalTermsTable = $LegalTermsTableTable(
    this,
  );
  late final $RecordsTableTable recordsTable = $RecordsTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    productsTable,
    categoriesTable,
    priceTiersTable,
    businessTable,
    usersTable,
    bulkOrdersTable,
    ordersTable,
    generatedPdfsTable,
    searchHistoryTable,
    promotionsTable,
    tradingTermsTable,
    legalTermsTable,
    recordsTable,
  ];
}

typedef $$ProductsTableTableCreateCompanionBuilder =
    ProductsTableCompanion Function({
      required String id,
      required String sku,
      required String name,
      required String brand,
      required double srp,
      required String priceTiers,
      required String hsCode,
      required double weightKg,
      required double volumeCbm,
      required String originCountry,
      required String unbsNumber,
      required String denier,
      required String material,
      required String supplierId,
      required String supplierJson,
      required String categoryId,
      required int currentStock,
      required int leadTimeDays,
      required String warehouseLoc,
      required String seoTitle,
      required String seoDescription,
      required String searchKeywords,
      required String slug,
      required String imageUrl,
      Value<String?> mediaUrls,
      Value<double> aspectRatio,
      Value<String?> availableColors,
      Value<String?> availableSizes,
      Value<String?> availableMaterials,
      Value<String?> supportJson,
      Value<String?> tradingTermsJson,
      Value<bool> isDirty,
      Value<DateTime?> lastSyncedAt,
      Value<int> rowid,
    });
typedef $$ProductsTableTableUpdateCompanionBuilder =
    ProductsTableCompanion Function({
      Value<String> id,
      Value<String> sku,
      Value<String> name,
      Value<String> brand,
      Value<double> srp,
      Value<String> priceTiers,
      Value<String> hsCode,
      Value<double> weightKg,
      Value<double> volumeCbm,
      Value<String> originCountry,
      Value<String> unbsNumber,
      Value<String> denier,
      Value<String> material,
      Value<String> supplierId,
      Value<String> supplierJson,
      Value<String> categoryId,
      Value<int> currentStock,
      Value<int> leadTimeDays,
      Value<String> warehouseLoc,
      Value<String> seoTitle,
      Value<String> seoDescription,
      Value<String> searchKeywords,
      Value<String> slug,
      Value<String> imageUrl,
      Value<String?> mediaUrls,
      Value<double> aspectRatio,
      Value<String?> availableColors,
      Value<String?> availableSizes,
      Value<String?> availableMaterials,
      Value<String?> supportJson,
      Value<String?> tradingTermsJson,
      Value<bool> isDirty,
      Value<DateTime?> lastSyncedAt,
      Value<int> rowid,
    });

class $$ProductsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTableTable> {
  $$ProductsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sku => $composableBuilder(
    column: $table.sku,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get srp => $composableBuilder(
    column: $table.srp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priceTiers => $composableBuilder(
    column: $table.priceTiers,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hsCode => $composableBuilder(
    column: $table.hsCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get volumeCbm => $composableBuilder(
    column: $table.volumeCbm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originCountry => $composableBuilder(
    column: $table.originCountry,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unbsNumber => $composableBuilder(
    column: $table.unbsNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get denier => $composableBuilder(
    column: $table.denier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get material => $composableBuilder(
    column: $table.material,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supplierJson => $composableBuilder(
    column: $table.supplierJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentStock => $composableBuilder(
    column: $table.currentStock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get leadTimeDays => $composableBuilder(
    column: $table.leadTimeDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get warehouseLoc => $composableBuilder(
    column: $table.warehouseLoc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get seoTitle => $composableBuilder(
    column: $table.seoTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get seoDescription => $composableBuilder(
    column: $table.seoDescription,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get searchKeywords => $composableBuilder(
    column: $table.searchKeywords,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mediaUrls => $composableBuilder(
    column: $table.mediaUrls,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get aspectRatio => $composableBuilder(
    column: $table.aspectRatio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get availableColors => $composableBuilder(
    column: $table.availableColors,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get availableSizes => $composableBuilder(
    column: $table.availableSizes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get availableMaterials => $composableBuilder(
    column: $table.availableMaterials,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supportJson => $composableBuilder(
    column: $table.supportJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tradingTermsJson => $composableBuilder(
    column: $table.tradingTermsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDirty => $composableBuilder(
    column: $table.isDirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProductsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTableTable> {
  $$ProductsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sku => $composableBuilder(
    column: $table.sku,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get srp => $composableBuilder(
    column: $table.srp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priceTiers => $composableBuilder(
    column: $table.priceTiers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hsCode => $composableBuilder(
    column: $table.hsCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get volumeCbm => $composableBuilder(
    column: $table.volumeCbm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originCountry => $composableBuilder(
    column: $table.originCountry,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unbsNumber => $composableBuilder(
    column: $table.unbsNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get denier => $composableBuilder(
    column: $table.denier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get material => $composableBuilder(
    column: $table.material,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supplierJson => $composableBuilder(
    column: $table.supplierJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentStock => $composableBuilder(
    column: $table.currentStock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get leadTimeDays => $composableBuilder(
    column: $table.leadTimeDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get warehouseLoc => $composableBuilder(
    column: $table.warehouseLoc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get seoTitle => $composableBuilder(
    column: $table.seoTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get seoDescription => $composableBuilder(
    column: $table.seoDescription,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get searchKeywords => $composableBuilder(
    column: $table.searchKeywords,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mediaUrls => $composableBuilder(
    column: $table.mediaUrls,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get aspectRatio => $composableBuilder(
    column: $table.aspectRatio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get availableColors => $composableBuilder(
    column: $table.availableColors,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get availableSizes => $composableBuilder(
    column: $table.availableSizes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get availableMaterials => $composableBuilder(
    column: $table.availableMaterials,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supportJson => $composableBuilder(
    column: $table.supportJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tradingTermsJson => $composableBuilder(
    column: $table.tradingTermsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDirty => $composableBuilder(
    column: $table.isDirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTableTable> {
  $$ProductsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sku =>
      $composableBuilder(column: $table.sku, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<double> get srp =>
      $composableBuilder(column: $table.srp, builder: (column) => column);

  GeneratedColumn<String> get priceTiers => $composableBuilder(
    column: $table.priceTiers,
    builder: (column) => column,
  );

  GeneratedColumn<String> get hsCode =>
      $composableBuilder(column: $table.hsCode, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<double> get volumeCbm =>
      $composableBuilder(column: $table.volumeCbm, builder: (column) => column);

  GeneratedColumn<String> get originCountry => $composableBuilder(
    column: $table.originCountry,
    builder: (column) => column,
  );

  GeneratedColumn<String> get unbsNumber => $composableBuilder(
    column: $table.unbsNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get denier =>
      $composableBuilder(column: $table.denier, builder: (column) => column);

  GeneratedColumn<String> get material =>
      $composableBuilder(column: $table.material, builder: (column) => column);

  GeneratedColumn<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get supplierJson => $composableBuilder(
    column: $table.supplierJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentStock => $composableBuilder(
    column: $table.currentStock,
    builder: (column) => column,
  );

  GeneratedColumn<int> get leadTimeDays => $composableBuilder(
    column: $table.leadTimeDays,
    builder: (column) => column,
  );

  GeneratedColumn<String> get warehouseLoc => $composableBuilder(
    column: $table.warehouseLoc,
    builder: (column) => column,
  );

  GeneratedColumn<String> get seoTitle =>
      $composableBuilder(column: $table.seoTitle, builder: (column) => column);

  GeneratedColumn<String> get seoDescription => $composableBuilder(
    column: $table.seoDescription,
    builder: (column) => column,
  );

  GeneratedColumn<String> get searchKeywords => $composableBuilder(
    column: $table.searchKeywords,
    builder: (column) => column,
  );

  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get mediaUrls =>
      $composableBuilder(column: $table.mediaUrls, builder: (column) => column);

  GeneratedColumn<double> get aspectRatio => $composableBuilder(
    column: $table.aspectRatio,
    builder: (column) => column,
  );

  GeneratedColumn<String> get availableColors => $composableBuilder(
    column: $table.availableColors,
    builder: (column) => column,
  );

  GeneratedColumn<String> get availableSizes => $composableBuilder(
    column: $table.availableSizes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get availableMaterials => $composableBuilder(
    column: $table.availableMaterials,
    builder: (column) => column,
  );

  GeneratedColumn<String> get supportJson => $composableBuilder(
    column: $table.supportJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tradingTermsJson => $composableBuilder(
    column: $table.tradingTermsJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDirty =>
      $composableBuilder(column: $table.isDirty, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );
}

class $$ProductsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTableTable,
          ProductEntry,
          $$ProductsTableTableFilterComposer,
          $$ProductsTableTableOrderingComposer,
          $$ProductsTableTableAnnotationComposer,
          $$ProductsTableTableCreateCompanionBuilder,
          $$ProductsTableTableUpdateCompanionBuilder,
          (
            ProductEntry,
            BaseReferences<_$AppDatabase, $ProductsTableTable, ProductEntry>,
          ),
          ProductEntry,
          PrefetchHooks Function()
        > {
  $$ProductsTableTableTableManager(_$AppDatabase db, $ProductsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sku = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> brand = const Value.absent(),
                Value<double> srp = const Value.absent(),
                Value<String> priceTiers = const Value.absent(),
                Value<String> hsCode = const Value.absent(),
                Value<double> weightKg = const Value.absent(),
                Value<double> volumeCbm = const Value.absent(),
                Value<String> originCountry = const Value.absent(),
                Value<String> unbsNumber = const Value.absent(),
                Value<String> denier = const Value.absent(),
                Value<String> material = const Value.absent(),
                Value<String> supplierId = const Value.absent(),
                Value<String> supplierJson = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<int> currentStock = const Value.absent(),
                Value<int> leadTimeDays = const Value.absent(),
                Value<String> warehouseLoc = const Value.absent(),
                Value<String> seoTitle = const Value.absent(),
                Value<String> seoDescription = const Value.absent(),
                Value<String> searchKeywords = const Value.absent(),
                Value<String> slug = const Value.absent(),
                Value<String> imageUrl = const Value.absent(),
                Value<String?> mediaUrls = const Value.absent(),
                Value<double> aspectRatio = const Value.absent(),
                Value<String?> availableColors = const Value.absent(),
                Value<String?> availableSizes = const Value.absent(),
                Value<String?> availableMaterials = const Value.absent(),
                Value<String?> supportJson = const Value.absent(),
                Value<String?> tradingTermsJson = const Value.absent(),
                Value<bool> isDirty = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsTableCompanion(
                id: id,
                sku: sku,
                name: name,
                brand: brand,
                srp: srp,
                priceTiers: priceTiers,
                hsCode: hsCode,
                weightKg: weightKg,
                volumeCbm: volumeCbm,
                originCountry: originCountry,
                unbsNumber: unbsNumber,
                denier: denier,
                material: material,
                supplierId: supplierId,
                supplierJson: supplierJson,
                categoryId: categoryId,
                currentStock: currentStock,
                leadTimeDays: leadTimeDays,
                warehouseLoc: warehouseLoc,
                seoTitle: seoTitle,
                seoDescription: seoDescription,
                searchKeywords: searchKeywords,
                slug: slug,
                imageUrl: imageUrl,
                mediaUrls: mediaUrls,
                aspectRatio: aspectRatio,
                availableColors: availableColors,
                availableSizes: availableSizes,
                availableMaterials: availableMaterials,
                supportJson: supportJson,
                tradingTermsJson: tradingTermsJson,
                isDirty: isDirty,
                lastSyncedAt: lastSyncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sku,
                required String name,
                required String brand,
                required double srp,
                required String priceTiers,
                required String hsCode,
                required double weightKg,
                required double volumeCbm,
                required String originCountry,
                required String unbsNumber,
                required String denier,
                required String material,
                required String supplierId,
                required String supplierJson,
                required String categoryId,
                required int currentStock,
                required int leadTimeDays,
                required String warehouseLoc,
                required String seoTitle,
                required String seoDescription,
                required String searchKeywords,
                required String slug,
                required String imageUrl,
                Value<String?> mediaUrls = const Value.absent(),
                Value<double> aspectRatio = const Value.absent(),
                Value<String?> availableColors = const Value.absent(),
                Value<String?> availableSizes = const Value.absent(),
                Value<String?> availableMaterials = const Value.absent(),
                Value<String?> supportJson = const Value.absent(),
                Value<String?> tradingTermsJson = const Value.absent(),
                Value<bool> isDirty = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsTableCompanion.insert(
                id: id,
                sku: sku,
                name: name,
                brand: brand,
                srp: srp,
                priceTiers: priceTiers,
                hsCode: hsCode,
                weightKg: weightKg,
                volumeCbm: volumeCbm,
                originCountry: originCountry,
                unbsNumber: unbsNumber,
                denier: denier,
                material: material,
                supplierId: supplierId,
                supplierJson: supplierJson,
                categoryId: categoryId,
                currentStock: currentStock,
                leadTimeDays: leadTimeDays,
                warehouseLoc: warehouseLoc,
                seoTitle: seoTitle,
                seoDescription: seoDescription,
                searchKeywords: searchKeywords,
                slug: slug,
                imageUrl: imageUrl,
                mediaUrls: mediaUrls,
                aspectRatio: aspectRatio,
                availableColors: availableColors,
                availableSizes: availableSizes,
                availableMaterials: availableMaterials,
                supportJson: supportJson,
                tradingTermsJson: tradingTermsJson,
                isDirty: isDirty,
                lastSyncedAt: lastSyncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProductsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTableTable,
      ProductEntry,
      $$ProductsTableTableFilterComposer,
      $$ProductsTableTableOrderingComposer,
      $$ProductsTableTableAnnotationComposer,
      $$ProductsTableTableCreateCompanionBuilder,
      $$ProductsTableTableUpdateCompanionBuilder,
      (
        ProductEntry,
        BaseReferences<_$AppDatabase, $ProductsTableTable, ProductEntry>,
      ),
      ProductEntry,
      PrefetchHooks Function()
    >;
typedef $$CategoriesTableTableCreateCompanionBuilder =
    CategoriesTableCompanion Function({
      required String id,
      required String name,
      Value<String?> parentId,
      Value<int> level,
      Value<String?> imageUrl,
      Value<int> itemCount,
      Value<int> priority,
      Value<int> usageCount,
      Value<bool> isDirty,
      Value<DateTime?> lastSyncedAt,
      Value<int> rowid,
    });
typedef $$CategoriesTableTableUpdateCompanionBuilder =
    CategoriesTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> parentId,
      Value<int> level,
      Value<String?> imageUrl,
      Value<int> itemCount,
      Value<int> priority,
      Value<int> usageCount,
      Value<bool> isDirty,
      Value<DateTime?> lastSyncedAt,
      Value<int> rowid,
    });

class $$CategoriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get itemCount => $composableBuilder(
    column: $table.itemCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get usageCount => $composableBuilder(
    column: $table.usageCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDirty => $composableBuilder(
    column: $table.isDirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CategoriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get itemCount => $composableBuilder(
    column: $table.itemCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get usageCount => $composableBuilder(
    column: $table.usageCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDirty => $composableBuilder(
    column: $table.isDirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<int> get itemCount =>
      $composableBuilder(column: $table.itemCount, builder: (column) => column);

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<int> get usageCount => $composableBuilder(
    column: $table.usageCount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDirty =>
      $composableBuilder(column: $table.isDirty, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );
}

class $$CategoriesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTableTable,
          CategoryEntry,
          $$CategoriesTableTableFilterComposer,
          $$CategoriesTableTableOrderingComposer,
          $$CategoriesTableTableAnnotationComposer,
          $$CategoriesTableTableCreateCompanionBuilder,
          $$CategoriesTableTableUpdateCompanionBuilder,
          (
            CategoryEntry,
            BaseReferences<_$AppDatabase, $CategoriesTableTable, CategoryEntry>,
          ),
          CategoryEntry,
          PrefetchHooks Function()
        > {
  $$CategoriesTableTableTableManager(
    _$AppDatabase db,
    $CategoriesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<int> itemCount = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<int> usageCount = const Value.absent(),
                Value<bool> isDirty = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesTableCompanion(
                id: id,
                name: name,
                parentId: parentId,
                level: level,
                imageUrl: imageUrl,
                itemCount: itemCount,
                priority: priority,
                usageCount: usageCount,
                isDirty: isDirty,
                lastSyncedAt: lastSyncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> parentId = const Value.absent(),
                Value<int> level = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<int> itemCount = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<int> usageCount = const Value.absent(),
                Value<bool> isDirty = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesTableCompanion.insert(
                id: id,
                name: name,
                parentId: parentId,
                level: level,
                imageUrl: imageUrl,
                itemCount: itemCount,
                priority: priority,
                usageCount: usageCount,
                isDirty: isDirty,
                lastSyncedAt: lastSyncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CategoriesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTableTable,
      CategoryEntry,
      $$CategoriesTableTableFilterComposer,
      $$CategoriesTableTableOrderingComposer,
      $$CategoriesTableTableAnnotationComposer,
      $$CategoriesTableTableCreateCompanionBuilder,
      $$CategoriesTableTableUpdateCompanionBuilder,
      (
        CategoryEntry,
        BaseReferences<_$AppDatabase, $CategoriesTableTable, CategoryEntry>,
      ),
      CategoryEntry,
      PrefetchHooks Function()
    >;
typedef $$PriceTiersTableTableCreateCompanionBuilder =
    PriceTiersTableCompanion Function({
      Value<int> id,
      required String productId,
      required int quantity,
      required double price,
    });
typedef $$PriceTiersTableTableUpdateCompanionBuilder =
    PriceTiersTableCompanion Function({
      Value<int> id,
      Value<String> productId,
      Value<int> quantity,
      Value<double> price,
    });

class $$PriceTiersTableTableFilterComposer
    extends Composer<_$AppDatabase, $PriceTiersTableTable> {
  $$PriceTiersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PriceTiersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PriceTiersTableTable> {
  $$PriceTiersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PriceTiersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PriceTiersTableTable> {
  $$PriceTiersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);
}

class $$PriceTiersTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PriceTiersTableTable,
          PriceTierEntry,
          $$PriceTiersTableTableFilterComposer,
          $$PriceTiersTableTableOrderingComposer,
          $$PriceTiersTableTableAnnotationComposer,
          $$PriceTiersTableTableCreateCompanionBuilder,
          $$PriceTiersTableTableUpdateCompanionBuilder,
          (
            PriceTierEntry,
            BaseReferences<
              _$AppDatabase,
              $PriceTiersTableTable,
              PriceTierEntry
            >,
          ),
          PriceTierEntry,
          PrefetchHooks Function()
        > {
  $$PriceTiersTableTableTableManager(
    _$AppDatabase db,
    $PriceTiersTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PriceTiersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PriceTiersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PriceTiersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<double> price = const Value.absent(),
              }) => PriceTiersTableCompanion(
                id: id,
                productId: productId,
                quantity: quantity,
                price: price,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String productId,
                required int quantity,
                required double price,
              }) => PriceTiersTableCompanion.insert(
                id: id,
                productId: productId,
                quantity: quantity,
                price: price,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PriceTiersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PriceTiersTableTable,
      PriceTierEntry,
      $$PriceTiersTableTableFilterComposer,
      $$PriceTiersTableTableOrderingComposer,
      $$PriceTiersTableTableAnnotationComposer,
      $$PriceTiersTableTableCreateCompanionBuilder,
      $$PriceTiersTableTableUpdateCompanionBuilder,
      (
        PriceTierEntry,
        BaseReferences<_$AppDatabase, $PriceTiersTableTable, PriceTierEntry>,
      ),
      PriceTierEntry,
      PrefetchHooks Function()
    >;
typedef $$BusinessTableTableCreateCompanionBuilder =
    BusinessTableCompanion Function({
      required String id,
      required String legalName,
      Value<String?> phoneNumber,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<String?> region,
      Value<String?> city,
      Value<String?> physicalAddress,
      Value<DateTime?> updatedAt,
      Value<bool> isDirty,
      Value<DateTime?> lastSyncedAt,
      Value<int> rowid,
    });
typedef $$BusinessTableTableUpdateCompanionBuilder =
    BusinessTableCompanion Function({
      Value<String> id,
      Value<String> legalName,
      Value<String?> phoneNumber,
      Value<double?> latitude,
      Value<double?> longitude,
      Value<String?> region,
      Value<String?> city,
      Value<String?> physicalAddress,
      Value<DateTime?> updatedAt,
      Value<bool> isDirty,
      Value<DateTime?> lastSyncedAt,
      Value<int> rowid,
    });

class $$BusinessTableTableFilterComposer
    extends Composer<_$AppDatabase, $BusinessTableTable> {
  $$BusinessTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get legalName => $composableBuilder(
    column: $table.legalName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get region => $composableBuilder(
    column: $table.region,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get physicalAddress => $composableBuilder(
    column: $table.physicalAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDirty => $composableBuilder(
    column: $table.isDirty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BusinessTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BusinessTableTable> {
  $$BusinessTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get legalName => $composableBuilder(
    column: $table.legalName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get region => $composableBuilder(
    column: $table.region,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get physicalAddress => $composableBuilder(
    column: $table.physicalAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDirty => $composableBuilder(
    column: $table.isDirty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BusinessTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BusinessTableTable> {
  $$BusinessTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get legalName =>
      $composableBuilder(column: $table.legalName, builder: (column) => column);

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => column,
  );

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get region =>
      $composableBuilder(column: $table.region, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get physicalAddress => $composableBuilder(
    column: $table.physicalAddress,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isDirty =>
      $composableBuilder(column: $table.isDirty, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );
}

class $$BusinessTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BusinessTableTable,
          BusinessEntry,
          $$BusinessTableTableFilterComposer,
          $$BusinessTableTableOrderingComposer,
          $$BusinessTableTableAnnotationComposer,
          $$BusinessTableTableCreateCompanionBuilder,
          $$BusinessTableTableUpdateCompanionBuilder,
          (
            BusinessEntry,
            BaseReferences<_$AppDatabase, $BusinessTableTable, BusinessEntry>,
          ),
          BusinessEntry,
          PrefetchHooks Function()
        > {
  $$BusinessTableTableTableManager(_$AppDatabase db, $BusinessTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BusinessTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BusinessTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BusinessTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> legalName = const Value.absent(),
                Value<String?> phoneNumber = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<String?> region = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<String?> physicalAddress = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<bool> isDirty = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BusinessTableCompanion(
                id: id,
                legalName: legalName,
                phoneNumber: phoneNumber,
                latitude: latitude,
                longitude: longitude,
                region: region,
                city: city,
                physicalAddress: physicalAddress,
                updatedAt: updatedAt,
                isDirty: isDirty,
                lastSyncedAt: lastSyncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String legalName,
                Value<String?> phoneNumber = const Value.absent(),
                Value<double?> latitude = const Value.absent(),
                Value<double?> longitude = const Value.absent(),
                Value<String?> region = const Value.absent(),
                Value<String?> city = const Value.absent(),
                Value<String?> physicalAddress = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
                Value<bool> isDirty = const Value.absent(),
                Value<DateTime?> lastSyncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BusinessTableCompanion.insert(
                id: id,
                legalName: legalName,
                phoneNumber: phoneNumber,
                latitude: latitude,
                longitude: longitude,
                region: region,
                city: city,
                physicalAddress: physicalAddress,
                updatedAt: updatedAt,
                isDirty: isDirty,
                lastSyncedAt: lastSyncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BusinessTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BusinessTableTable,
      BusinessEntry,
      $$BusinessTableTableFilterComposer,
      $$BusinessTableTableOrderingComposer,
      $$BusinessTableTableAnnotationComposer,
      $$BusinessTableTableCreateCompanionBuilder,
      $$BusinessTableTableUpdateCompanionBuilder,
      (
        BusinessEntry,
        BaseReferences<_$AppDatabase, $BusinessTableTable, BusinessEntry>,
      ),
      BusinessEntry,
      PrefetchHooks Function()
    >;
typedef $$UsersTableTableCreateCompanionBuilder =
    UsersTableCompanion Function({
      required String id,
      required String fullName,
      Value<String?> email,
      Value<String> role,
      Value<String?> profilePicUrl,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$UsersTableTableUpdateCompanionBuilder =
    UsersTableCompanion Function({
      Value<String> id,
      Value<String> fullName,
      Value<String?> email,
      Value<String> role,
      Value<String?> profilePicUrl,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$UsersTableTableFilterComposer
    extends Composer<_$AppDatabase, $UsersTableTable> {
  $$UsersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profilePicUrl => $composableBuilder(
    column: $table.profilePicUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTableTable> {
  $$UsersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profilePicUrl => $composableBuilder(
    column: $table.profilePicUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTableTable> {
  $$UsersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get profilePicUrl => $composableBuilder(
    column: $table.profilePicUrl,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UsersTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTableTable,
          UserEntry,
          $$UsersTableTableFilterComposer,
          $$UsersTableTableOrderingComposer,
          $$UsersTableTableAnnotationComposer,
          $$UsersTableTableCreateCompanionBuilder,
          $$UsersTableTableUpdateCompanionBuilder,
          (
            UserEntry,
            BaseReferences<_$AppDatabase, $UsersTableTable, UserEntry>,
          ),
          UserEntry,
          PrefetchHooks Function()
        > {
  $$UsersTableTableTableManager(_$AppDatabase db, $UsersTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String?> profilePicUrl = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersTableCompanion(
                id: id,
                fullName: fullName,
                email: email,
                role: role,
                profilePicUrl: profilePicUrl,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String fullName,
                Value<String?> email = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String?> profilePicUrl = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersTableCompanion.insert(
                id: id,
                fullName: fullName,
                email: email,
                role: role,
                profilePicUrl: profilePicUrl,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTableTable,
      UserEntry,
      $$UsersTableTableFilterComposer,
      $$UsersTableTableOrderingComposer,
      $$UsersTableTableAnnotationComposer,
      $$UsersTableTableCreateCompanionBuilder,
      $$UsersTableTableUpdateCompanionBuilder,
      (UserEntry, BaseReferences<_$AppDatabase, $UsersTableTable, UserEntry>),
      UserEntry,
      PrefetchHooks Function()
    >;
typedef $$BulkOrdersTableTableCreateCompanionBuilder =
    BulkOrdersTableCompanion Function({
      required String id,
      Value<String?> groupName,
      required String productName,
      Value<String?> brand,
      required String category,
      required String subCategory,
      Value<String?> imageUrl,
      Value<String?> availableColorsJson,
      Value<String?> availableSizesJson,
      required String variantLabel,
      required String configJson,
      required int totalUnits,
      Value<double> srp,
      Value<String?> priceTiersJson,
      Value<String?> availableMaterialsJson,
      Value<int> currentStock,
      Value<int> leadTimeDays,
      Value<String?> seoDescription,
      Value<String?> tradingTermsJson,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$BulkOrdersTableTableUpdateCompanionBuilder =
    BulkOrdersTableCompanion Function({
      Value<String> id,
      Value<String?> groupName,
      Value<String> productName,
      Value<String?> brand,
      Value<String> category,
      Value<String> subCategory,
      Value<String?> imageUrl,
      Value<String?> availableColorsJson,
      Value<String?> availableSizesJson,
      Value<String> variantLabel,
      Value<String> configJson,
      Value<int> totalUnits,
      Value<double> srp,
      Value<String?> priceTiersJson,
      Value<String?> availableMaterialsJson,
      Value<int> currentStock,
      Value<int> leadTimeDays,
      Value<String?> seoDescription,
      Value<String?> tradingTermsJson,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$BulkOrdersTableTableFilterComposer
    extends Composer<_$AppDatabase, $BulkOrdersTableTable> {
  $$BulkOrdersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get groupName => $composableBuilder(
    column: $table.groupName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subCategory => $composableBuilder(
    column: $table.subCategory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get availableColorsJson => $composableBuilder(
    column: $table.availableColorsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get availableSizesJson => $composableBuilder(
    column: $table.availableSizesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get variantLabel => $composableBuilder(
    column: $table.variantLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get configJson => $composableBuilder(
    column: $table.configJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalUnits => $composableBuilder(
    column: $table.totalUnits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get srp => $composableBuilder(
    column: $table.srp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priceTiersJson => $composableBuilder(
    column: $table.priceTiersJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get availableMaterialsJson => $composableBuilder(
    column: $table.availableMaterialsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentStock => $composableBuilder(
    column: $table.currentStock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get leadTimeDays => $composableBuilder(
    column: $table.leadTimeDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get seoDescription => $composableBuilder(
    column: $table.seoDescription,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tradingTermsJson => $composableBuilder(
    column: $table.tradingTermsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BulkOrdersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BulkOrdersTableTable> {
  $$BulkOrdersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get groupName => $composableBuilder(
    column: $table.groupName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subCategory => $composableBuilder(
    column: $table.subCategory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get availableColorsJson => $composableBuilder(
    column: $table.availableColorsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get availableSizesJson => $composableBuilder(
    column: $table.availableSizesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get variantLabel => $composableBuilder(
    column: $table.variantLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get configJson => $composableBuilder(
    column: $table.configJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalUnits => $composableBuilder(
    column: $table.totalUnits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get srp => $composableBuilder(
    column: $table.srp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priceTiersJson => $composableBuilder(
    column: $table.priceTiersJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get availableMaterialsJson => $composableBuilder(
    column: $table.availableMaterialsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentStock => $composableBuilder(
    column: $table.currentStock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get leadTimeDays => $composableBuilder(
    column: $table.leadTimeDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get seoDescription => $composableBuilder(
    column: $table.seoDescription,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tradingTermsJson => $composableBuilder(
    column: $table.tradingTermsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BulkOrdersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BulkOrdersTableTable> {
  $$BulkOrdersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get groupName =>
      $composableBuilder(column: $table.groupName, builder: (column) => column);

  GeneratedColumn<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get subCategory => $composableBuilder(
    column: $table.subCategory,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get availableColorsJson => $composableBuilder(
    column: $table.availableColorsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get availableSizesJson => $composableBuilder(
    column: $table.availableSizesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get variantLabel => $composableBuilder(
    column: $table.variantLabel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get configJson => $composableBuilder(
    column: $table.configJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalUnits => $composableBuilder(
    column: $table.totalUnits,
    builder: (column) => column,
  );

  GeneratedColumn<double> get srp =>
      $composableBuilder(column: $table.srp, builder: (column) => column);

  GeneratedColumn<String> get priceTiersJson => $composableBuilder(
    column: $table.priceTiersJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get availableMaterialsJson => $composableBuilder(
    column: $table.availableMaterialsJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentStock => $composableBuilder(
    column: $table.currentStock,
    builder: (column) => column,
  );

  GeneratedColumn<int> get leadTimeDays => $composableBuilder(
    column: $table.leadTimeDays,
    builder: (column) => column,
  );

  GeneratedColumn<String> get seoDescription => $composableBuilder(
    column: $table.seoDescription,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tradingTermsJson => $composableBuilder(
    column: $table.tradingTermsJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$BulkOrdersTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BulkOrdersTableTable,
          BulkOrderEntry,
          $$BulkOrdersTableTableFilterComposer,
          $$BulkOrdersTableTableOrderingComposer,
          $$BulkOrdersTableTableAnnotationComposer,
          $$BulkOrdersTableTableCreateCompanionBuilder,
          $$BulkOrdersTableTableUpdateCompanionBuilder,
          (
            BulkOrderEntry,
            BaseReferences<
              _$AppDatabase,
              $BulkOrdersTableTable,
              BulkOrderEntry
            >,
          ),
          BulkOrderEntry,
          PrefetchHooks Function()
        > {
  $$BulkOrdersTableTableTableManager(
    _$AppDatabase db,
    $BulkOrdersTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BulkOrdersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BulkOrdersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BulkOrdersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> groupName = const Value.absent(),
                Value<String> productName = const Value.absent(),
                Value<String?> brand = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> subCategory = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<String?> availableColorsJson = const Value.absent(),
                Value<String?> availableSizesJson = const Value.absent(),
                Value<String> variantLabel = const Value.absent(),
                Value<String> configJson = const Value.absent(),
                Value<int> totalUnits = const Value.absent(),
                Value<double> srp = const Value.absent(),
                Value<String?> priceTiersJson = const Value.absent(),
                Value<String?> availableMaterialsJson = const Value.absent(),
                Value<int> currentStock = const Value.absent(),
                Value<int> leadTimeDays = const Value.absent(),
                Value<String?> seoDescription = const Value.absent(),
                Value<String?> tradingTermsJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BulkOrdersTableCompanion(
                id: id,
                groupName: groupName,
                productName: productName,
                brand: brand,
                category: category,
                subCategory: subCategory,
                imageUrl: imageUrl,
                availableColorsJson: availableColorsJson,
                availableSizesJson: availableSizesJson,
                variantLabel: variantLabel,
                configJson: configJson,
                totalUnits: totalUnits,
                srp: srp,
                priceTiersJson: priceTiersJson,
                availableMaterialsJson: availableMaterialsJson,
                currentStock: currentStock,
                leadTimeDays: leadTimeDays,
                seoDescription: seoDescription,
                tradingTermsJson: tradingTermsJson,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> groupName = const Value.absent(),
                required String productName,
                Value<String?> brand = const Value.absent(),
                required String category,
                required String subCategory,
                Value<String?> imageUrl = const Value.absent(),
                Value<String?> availableColorsJson = const Value.absent(),
                Value<String?> availableSizesJson = const Value.absent(),
                required String variantLabel,
                required String configJson,
                required int totalUnits,
                Value<double> srp = const Value.absent(),
                Value<String?> priceTiersJson = const Value.absent(),
                Value<String?> availableMaterialsJson = const Value.absent(),
                Value<int> currentStock = const Value.absent(),
                Value<int> leadTimeDays = const Value.absent(),
                Value<String?> seoDescription = const Value.absent(),
                Value<String?> tradingTermsJson = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BulkOrdersTableCompanion.insert(
                id: id,
                groupName: groupName,
                productName: productName,
                brand: brand,
                category: category,
                subCategory: subCategory,
                imageUrl: imageUrl,
                availableColorsJson: availableColorsJson,
                availableSizesJson: availableSizesJson,
                variantLabel: variantLabel,
                configJson: configJson,
                totalUnits: totalUnits,
                srp: srp,
                priceTiersJson: priceTiersJson,
                availableMaterialsJson: availableMaterialsJson,
                currentStock: currentStock,
                leadTimeDays: leadTimeDays,
                seoDescription: seoDescription,
                tradingTermsJson: tradingTermsJson,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BulkOrdersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BulkOrdersTableTable,
      BulkOrderEntry,
      $$BulkOrdersTableTableFilterComposer,
      $$BulkOrdersTableTableOrderingComposer,
      $$BulkOrdersTableTableAnnotationComposer,
      $$BulkOrdersTableTableCreateCompanionBuilder,
      $$BulkOrdersTableTableUpdateCompanionBuilder,
      (
        BulkOrderEntry,
        BaseReferences<_$AppDatabase, $BulkOrdersTableTable, BulkOrderEntry>,
      ),
      BulkOrderEntry,
      PrefetchHooks Function()
    >;
typedef $$OrdersTableTableCreateCompanionBuilder =
    OrdersTableCompanion Function({
      required String id,
      required String userId,
      required String itemsJson,
      required double totalAmount,
      required int totalUnits,
      Value<String> status,
      Value<bool> isDraft,
      Value<String?> pdfId,
      Value<String?> productId,
      Value<String?> supplierId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$OrdersTableTableUpdateCompanionBuilder =
    OrdersTableCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> itemsJson,
      Value<double> totalAmount,
      Value<int> totalUnits,
      Value<String> status,
      Value<bool> isDraft,
      Value<String?> pdfId,
      Value<String?> productId,
      Value<String?> supplierId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$OrdersTableTableFilterComposer
    extends Composer<_$AppDatabase, $OrdersTableTable> {
  $$OrdersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemsJson => $composableBuilder(
    column: $table.itemsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalUnits => $composableBuilder(
    column: $table.totalUnits,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDraft => $composableBuilder(
    column: $table.isDraft,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pdfId => $composableBuilder(
    column: $table.pdfId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OrdersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $OrdersTableTable> {
  $$OrdersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemsJson => $composableBuilder(
    column: $table.itemsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalUnits => $composableBuilder(
    column: $table.totalUnits,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDraft => $composableBuilder(
    column: $table.isDraft,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pdfId => $composableBuilder(
    column: $table.pdfId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OrdersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrdersTableTable> {
  $$OrdersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get itemsJson =>
      $composableBuilder(column: $table.itemsJson, builder: (column) => column);

  GeneratedColumn<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalUnits => $composableBuilder(
    column: $table.totalUnits,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<bool> get isDraft =>
      $composableBuilder(column: $table.isDraft, builder: (column) => column);

  GeneratedColumn<String> get pdfId =>
      $composableBuilder(column: $table.pdfId, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$OrdersTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrdersTableTable,
          WholesaleOrderEntry,
          $$OrdersTableTableFilterComposer,
          $$OrdersTableTableOrderingComposer,
          $$OrdersTableTableAnnotationComposer,
          $$OrdersTableTableCreateCompanionBuilder,
          $$OrdersTableTableUpdateCompanionBuilder,
          (
            WholesaleOrderEntry,
            BaseReferences<
              _$AppDatabase,
              $OrdersTableTable,
              WholesaleOrderEntry
            >,
          ),
          WholesaleOrderEntry,
          PrefetchHooks Function()
        > {
  $$OrdersTableTableTableManager(_$AppDatabase db, $OrdersTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrdersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrdersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrdersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> itemsJson = const Value.absent(),
                Value<double> totalAmount = const Value.absent(),
                Value<int> totalUnits = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<bool> isDraft = const Value.absent(),
                Value<String?> pdfId = const Value.absent(),
                Value<String?> productId = const Value.absent(),
                Value<String?> supplierId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrdersTableCompanion(
                id: id,
                userId: userId,
                itemsJson: itemsJson,
                totalAmount: totalAmount,
                totalUnits: totalUnits,
                status: status,
                isDraft: isDraft,
                pdfId: pdfId,
                productId: productId,
                supplierId: supplierId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String itemsJson,
                required double totalAmount,
                required int totalUnits,
                Value<String> status = const Value.absent(),
                Value<bool> isDraft = const Value.absent(),
                Value<String?> pdfId = const Value.absent(),
                Value<String?> productId = const Value.absent(),
                Value<String?> supplierId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrdersTableCompanion.insert(
                id: id,
                userId: userId,
                itemsJson: itemsJson,
                totalAmount: totalAmount,
                totalUnits: totalUnits,
                status: status,
                isDraft: isDraft,
                pdfId: pdfId,
                productId: productId,
                supplierId: supplierId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OrdersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrdersTableTable,
      WholesaleOrderEntry,
      $$OrdersTableTableFilterComposer,
      $$OrdersTableTableOrderingComposer,
      $$OrdersTableTableAnnotationComposer,
      $$OrdersTableTableCreateCompanionBuilder,
      $$OrdersTableTableUpdateCompanionBuilder,
      (
        WholesaleOrderEntry,
        BaseReferences<_$AppDatabase, $OrdersTableTable, WholesaleOrderEntry>,
      ),
      WholesaleOrderEntry,
      PrefetchHooks Function()
    >;
typedef $$GeneratedPdfsTableTableCreateCompanionBuilder =
    GeneratedPdfsTableCompanion Function({
      required String id,
      required String userId,
      required String title,
      required String filePath,
      required String fileSize,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$GeneratedPdfsTableTableUpdateCompanionBuilder =
    GeneratedPdfsTableCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> title,
      Value<String> filePath,
      Value<String> fileSize,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$GeneratedPdfsTableTableFilterComposer
    extends Composer<_$AppDatabase, $GeneratedPdfsTableTable> {
  $$GeneratedPdfsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GeneratedPdfsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $GeneratedPdfsTableTable> {
  $$GeneratedPdfsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileSize => $composableBuilder(
    column: $table.fileSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GeneratedPdfsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $GeneratedPdfsTableTable> {
  $$GeneratedPdfsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get fileSize =>
      $composableBuilder(column: $table.fileSize, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$GeneratedPdfsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GeneratedPdfsTableTable,
          GeneratedPdfEntry,
          $$GeneratedPdfsTableTableFilterComposer,
          $$GeneratedPdfsTableTableOrderingComposer,
          $$GeneratedPdfsTableTableAnnotationComposer,
          $$GeneratedPdfsTableTableCreateCompanionBuilder,
          $$GeneratedPdfsTableTableUpdateCompanionBuilder,
          (
            GeneratedPdfEntry,
            BaseReferences<
              _$AppDatabase,
              $GeneratedPdfsTableTable,
              GeneratedPdfEntry
            >,
          ),
          GeneratedPdfEntry,
          PrefetchHooks Function()
        > {
  $$GeneratedPdfsTableTableTableManager(
    _$AppDatabase db,
    $GeneratedPdfsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GeneratedPdfsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GeneratedPdfsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GeneratedPdfsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<String> fileSize = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GeneratedPdfsTableCompanion(
                id: id,
                userId: userId,
                title: title,
                filePath: filePath,
                fileSize: fileSize,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String title,
                required String filePath,
                required String fileSize,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GeneratedPdfsTableCompanion.insert(
                id: id,
                userId: userId,
                title: title,
                filePath: filePath,
                fileSize: fileSize,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GeneratedPdfsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GeneratedPdfsTableTable,
      GeneratedPdfEntry,
      $$GeneratedPdfsTableTableFilterComposer,
      $$GeneratedPdfsTableTableOrderingComposer,
      $$GeneratedPdfsTableTableAnnotationComposer,
      $$GeneratedPdfsTableTableCreateCompanionBuilder,
      $$GeneratedPdfsTableTableUpdateCompanionBuilder,
      (
        GeneratedPdfEntry,
        BaseReferences<
          _$AppDatabase,
          $GeneratedPdfsTableTable,
          GeneratedPdfEntry
        >,
      ),
      GeneratedPdfEntry,
      PrefetchHooks Function()
    >;
typedef $$SearchHistoryTableTableCreateCompanionBuilder =
    SearchHistoryTableCompanion Function({
      required String id,
      required String userId,
      required String query,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$SearchHistoryTableTableUpdateCompanionBuilder =
    SearchHistoryTableCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> query,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$SearchHistoryTableTableFilterComposer
    extends Composer<_$AppDatabase, $SearchHistoryTableTable> {
  $$SearchHistoryTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get query => $composableBuilder(
    column: $table.query,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SearchHistoryTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SearchHistoryTableTable> {
  $$SearchHistoryTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get query => $composableBuilder(
    column: $table.query,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SearchHistoryTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SearchHistoryTableTable> {
  $$SearchHistoryTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get query =>
      $composableBuilder(column: $table.query, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SearchHistoryTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SearchHistoryTableTable,
          SearchHistoryEntry,
          $$SearchHistoryTableTableFilterComposer,
          $$SearchHistoryTableTableOrderingComposer,
          $$SearchHistoryTableTableAnnotationComposer,
          $$SearchHistoryTableTableCreateCompanionBuilder,
          $$SearchHistoryTableTableUpdateCompanionBuilder,
          (
            SearchHistoryEntry,
            BaseReferences<
              _$AppDatabase,
              $SearchHistoryTableTable,
              SearchHistoryEntry
            >,
          ),
          SearchHistoryEntry,
          PrefetchHooks Function()
        > {
  $$SearchHistoryTableTableTableManager(
    _$AppDatabase db,
    $SearchHistoryTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SearchHistoryTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SearchHistoryTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SearchHistoryTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> query = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SearchHistoryTableCompanion(
                id: id,
                userId: userId,
                query: query,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String query,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SearchHistoryTableCompanion.insert(
                id: id,
                userId: userId,
                query: query,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SearchHistoryTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SearchHistoryTableTable,
      SearchHistoryEntry,
      $$SearchHistoryTableTableFilterComposer,
      $$SearchHistoryTableTableOrderingComposer,
      $$SearchHistoryTableTableAnnotationComposer,
      $$SearchHistoryTableTableCreateCompanionBuilder,
      $$SearchHistoryTableTableUpdateCompanionBuilder,
      (
        SearchHistoryEntry,
        BaseReferences<
          _$AppDatabase,
          $SearchHistoryTableTable,
          SearchHistoryEntry
        >,
      ),
      SearchHistoryEntry,
      PrefetchHooks Function()
    >;
typedef $$PromotionsTableTableCreateCompanionBuilder =
    PromotionsTableCompanion Function({
      required String id,
      required String title,
      Value<String?> subtitle,
      Value<String?> actionText,
      Value<String> imageUrlsJson,
      Value<int> priority,
      Value<bool> isActive,
      Value<DateTime?> startsAt,
      Value<DateTime?> expiresAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$PromotionsTableTableUpdateCompanionBuilder =
    PromotionsTableCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String?> subtitle,
      Value<String?> actionText,
      Value<String> imageUrlsJson,
      Value<int> priority,
      Value<bool> isActive,
      Value<DateTime?> startsAt,
      Value<DateTime?> expiresAt,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$PromotionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $PromotionsTableTable> {
  $$PromotionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subtitle => $composableBuilder(
    column: $table.subtitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actionText => $composableBuilder(
    column: $table.actionText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrlsJson => $composableBuilder(
    column: $table.imageUrlsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startsAt => $composableBuilder(
    column: $table.startsAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PromotionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PromotionsTableTable> {
  $$PromotionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subtitle => $composableBuilder(
    column: $table.subtitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actionText => $composableBuilder(
    column: $table.actionText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrlsJson => $composableBuilder(
    column: $table.imageUrlsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startsAt => $composableBuilder(
    column: $table.startsAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PromotionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PromotionsTableTable> {
  $$PromotionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get subtitle =>
      $composableBuilder(column: $table.subtitle, builder: (column) => column);

  GeneratedColumn<String> get actionText => $composableBuilder(
    column: $table.actionText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageUrlsJson => $composableBuilder(
    column: $table.imageUrlsJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get startsAt =>
      $composableBuilder(column: $table.startsAt, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PromotionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PromotionsTableTable,
          PromotionEntry,
          $$PromotionsTableTableFilterComposer,
          $$PromotionsTableTableOrderingComposer,
          $$PromotionsTableTableAnnotationComposer,
          $$PromotionsTableTableCreateCompanionBuilder,
          $$PromotionsTableTableUpdateCompanionBuilder,
          (
            PromotionEntry,
            BaseReferences<
              _$AppDatabase,
              $PromotionsTableTable,
              PromotionEntry
            >,
          ),
          PromotionEntry,
          PrefetchHooks Function()
        > {
  $$PromotionsTableTableTableManager(
    _$AppDatabase db,
    $PromotionsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PromotionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PromotionsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PromotionsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> subtitle = const Value.absent(),
                Value<String?> actionText = const Value.absent(),
                Value<String> imageUrlsJson = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime?> startsAt = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PromotionsTableCompanion(
                id: id,
                title: title,
                subtitle: subtitle,
                actionText: actionText,
                imageUrlsJson: imageUrlsJson,
                priority: priority,
                isActive: isActive,
                startsAt: startsAt,
                expiresAt: expiresAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<String?> subtitle = const Value.absent(),
                Value<String?> actionText = const Value.absent(),
                Value<String> imageUrlsJson = const Value.absent(),
                Value<int> priority = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime?> startsAt = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PromotionsTableCompanion.insert(
                id: id,
                title: title,
                subtitle: subtitle,
                actionText: actionText,
                imageUrlsJson: imageUrlsJson,
                priority: priority,
                isActive: isActive,
                startsAt: startsAt,
                expiresAt: expiresAt,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PromotionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PromotionsTableTable,
      PromotionEntry,
      $$PromotionsTableTableFilterComposer,
      $$PromotionsTableTableOrderingComposer,
      $$PromotionsTableTableAnnotationComposer,
      $$PromotionsTableTableCreateCompanionBuilder,
      $$PromotionsTableTableUpdateCompanionBuilder,
      (
        PromotionEntry,
        BaseReferences<_$AppDatabase, $PromotionsTableTable, PromotionEntry>,
      ),
      PromotionEntry,
      PrefetchHooks Function()
    >;
typedef $$TradingTermsTableTableCreateCompanionBuilder =
    TradingTermsTableCompanion Function({
      required String id,
      required String content,
      Value<String?> moq,
      Value<String?> warranty,
      Value<String?> paymentTerms,
      Value<String?> deliveryTerms,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$TradingTermsTableTableUpdateCompanionBuilder =
    TradingTermsTableCompanion Function({
      Value<String> id,
      Value<String> content,
      Value<String?> moq,
      Value<String?> warranty,
      Value<String?> paymentTerms,
      Value<String?> deliveryTerms,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$TradingTermsTableTableFilterComposer
    extends Composer<_$AppDatabase, $TradingTermsTableTable> {
  $$TradingTermsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get moq => $composableBuilder(
    column: $table.moq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get warranty => $composableBuilder(
    column: $table.warranty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentTerms => $composableBuilder(
    column: $table.paymentTerms,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deliveryTerms => $composableBuilder(
    column: $table.deliveryTerms,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TradingTermsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TradingTermsTableTable> {
  $$TradingTermsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get moq => $composableBuilder(
    column: $table.moq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get warranty => $composableBuilder(
    column: $table.warranty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentTerms => $composableBuilder(
    column: $table.paymentTerms,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deliveryTerms => $composableBuilder(
    column: $table.deliveryTerms,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TradingTermsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TradingTermsTableTable> {
  $$TradingTermsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get moq =>
      $composableBuilder(column: $table.moq, builder: (column) => column);

  GeneratedColumn<String> get warranty =>
      $composableBuilder(column: $table.warranty, builder: (column) => column);

  GeneratedColumn<String> get paymentTerms => $composableBuilder(
    column: $table.paymentTerms,
    builder: (column) => column,
  );

  GeneratedColumn<String> get deliveryTerms => $composableBuilder(
    column: $table.deliveryTerms,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$TradingTermsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TradingTermsTableTable,
          TradingTermsEntry,
          $$TradingTermsTableTableFilterComposer,
          $$TradingTermsTableTableOrderingComposer,
          $$TradingTermsTableTableAnnotationComposer,
          $$TradingTermsTableTableCreateCompanionBuilder,
          $$TradingTermsTableTableUpdateCompanionBuilder,
          (
            TradingTermsEntry,
            BaseReferences<
              _$AppDatabase,
              $TradingTermsTableTable,
              TradingTermsEntry
            >,
          ),
          TradingTermsEntry,
          PrefetchHooks Function()
        > {
  $$TradingTermsTableTableTableManager(
    _$AppDatabase db,
    $TradingTermsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TradingTermsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TradingTermsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TradingTermsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<String?> moq = const Value.absent(),
                Value<String?> warranty = const Value.absent(),
                Value<String?> paymentTerms = const Value.absent(),
                Value<String?> deliveryTerms = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TradingTermsTableCompanion(
                id: id,
                content: content,
                moq: moq,
                warranty: warranty,
                paymentTerms: paymentTerms,
                deliveryTerms: deliveryTerms,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String content,
                Value<String?> moq = const Value.absent(),
                Value<String?> warranty = const Value.absent(),
                Value<String?> paymentTerms = const Value.absent(),
                Value<String?> deliveryTerms = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TradingTermsTableCompanion.insert(
                id: id,
                content: content,
                moq: moq,
                warranty: warranty,
                paymentTerms: paymentTerms,
                deliveryTerms: deliveryTerms,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TradingTermsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TradingTermsTableTable,
      TradingTermsEntry,
      $$TradingTermsTableTableFilterComposer,
      $$TradingTermsTableTableOrderingComposer,
      $$TradingTermsTableTableAnnotationComposer,
      $$TradingTermsTableTableCreateCompanionBuilder,
      $$TradingTermsTableTableUpdateCompanionBuilder,
      (
        TradingTermsEntry,
        BaseReferences<
          _$AppDatabase,
          $TradingTermsTableTable,
          TradingTermsEntry
        >,
      ),
      TradingTermsEntry,
      PrefetchHooks Function()
    >;
typedef $$LegalTermsTableTableCreateCompanionBuilder =
    LegalTermsTableCompanion Function({
      required String id,
      required String title,
      required String content,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$LegalTermsTableTableUpdateCompanionBuilder =
    LegalTermsTableCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> content,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$LegalTermsTableTableFilterComposer
    extends Composer<_$AppDatabase, $LegalTermsTableTable> {
  $$LegalTermsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LegalTermsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $LegalTermsTableTable> {
  $$LegalTermsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get content => $composableBuilder(
    column: $table.content,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LegalTermsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $LegalTermsTableTable> {
  $$LegalTermsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LegalTermsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LegalTermsTableTable,
          LegalTermEntry,
          $$LegalTermsTableTableFilterComposer,
          $$LegalTermsTableTableOrderingComposer,
          $$LegalTermsTableTableAnnotationComposer,
          $$LegalTermsTableTableCreateCompanionBuilder,
          $$LegalTermsTableTableUpdateCompanionBuilder,
          (
            LegalTermEntry,
            BaseReferences<
              _$AppDatabase,
              $LegalTermsTableTable,
              LegalTermEntry
            >,
          ),
          LegalTermEntry,
          PrefetchHooks Function()
        > {
  $$LegalTermsTableTableTableManager(
    _$AppDatabase db,
    $LegalTermsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LegalTermsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LegalTermsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LegalTermsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> content = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegalTermsTableCompanion(
                id: id,
                title: title,
                content: content,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String content,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LegalTermsTableCompanion.insert(
                id: id,
                title: title,
                content: content,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LegalTermsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LegalTermsTableTable,
      LegalTermEntry,
      $$LegalTermsTableTableFilterComposer,
      $$LegalTermsTableTableOrderingComposer,
      $$LegalTermsTableTableAnnotationComposer,
      $$LegalTermsTableTableCreateCompanionBuilder,
      $$LegalTermsTableTableUpdateCompanionBuilder,
      (
        LegalTermEntry,
        BaseReferences<_$AppDatabase, $LegalTermsTableTable, LegalTermEntry>,
      ),
      LegalTermEntry,
      PrefetchHooks Function()
    >;
typedef $$RecordsTableTableCreateCompanionBuilder =
    RecordsTableCompanion Function({
      required String id,
      Value<String?> detailJson,
      Value<String> recordsHistoryJson,
      Value<String?> dataJson,
      Value<String?> reminderJson,
      Value<DateTime> updatedAt,
      Value<bool> isArchived,
      Value<int> rowid,
    });
typedef $$RecordsTableTableUpdateCompanionBuilder =
    RecordsTableCompanion Function({
      Value<String> id,
      Value<String?> detailJson,
      Value<String> recordsHistoryJson,
      Value<String?> dataJson,
      Value<String?> reminderJson,
      Value<DateTime> updatedAt,
      Value<bool> isArchived,
      Value<int> rowid,
    });

class $$RecordsTableTableFilterComposer
    extends Composer<_$AppDatabase, $RecordsTableTable> {
  $$RecordsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get detailJson => $composableBuilder(
    column: $table.detailJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordsHistoryJson => $composableBuilder(
    column: $table.recordsHistoryJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dataJson => $composableBuilder(
    column: $table.dataJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reminderJson => $composableBuilder(
    column: $table.reminderJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecordsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RecordsTableTable> {
  $$RecordsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detailJson => $composableBuilder(
    column: $table.detailJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordsHistoryJson => $composableBuilder(
    column: $table.recordsHistoryJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dataJson => $composableBuilder(
    column: $table.dataJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reminderJson => $composableBuilder(
    column: $table.reminderJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecordsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecordsTableTable> {
  $$RecordsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get detailJson => $composableBuilder(
    column: $table.detailJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recordsHistoryJson => $composableBuilder(
    column: $table.recordsHistoryJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dataJson =>
      $composableBuilder(column: $table.dataJson, builder: (column) => column);

  GeneratedColumn<String> get reminderJson => $composableBuilder(
    column: $table.reminderJson,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );
}

class $$RecordsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecordsTableTable,
          RecordEntry,
          $$RecordsTableTableFilterComposer,
          $$RecordsTableTableOrderingComposer,
          $$RecordsTableTableAnnotationComposer,
          $$RecordsTableTableCreateCompanionBuilder,
          $$RecordsTableTableUpdateCompanionBuilder,
          (
            RecordEntry,
            BaseReferences<_$AppDatabase, $RecordsTableTable, RecordEntry>,
          ),
          RecordEntry,
          PrefetchHooks Function()
        > {
  $$RecordsTableTableTableManager(_$AppDatabase db, $RecordsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecordsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecordsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecordsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> detailJson = const Value.absent(),
                Value<String> recordsHistoryJson = const Value.absent(),
                Value<String?> dataJson = const Value.absent(),
                Value<String?> reminderJson = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecordsTableCompanion(
                id: id,
                detailJson: detailJson,
                recordsHistoryJson: recordsHistoryJson,
                dataJson: dataJson,
                reminderJson: reminderJson,
                updatedAt: updatedAt,
                isArchived: isArchived,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> detailJson = const Value.absent(),
                Value<String> recordsHistoryJson = const Value.absent(),
                Value<String?> dataJson = const Value.absent(),
                Value<String?> reminderJson = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecordsTableCompanion.insert(
                id: id,
                detailJson: detailJson,
                recordsHistoryJson: recordsHistoryJson,
                dataJson: dataJson,
                reminderJson: reminderJson,
                updatedAt: updatedAt,
                isArchived: isArchived,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecordsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecordsTableTable,
      RecordEntry,
      $$RecordsTableTableFilterComposer,
      $$RecordsTableTableOrderingComposer,
      $$RecordsTableTableAnnotationComposer,
      $$RecordsTableTableCreateCompanionBuilder,
      $$RecordsTableTableUpdateCompanionBuilder,
      (
        RecordEntry,
        BaseReferences<_$AppDatabase, $RecordsTableTable, RecordEntry>,
      ),
      RecordEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProductsTableTableTableManager get productsTable =>
      $$ProductsTableTableTableManager(_db, _db.productsTable);
  $$CategoriesTableTableTableManager get categoriesTable =>
      $$CategoriesTableTableTableManager(_db, _db.categoriesTable);
  $$PriceTiersTableTableTableManager get priceTiersTable =>
      $$PriceTiersTableTableTableManager(_db, _db.priceTiersTable);
  $$BusinessTableTableTableManager get businessTable =>
      $$BusinessTableTableTableManager(_db, _db.businessTable);
  $$UsersTableTableTableManager get usersTable =>
      $$UsersTableTableTableManager(_db, _db.usersTable);
  $$BulkOrdersTableTableTableManager get bulkOrdersTable =>
      $$BulkOrdersTableTableTableManager(_db, _db.bulkOrdersTable);
  $$OrdersTableTableTableManager get ordersTable =>
      $$OrdersTableTableTableManager(_db, _db.ordersTable);
  $$GeneratedPdfsTableTableTableManager get generatedPdfsTable =>
      $$GeneratedPdfsTableTableTableManager(_db, _db.generatedPdfsTable);
  $$SearchHistoryTableTableTableManager get searchHistoryTable =>
      $$SearchHistoryTableTableTableManager(_db, _db.searchHistoryTable);
  $$PromotionsTableTableTableManager get promotionsTable =>
      $$PromotionsTableTableTableManager(_db, _db.promotionsTable);
  $$TradingTermsTableTableTableManager get tradingTermsTable =>
      $$TradingTermsTableTableTableManager(_db, _db.tradingTermsTable);
  $$LegalTermsTableTableTableManager get legalTermsTable =>
      $$LegalTermsTableTableTableManager(_db, _db.legalTermsTable);
  $$RecordsTableTableTableManager get recordsTable =>
      $$RecordsTableTableTableManager(_db, _db.recordsTable);
}
