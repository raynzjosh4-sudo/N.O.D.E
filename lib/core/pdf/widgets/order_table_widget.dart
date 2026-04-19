import 'package:node_app/core/pdf/constants/pdf_theme.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

pw.Widget buildOrderTable({
  required List<dynamic> groups,
  required List<String> allSizes,
  required double unitPrice,
  required double totalPrice,
  required PdfColor primaryColor,
  required PdfColor borderColor,
  required PdfColor bodyTextColor,
  required PdfColor subtleColor,
  required PdfColor lightBg,
}) {
  final currencyFormat = NumberFormat.currency(
    symbol: 'UGX ',
    decimalDigits: 0,
  );

  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      // Table Content
      pw.Table(
        border: pw.TableBorder(
          horizontalInside: pw.BorderSide(color: borderColor, width: 0.5),
          bottom: pw.BorderSide(color: bodyTextColor, width: 1.5),
        ),
        children: [
          // Table Header
          pw.TableRow(
            decoration: pw.BoxDecoration(color: PdfTheme.darkBg),
            children: [
              _buildHeaderCell('COLOR', isFirst: true),
              ...allSizes.map((size) => _buildHeaderCell(size.toUpperCase())),
              _buildHeaderCell('TOTAL', isLast: true),
            ],
          ),

          // Data Rows
          ...groups.asMap().entries.map((mapEntry) {
            final idx = mapEntry.key;
            final group = mapEntry.value;
            final isEven = idx % 2 == 1;

            return pw.TableRow(
              decoration: isEven
                  ? pw.BoxDecoration(color: PdfColor.fromHex('#FAFAFA'))
                  : null,
              children: [
                _buildColorCell(
                  group.color.label,
                  PdfColor.fromInt(group.color.color.value),
                  bodyTextColor,
                ),
                ...allSizes.map((size) {
                  final qty = group.sizeQtys[size] ?? 0;
                  return _buildTableCell(
                    qty == 0 ? '-' : qty.toString(),
                    qty == 0 ? subtleColor : bodyTextColor,
                  );
                }),
                _buildTableCell(
                  group.sizeQtys.values
                      .fold(0, (sum, qty) => sum + qty)
                      .toString(),
                  bodyTextColor,
                  isBold: true,
                ),
              ],
            );
          }),
        ],
      ),

      // Pricing Summary Area (Clean Invoice Style)
      pw.Container(
        padding: const pw.EdgeInsets.symmetric(vertical: 16),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                _buildSummaryLine(
                  'UNIT PRICE (TIERED)',
                  currencyFormat.format(unitPrice),
                  subtleColor,
                  bodyTextColor,
                ),
                pw.SizedBox(height: 8),
                pw.Container(width: 200, height: 1, color: borderColor),
                pw.SizedBox(height: 8),
                _buildSummaryLine(
                  'TOTAL ITEM VALUE',
                  currencyFormat.format(totalPrice),
                  bodyTextColor,
                  primaryColor,
                  isLarge: true,
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

pw.Widget _buildHeaderCell(
  String text, {
  bool isFirst = false,
  bool isLast = false,
}) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(12),
    child: pw.Text(
      text,
      style: pw.TextStyle(
        fontSize: 10.5,
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
        letterSpacing: 1.2,
      ),
      textAlign: isFirst ? pw.TextAlign.left : pw.TextAlign.center,
    ),
  );
}

pw.Widget _buildTableCell(
  String text,
  PdfColor color, {
  bool isBold = false,
  bool isFirst = false,
}) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(12),
    child: pw.Text(
      text,
      style: pw.TextStyle(
        fontSize: 11.5,
        fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
        color: color,
      ),
      textAlign: isFirst ? pw.TextAlign.left : pw.TextAlign.center,
    ),
  );
}

pw.Widget _buildColorCell(
  String label,
  PdfColor swatchColor,
  PdfColor textColor,
) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(12),
    child: pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Container(
          width: 9,
          height: 9,
          decoration: pw.BoxDecoration(
            color: swatchColor,
            shape: pw.BoxShape.circle,
            border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
          ),
        ),
        pw.SizedBox(width: 8),
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 11.5,
            fontWeight: pw.FontWeight.bold,
            color: textColor,
          ),
        ),
      ],
    ),
  );
}

pw.Widget _buildSummaryLine(
  String label,
  String value,
  PdfColor labelColor,
  PdfColor valueColor, {
  bool isLarge = false,
}) {
  return pw.Row(
    mainAxisSize: pw.MainAxisSize.min,
    children: [
      pw.Text(
        label,
        style: pw.TextStyle(
          fontSize: 9.5,
          fontWeight: pw.FontWeight.bold,
          color: labelColor,
          letterSpacing: 1.5,
        ),
      ),
      pw.SizedBox(width: 24),
      pw.Text(
        value,
        style: pw.TextStyle(
          fontSize: isLarge ? 18 : 13,
          fontWeight: pw.FontWeight.bold,
          color: valueColor,
        ),
      ),
    ],
  );
}
