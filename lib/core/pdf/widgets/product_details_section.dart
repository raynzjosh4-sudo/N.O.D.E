import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../constants/pdf_theme.dart';
import '../../../../features/inventory/domain/entities/product.dart';

class ProductDetailsSection extends pw.StatelessWidget {
  final Product product;
  final int orderedQty;
  final pw.MemoryImage? productImage;
  final bool isDarkTheme;

  ProductDetailsSection({
    required this.product,
    required this.orderedQty,
    this.productImage,
    this.isDarkTheme = true,
  });

  @override
  pw.Widget build(pw.Context context) {
    final bodyTextColor = isDarkTheme
        ? PdfColors.white
        : PdfTheme.bodyTextColor;
    final subtleColor = isDarkTheme
        ? PdfColor.fromHex('#A1A1AA')
        : PdfTheme.subtleColor;
    final primaryColor = PdfTheme.primaryColor;
    final borderColor = isDarkTheme
        ? PdfColor.fromHex('#3F3F46')
        : PdfTheme.borderColor;
    final cardFill = isDarkTheme
        ? PdfColor.fromHex('#18181B')
        : PdfTheme.cardFill;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Left Side: Image with Executive Frame
            pw.Container(
              width: 140,
              height: 140,
              decoration: pw.BoxDecoration(
                color: isDarkTheme
                    ? PdfColor.fromHex('#18181B')
                    : PdfColors.grey100,
                border: pw.Border(
                  left: pw.BorderSide(color: primaryColor, width: 3),
                  top: pw.BorderSide(color: borderColor, width: 0.5),
                  bottom: pw.BorderSide(color: borderColor, width: 0.5),
                  right: pw.BorderSide(color: borderColor, width: 0.5),
                ),
              ),
              child: productImage != null
                  ? pw.Image(productImage!, fit: pw.BoxFit.cover)
                  : pw.Center(
                      child: pw.Text(
                        'NO IMAGE',
                        style: pw.TextStyle(
                          color: subtleColor,
                          fontSize: 8,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
            ),

            pw.SizedBox(width: 24),

            // Right Side: Industrial Data Grid
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  _infoBlock(
                    'SUPPLIER',
                    product.supplier.name.toUpperCase(),
                    bodyTextColor,
                  ),
                  pw.SizedBox(height: 2),
                  pw.Text(
                    product.supplier.location.addressName,
                    style: pw.TextStyle(fontSize: 9, color: subtleColor),
                  ),

                  pw.SizedBox(height: 20),

                  pw.Row(
                    children: [
                      pw.Expanded(
                        child: _dataCard(
                          'AVAILABILITY',
                          '${product.currentStock} UNITS',
                          iconColor: PdfTheme.accentGreen,
                          fill: cardFill,
                          textColor: bodyTextColor,
                        ),
                      ),
                      pw.SizedBox(width: 12),
                      pw.Expanded(
                        child: _dataCard(
                          'LEAD TIME',
                          '${product.leadTimeDays} DAYS',
                          iconColor: PdfTheme.primaryColor,
                          fill: cardFill,
                          textColor: bodyTextColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),

        pw.SizedBox(height: 24),

        // High-Density Sectioning
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              flex: 3,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _sectionHeader('TECHNICAL DESCRIPTION'),
                  pw.Text(
                    product.seoDescription,
                    style: pw.TextStyle(
                      fontSize: 9,
                      color: bodyTextColor,
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(width: 32),
            pw.Expanded(
              flex: 2,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _sectionHeader('TRADING TERMS'),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(10),
                    decoration: pw.BoxDecoration(
                      color: cardFill,
                      border: pw.Border(
                        left: pw.BorderSide(color: borderColor, width: 2),
                      ),
                    ),
                    child: pw.Text(
                      product.tradingTerms.content,
                      style: pw.TextStyle(
                        fontSize: 8,
                        color: subtleColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _sectionHeader(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            text,
            style: pw.TextStyle(
              fontSize: 8,
              fontWeight: pw.FontWeight.bold,
              color: PdfTheme.primaryColor,
              letterSpacing: 1.5,
            ),
          ),
          pw.SizedBox(height: 2),
          pw.Container(width: 20, height: 1.5, color: PdfTheme.primaryColor),
        ],
      ),
    );
  }

  pw.Widget _infoBlock(String label, String value, PdfColor textColor) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          label,
          style: isDarkTheme
              ? PdfTheme.headerLabelStyle.copyWith(
                  color: PdfColor.fromHex('#71717A'),
                )
              : PdfTheme.headerLabelStyle,
        ),
        pw.SizedBox(height: 2),
        pw.Text(
          value,
          style: PdfTheme.dataValueStyle.copyWith(
            fontSize: 12,
            color: textColor,
          ),
        ),
      ],
    );
  }

  pw.Widget _dataCard(
    String label,
    String value, {
    required PdfColor iconColor,
    required PdfColor fill,
    required PdfColor textColor,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        color: fill,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              pw.Container(
                width: 3,
                height: 3,
                decoration: pw.BoxDecoration(
                  color: iconColor,
                  shape: pw.BoxShape.circle,
                ),
              ),
              pw.SizedBox(width: 4),
              pw.Text(
                label,
                style: isDarkTheme
                    ? PdfTheme.headerLabelStyle.copyWith(
                        fontSize: 6.5,
                        color: PdfColor.fromHex('#71717A'),
                      )
                    : PdfTheme.headerLabelStyle.copyWith(fontSize: 6.5),
              ),
            ],
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            value,
            style: PdfTheme.dataValueStyle.copyWith(
              fontSize: 10,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
