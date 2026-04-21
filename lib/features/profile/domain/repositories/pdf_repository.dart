import 'package:fpdart/fpdart.dart';
import 'package:node_app/core/error/failure.dart';
import 'package:node_app/features/profile/domain/entities/pdf_document.dart';

import 'dart:typed_data';

abstract class PdfRepository {
  Future<Either<Failure, void>> savePdfMetadata({
    required String id,
    required String userId,
    required String title,
    required Uint8List bytes,
    required String fileName,
    required String fileSize,
  });

  Future<Either<Failure, List<PdfDocument>>> getUserPdfs(String userId);

  Future<Either<Failure, PdfDocument>> getPdfById(String id);

  Future<Either<Failure, void>> deletePdf(String id);
}
