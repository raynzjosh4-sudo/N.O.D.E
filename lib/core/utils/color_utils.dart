import 'package:flutter/material.dart';

class ColorUtils {
  // Brand Palette
  static const Color nodePurple = Color(0xFF9C27B0);
  static const Color primaryBlue = Color(0xFF12BBF0);
  static const Color warmBackground = Color(0xFFF9F6F2);
  static const Color marginGreen = Color(0xFF36B37E);
  static const Color moqOrange = Color(0xFFFFAB00);
  static const Color deepNavy = Color(0xFF172B4D);
  static const Color errorRed = Color(0xFFDE350B);
  static const Color borderLight = Color(0xFFDFE1E6);

  // --- Premium Implementation Palette ---
  static const Map<String, Color> _namedColors = {
    'navy': Color(0xFF1B263B),
    'maroon': Color(0xFF6A040F),
    'teal': Color(0xFF006D77),
    'olive': Color(0xFF52796F),
    'slate': Color(0xFF4A4E69),
    'charcoal': Color(0xFF293241),
    'burgundy': Color(0xFF800E13),
    'forest': Color(0xFF2D6A4F),
    'mustard': Color(0xFFE09F3E),
    'rust': Color(0xFF9E2A2B),
    'rose': Color(0xFFD4A373),
    'sage': Color(0xFFB7B7A4),
    'denim': Color(0xFF415A77),
    'plum': Color(0xFF5E548E),
    'copper': Color(0xFFBC6C25),
    'cream': Color(0xFFFEFAE0),
    'sand': Color(0xFFE9EDC9),
    'clay': Color(0xFFDDA15E),
    'jet': Color(0xFF212529),
    'silver': Color(0xFFE5E5E5),
    'gold': Color(0xFFD4AF37),
    'royal blue': Color(0xFF00308F),
    'sky blue': Color(0xFF87CEEB),
    'emerald': Color(0xFF50C878),
  };

  /// Resolves a color from its name strings (e.g., "Navy", "Dark Blue").
  /// Case-insensitive. Returns [Colors.grey] if not found.
  static Color fromName(String name) {
    final clean = name.trim().toLowerCase();
    
    // Exact match
    if (_namedColors.containsKey(clean)) return _namedColors[clean]!;
    
    // Partial matches
    for (final entry in _namedColors.entries) {
      if (clean.contains(entry.key)) return entry.value;
    }

    return Colors.grey;
  }

  /// Converts a hex string to a Flutter Color object.
  /// Handles: #RRGGBB, RRGGBB, #AARRGGBB, AARRGGBB.
  /// Returns [Colors.grey] if input is invalid.
  static Color fromHex(String? hex) {
    if (hex == null || hex.isEmpty) return Colors.grey;
    try {
      String cleanHex = hex.replaceAll('#', '').trim().toUpperCase();

      if (cleanHex.length == 6) {
        cleanHex = 'FF$cleanHex';
      }

      if (cleanHex.length != 8) {
        // Not a hex, maybe it's a name?
        return fromName(hex);
      }

      return Color(int.parse(cleanHex, radix: 16));
    } catch (e) {
      return fromName(hex);
    }
  }

  /// Converts a Color object to an 8-character hex string (AARRGGBB).
  static String toHex(Color color) {
    return color.value.toRadixString(16).padLeft(8, '0').toUpperCase();
  }
}
