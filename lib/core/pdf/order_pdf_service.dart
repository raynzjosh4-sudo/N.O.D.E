import 'dart:io';
import 'package:flutter/services.dart';
import 'package:node_app/core/database/app_database.dart';
import 'package:node_app/features/auth/domain/entities/business_profile.dart';
import 'package:node_app/features/profile/domain/entities/wholesale_order.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

import 'models/pdf_result.dart';
import 'constants/pdf_theme.dart';
import 'widgets/pdf_header.dart';
import 'widgets/pdf_footer.dart';
import 'widgets/order_table_widget.dart';
import 'widgets/product_details_section.dart';
import 'pdf_utils.dart';

class OrderPdfService {
  static Future<PdfGenerationResult> generate({
    required String orderId,
    required String title,
    required UserEntry user,
    required BusinessProfile businessProfile,
    required List<ProductOrderEntry> entries,
    required DateTime date,
  }) async {
    try {
      final doc = pw.Document();

      final primaryColor = PdfTheme.primaryColor;
      final darkBg = PdfTheme.darkBg;
      final headerTextColor = PdfTheme.headerTextColor;
      final bodyTextColor = PdfTheme.bodyTextColor;
      final subtleColor = PdfTheme.subtleColor;
      final borderColor = PdfTheme.borderColor;
      final lightBg = PdfTheme.lightBg;

      final dateStr = DateFormat('MMMM dd, yyyy').format(date);

      // 1. Fetch images and calculate pricing for each entry
      final List<pw.MemoryImage?> fetchedImages = [];
      for (final entry in entries) {
        final img = await PdfUtils.fetchNetworkImage(
          entry.savedProduct.product.imageUrl,
        );
        fetchedImages.add(img);
      }

      // Build global size list
      final allSizesSet = <String>{};
      for (final entry in entries) {
        for (final group in entry.confirmedGroups ?? []) {
          allSizesSet.addAll(group.sizeQtys.keys);
        }
      }
      final sizeList = allSizesSet.toList()..sort();

      // Load Icons
      pw.MemoryImage? appIcon;
      pw.MemoryImage? nexusIcon;
      try {
        final iconData = await rootBundle.load('assets/icon/nodeicon.png');
        appIcon = pw.MemoryImage(iconData.buffer.asUint8List());

        final nexusData = await rootBundle.load('assets/icon/nexus.png');
        nexusIcon = pw.MemoryImage(nexusData.buffer.asUint8List());
      } catch (e) {
        print('Warning: Branding icons not fully loaded: $e');
      }

      // 2. Add Page(s)
      doc.addPage(
        pw.MultiPage(
          pageTheme: pw.PageTheme(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(0), // Full bleed header
          ),
          header: (ctx) => buildPdfHeader(
            dateStr: dateStr,
            primaryColor: primaryColor,
            darkBg: darkBg,
            headerTextColor: headerTextColor,
            appIcon: appIcon,
          ),
          footer: (ctx) => buildPdfFooter(
            ctx: ctx,
            borderColor: borderColor,
            subtleColor: subtleColor,
            nexusIcon: nexusIcon,
          ),
          build: (ctx) => [
            // Spacer for Header (Integrated look)
            pw.SizedBox(height: 100),

            // MERCHANT IDENTITY BAR (Integrated look)
            _buildMerchantIdentityBar(
              user,
              businessProfile,
              darkBg,
              headerTextColor,
              primaryColor,
              borderColor,
            ),

            // BODY CONTENT - FLATTENED FOR NATURAL PAGINATION
            ...entries.asMap().entries.map((mapEntry) {
              final idx = mapEntry.key;
              final entry = mapEntry.value;
              final product = entry.savedProduct.product;
              final productImage = fetchedImages[idx];

              final unitPrice = product.getPriceForQuantity(entry.totalUnits);
              final subtotal = unitPrice * entry.totalUnits;

              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  if (idx > 0)
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(
                        vertical: 40,
                        horizontal: 40,
                      ),
                      child: pw.Divider(color: borderColor, thickness: 0.5),
                    ),

                  // Unified Dark Identity Block (FULL BLEED)
                  pw.Container(
                    width: double.infinity,
                    padding: const pw.EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 24, // Reduced from 40
                    ),
                    decoration: pw.BoxDecoration(color: darkBg),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        // Section 1: Item Identity
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  (product.name ?? '').toUpperCase(),
                                  style: pw.TextStyle(
                                    fontSize: 18,
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColors.white,
                                    letterSpacing: 1,
                                  ),
                                ),
                                pw.SizedBox(height: 4),
                                pw.Row(
                                  children: [
                                    pw.Text(
                                      product.brand?.toUpperCase() ?? '',
                                      style: pw.TextStyle(
                                        fontSize: 9,
                                        fontWeight: pw.FontWeight.bold,
                                        color: primaryColor,
                                      ),
                                    ),
                                    pw.SizedBox(width: 8),
                                    pw.Container(
                                      width: 1,
                                      height: 8,
                                      color: PdfColor.fromHex('#3F3F46'),
                                    ),
                                    pw.SizedBox(width: 8),
                                    pw.Text(
                                      'REFERENCE SKU: ${product.sku ?? 'N/A'}',
                                      style: pw.TextStyle(
                                        fontSize: 9,
                                        color: PdfColor.fromHex('#A1A1AA'),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            pw.Container(
                              padding: const pw.EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: pw.BoxDecoration(
                                color: primaryColor,
                                borderRadius: const pw.BorderRadius.all(
                                  pw.Radius.circular(2),
                                ),
                              ),
                              child: pw.Text(
                                '${entry.totalUnits} UNITS',
                                style: pw.TextStyle(
                                  fontSize: 11,
                                  fontWeight: pw.FontWeight.bold,
                                  color: PdfColors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 24), // Reduced from 32
                        ProductDetailsSection(
                          product: product,
                          orderedQty: entry.totalUnits,
                          productImage: productImage,
                          isDarkTheme: true,
                        ),
                      ],
                    ),
                  ),

                  pw.SizedBox(height: 20), // Reduced from 32
                  // Section 3: Technical Data Table (INTERNAL PADDING)
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 40),
                    child: buildOrderTable(
                      groups: entry.confirmedGroups ?? [],
                      allSizes: sizeList,
                      unitPrice: unitPrice,
                      totalPrice: subtotal,
                      primaryColor: primaryColor,
                      borderColor: borderColor,
                      bodyTextColor: bodyTextColor,
                      subtleColor: subtleColor,
                      lightBg: lightBg,
                    ),
                  ),
                ],
              );
            }),

            pw.SizedBox(height: 40),

            // GRAND TOTAL SECTION
            _buildGrandTotalSection(entries, primaryColor, darkBg),

            pw.SizedBox(height: 64),

            // OFFICIAL DELIVERY VERIFICATION (FULL BLEED)
            _buildVerificationSection(orderId, darkBg, primaryColor),
          ],
        ),
      );

      // 3. Save to disk
      final dir = await getApplicationDocumentsDirectory();
      final safeName = title.replaceAll(RegExp(r'[^\w\s\-]'), '').trim();
      final file = File('${dir.path}/$safeName.pdf');
      final bytes = await doc.save();
      await file.writeAsBytes(bytes);

      final sizeDisplay = bytes.length > 1024 * 1024
          ? '${(bytes.length / (1024 * 1024)).toStringAsFixed(1)} MB'
          : '${(bytes.length / 1024).toStringAsFixed(1)} KB';

      return PdfGenerationResult(filePath: file.path, fileSize: sizeDisplay);
    } catch (e, stack) {
      print('CRITICAL ERROR in OrderPdfService.generate: $e');
      print('STACK TRACE:\n$stack');
      rethrow;
    }
  }

  static pw.Widget _buildMerchantIdentityBar(
    UserEntry user,
    BusinessProfile businessProfile,
    PdfColor darkBg,
    PdfColor headerTextColor,
    PdfColor primaryColor,
    PdfColor borderColor,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      decoration: pw.BoxDecoration(
        color: PdfTheme.lightBg,
        border: pw.Border(
          bottom: pw.BorderSide(color: borderColor, width: 0.5),
        ),
      ),
      child: pw.Row(
        children: [
          _identityItem(
            'ISSUED TO MERCHANT',
            user.fullName?.toUpperCase() ?? 'N/A',
            businessProfile.legalName ?? '',
          ),
          pw.SizedBox(width: 40),
          _identityItem(
            'LOGISTICS ORIGIN',
            businessProfile.city?.toUpperCase() ?? 'N/A',
            businessProfile.physicalAddress ?? '',
          ),
          pw.Spacer(),
          _identityItem(
            'CONTACT REGISTRY',
            businessProfile.phoneNumber ?? 'N/A',
            'NODE PARTNER NETWORK',
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildGrandTotalSection(
    List<ProductOrderEntry> entries,
    PdfColor primaryColor,
    PdfColor darkBg,
  ) {
    double grandTotal = 0;
    int totalUnits = 0;

    for (final entry in entries) {
      final unitPrice = entry.savedProduct.product.getPriceForQuantity(
        entry.totalUnits,
      );
      grandTotal += unitPrice * entry.totalUnits;
      totalUnits += entry.totalUnits;
    }

    final currencyFormat = NumberFormat.currency(
      symbol: 'UGX ',
      decimalDigits: 0,
    );

    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      decoration: pw.BoxDecoration(
        color: PdfColor.fromHex('#F4F4F5'),
        border: pw.Border(top: pw.BorderSide(color: primaryColor, width: 2)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'ORDER CONSOLIDATION SUMMARY',
                style: pw.TextStyle(
                  fontSize: 7,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromHex('#71717A'),
                  letterSpacing: 1.5,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'Total Consolidated Units: $totalUnits',
                style: pw.TextStyle(
                  fontSize: 9,
                  color: PdfColor.fromHex('#18181B'),
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                'GRAND TOTAL VALUE',
                style: pw.TextStyle(
                  fontSize: 8,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromHex('#18181B'),
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                currencyFormat.format(grandTotal),
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _identityItem(String label, String value, String subValue) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(label, style: PdfTheme.headerLabelStyle),
        pw.SizedBox(height: 4),
        pw.Text(value, style: PdfTheme.dataValueStyle.copyWith(fontSize: 10)),
        if (subValue.isNotEmpty) ...[
          pw.SizedBox(height: 2),
          pw.Text(
            subValue,
            style: pw.TextStyle(color: PdfTheme.subtleColor, fontSize: 8),
          ),
        ],
      ],
    );
  }

  static pw.Widget _buildVerificationSection(
    String orderId,
    PdfColor darkBg,
    PdfColor primaryColor,
  ) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(32),
      decoration: pw.BoxDecoration(color: darkBg),
      child: pw.Row(
        children: [
          // QR CODE CONTAINER (WHITE FOR SCANNABILITY)
          pw.Container(
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              color: PdfColors.white,
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
            ),
            child: pw.BarcodeWidget(
              barcode: pw.Barcode.qrCode(),
              data: orderId,
              width: 80,
              height: 80,
            ),
          ),
          pw.SizedBox(width: 32),
          // INSTRUCTIONS
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'DELIVERY VERIFICATION CLEARANCE',
                  style: pw.TextStyle(
                    color: primaryColor,
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                pw.SizedBox(height: 12),
                pw.Text(
                  'This document acts as the official ownership token for the items listed. '
                  'The customer must scan the QR code above using the N.O.D.E. app to authorize and log the delivery as successful.',
                  style: pw.TextStyle(color: PdfColors.white, fontSize: 9),
                ),
                pw.SizedBox(height: 12),
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromHex('#27272A'),
                    borderRadius: const pw.BorderRadius.all(
                      pw.Radius.circular(2),
                    ),
                  ),
                  child: pw.Text(
                    'TOKEN ID: $orderId',
                    style: pw.TextStyle(
                      color: PdfColor.fromHex('#A1A1AA'),
                      fontSize: 8,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
