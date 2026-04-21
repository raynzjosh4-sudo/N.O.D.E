import 'dart:typed_data';

class PdfGenerationResult {
  final Uint8List bytes;
  final String fileName;
  final String fileSize;

  PdfGenerationResult({
    required this.bytes,
    required this.fileName,
    required this.fileSize,
  });
}
