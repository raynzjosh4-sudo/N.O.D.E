import 'dart:typed_data';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:node_app/core/error/failure.dart';
import 'package:node_app/features/profile/domain/entities/pdf_document.dart';
import 'package:node_app/features/profile/domain/repositories/pdf_repository.dart';
import 'package:node_app/core/services/cloud_media_service.dart';

class PdfRepositoryImpl implements PdfRepository {
  final SupabaseClient _client;
  final CloudMediaService _cloudMediaService;

  PdfRepositoryImpl(this._client, this._cloudMediaService);

  @override
  Future<Either<Failure, void>> savePdfMetadata({
    required String id,
    required String userId,
    required String title,
    required Uint8List bytes,
    required String fileName,
    required String fileSize,
  }) async {
    try {
      debugPrint('☁️ Uploading PDF to Cloudflare R2...');
      // 1. Upload to Cloudflare R2 bucket -> users/{userId}/pdfs/
      final publicUrl = await _cloudMediaService.uploadMedia(
        bytes,
        originalName: fileName,
        userId: userId,
        folderName: 'pdfs',
      );

      if (publicUrl == null) {
        return const Left(
          ServerFailure('Failed to upload PDF to cloud storage.'),
        );
      }

      debugPrint('✅ Uploaded to: $publicUrl');
      debugPrint('💾 Saving metadata to Supabase pdfs_table...');

      // 2. Save metadata to Supabase (using publicUrl as file_url)
      await _client.from('pdfs_table').upsert({
        'id': id,
        'user_id': userId,
        'title': title,
        'file_url': publicUrl,
        'file_size': fileSize,
        'created_at': DateTime.now().toUtc().toIso8601String(),
      });

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to save PDF: $e'));
    }
  }

  @override
  Future<Either<Failure, List<PdfDocument>>> getUserPdfs(String userId) async {
    try {
      final response = await _client
          .from('pdfs_table')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final List<dynamic> data = response as List;
      final docs = data
          .map(
            (row) => PdfDocument(
              id: row['id'] as String,
              title: row['title'] as String,
              fileUrl: row['file_url'] as String,
              fileSize: row['file_size'] as String,
              updatedAt: DateTime.parse(row['created_at'] as String),
            ),
          )
          .toList();

      return Right(docs);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PdfDocument>> getPdfById(String id) async {
    try {
      final response = await _client
          .from('pdfs_table')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) {
        return const Left(ServerFailure('PDF not found.'));
      }

      final doc = PdfDocument(
        id: response['id'] as String,
        title: response['title'] as String,
        fileUrl: response['file_url'] as String,
        fileSize: response['file_size'] as String,
        updatedAt: DateTime.parse(response['created_at'] as String),
      );

      return Right(doc);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deletePdf(String id) async {
    try {
      // 1. Get the PDF to find the Cloudflare URL
      final response = await _client
          .from('pdfs_table')
          .select('file_url')
          .eq('id', id)
          .maybeSingle();

      if (response != null) {
        final fileUrl = response['file_url'] as String;
        // 2. Delete the file from Cloudflare R2
        await _cloudMediaService.deleteMediaFromUrl(fileUrl);
      }

      // 3. Delete metadata from Supabase
      await _client.from('pdfs_table').delete().eq('id', id);

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
