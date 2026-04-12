import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';

class PdfUtils {
  /// Fetches an image from a network URL using a cache manager and returns it as a pw.MemoryImage.
  /// Reuses images already downloaded by the app UI for better performance.
  /// Returns null if the download fails.
  static Future<pw.MemoryImage?> fetchNetworkImage(String? url) async {
    if (url == null || url.isEmpty) return null;
    
    try {
      // Use DefaultCacheManager to get the file (returns from cache if available)
      final fileInfo = await DefaultCacheManager().getFileFromCache(url);
      
      Uint8List bytes;
      if (fileInfo != null) {
        // Image is in cache
        bytes = await fileInfo.file.readAsBytes();
      } else {
        // Not in cache, download it
        final file = await DefaultCacheManager().getSingleFile(url);
        bytes = await file.readAsBytes();
      }
      
      return pw.MemoryImage(bytes);
    } catch (e) {
      print('Error fetching cached image for PDF: $e');
    }
    return null;
  }
}
