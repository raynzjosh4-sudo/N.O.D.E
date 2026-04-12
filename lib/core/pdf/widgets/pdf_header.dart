import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../constants/pdf_theme.dart';

pw.Widget buildPdfHeader({
  required String dateStr,
  required PdfColor primaryColor,
  required PdfColor darkBg,
  required PdfColor headerTextColor,
  pw.MemoryImage? appIcon,
}) {
  return pw.Container(
    color: darkBg,
    padding: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 32),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        // Brand Identity
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              children: [
                if (appIcon != null)
                  pw.Container(
                    width: 32,
                    height: 32,
                    child: pw.Image(appIcon),
                  )
                else
                  pw.Container(
                    width: 12,
                    height: 12,
                    decoration: pw.BoxDecoration(
                      color: primaryColor,
                      shape: pw.BoxShape.circle,
                    ),
                  ),
                pw.SizedBox(width: 12),
                pw.Text(
                  'N.O.D.E.',
                  style: pw.TextStyle(
                    color: headerTextColor,
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    letterSpacing: 6,
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              'National Order & Distribution Exchange'.toUpperCase(),
              style: pw.TextStyle(
                color: PdfColor.fromHex('#71717A'),
                fontSize: 7,
                letterSpacing: 1.5,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),

        // Document Meta
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: primaryColor, width: 1),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
              ),
              child: pw.Text(
                'OFFICIAL SPEC SHEET',
                style: pw.TextStyle(
                  color: primaryColor,
                  fontSize: 8,
                  fontWeight: pw.FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              'ISSUED: $dateStr',
              style: pw.TextStyle(
                color: PdfColor.fromHex('#71717A'),
                fontSize: 8,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
