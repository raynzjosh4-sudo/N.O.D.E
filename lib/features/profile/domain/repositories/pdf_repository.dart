import 'package:fpdart/fpdart.dart';
import 'package:node_app/core/error/failure.dart';
import 'package:node_app/features/profile/domain/entities/pdf_document.dart';

abstract class PdfRepository {
  Future<Either<Failure, void>> savePdfMetadata({
    required String id,
    required String userId,
    required String title,
    required String filePath,
    required String fileSize,
  });

  Future<Either<Failure, List<PdfDocument>>> getUserPdfs(String userId);

  Future<Either<Failure, void>> deletePdf(String id);
}
