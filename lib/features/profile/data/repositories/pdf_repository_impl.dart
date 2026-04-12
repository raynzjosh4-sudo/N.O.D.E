import 'dart:io';
import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'package:node_app/core/database/app_database.dart';
import 'package:node_app/core/error/failure.dart';
import 'package:node_app/features/profile/domain/entities/pdf_document.dart';
import 'package:node_app/features/profile/domain/repositories/pdf_repository.dart';

class PdfRepositoryImpl implements PdfRepository {
  final AppDatabase database;

  PdfRepositoryImpl(this.database);

  @override
  Future<Either<Failure, void>> savePdfMetadata({
    required String id,
    required String userId,
    required String title,
    required String filePath,
    required String fileSize,
  }) async {
    try {
      final entry = GeneratedPdfEntry(
        id: id,
        userId: userId,
        title: title,
        filePath: filePath,
        fileSize: fileSize,
        createdAt: DateTime.now(),
      );
      await database
          .into(database.generatedPdfsTable)
          .insertOnConflictUpdate(entry);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PdfDocument>>> getUserPdfs(String userId) async {
    try {
      final query = database.select(database.generatedPdfsTable)
        ..where((t) => t.userId.equals(userId))
        ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
      final results = await query.get();
      final docs = results
          .map(
            (e) => PdfDocument(
              id: e.id,
              title: e.title,
              fileUrl: e.filePath, // local path stored in fileUrl
              fileSize: e.fileSize,
              updatedAt: e.createdAt,
            ),
          )
          .toList();
      return Right(docs);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePdf(String id) async {
    try {
      // 1. Find the entry to get the file path
      final query = database.select(database.generatedPdfsTable)
        ..where((t) => t.id.equals(id));
      final entry = await query.getSingleOrNull();

      if (entry != null) {
        // 2. Delete the physical file
        final file = File(entry.filePath);
        if (await file.exists()) {
          await file.delete();
        }

        // 3. Delete from database
        await (database.delete(database.generatedPdfsTable)
              ..where((t) => t.id.equals(id)))
            .go();
      }

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
