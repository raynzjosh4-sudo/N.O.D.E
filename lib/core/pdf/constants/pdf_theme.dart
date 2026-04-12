import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfTheme {
  // Brand Colors
  static final primaryColor = PdfColor.fromHex(
    '#00BFFF',
  ); // N.O.D.E. brand blue
  static final darkBg = PdfColor.fromHex('#0D0D1A'); // Executive Navy/Black
  static final headerTextColor = PdfColors.white;
  static final bodyTextColor = PdfColor.fromHex('#1A1A2E');
  static final subtleColor = PdfColor.fromHex('#71717A'); // Modern Zinc/Grey
  static final borderColor = PdfColor.fromHex('#E4E4E7'); // Subtle borders
  static final lightBg = PdfColor.fromHex(
    '#FAFAFA',
  ); // Very light grey for cards

  // High-Density Theme Accents
  static final cardFill = PdfColor.fromHex('#F4F4F5');
  static final accentRed = PdfColor.fromHex('#EF4444');
  static final accentGreen = PdfColor.fromHex('#22C55E');

  // Translucent Variants (Manually calculated R,G,B for 0.1 opacity)
  static final accentRedTranslucent = PdfColor(
    239 / 255,
    68 / 255,
    68 / 255,
    0.1,
  );
  static final accentGreenTranslucent = PdfColor(
    34 / 255,
    197 / 255,
    94 / 255,
    0.1,
  );

  static final headerLabelStyle = pw.TextStyle(
    color: PdfColor.fromHex('#999999'),
    fontSize: 7,
    letterSpacing: 1.5,
    fontWeight: pw.FontWeight.bold,
  );

  static final dataValueStyle = pw.TextStyle(
    color: bodyTextColor,
    fontSize: 10,
    fontWeight: pw.FontWeight.bold,
  );
}
