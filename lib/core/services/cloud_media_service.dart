import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:minio/minio.dart';
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart';

@lazySingleton
class CloudMediaService {
  final _minio = Minio(
    endPoint: dotenv.env['R2_ENDPOINT'] ?? '',
    accessKey: dotenv.env['R2_ACCESS_KEY_ID'] ?? '',
    secretKey: dotenv.env['R2_SECRET_ACCESS_KEY'] ?? '',
    region: dotenv.env['R2_REGION'] ?? 'auto',
    pathStyle: dotenv.env['R2_PATH_STYLE'] == 'true',
  );

  /// 👑 BUCKET NAME MUST BE ALL LOWERCASE!
  String get bucketName => dotenv.env['R2_BUCKET_NAME'] ?? 'node-media-bucket';

  /// Uploads any media type to a specific folder in Cloudflare R2.
  /// Structure: users/{user_id}/{folderName}/Chart_{timestamp}.ext
  Future<String?> uploadMedia(
    Uint8List fileBytes, {
    required String originalName,
    required String userId,
    required String folderName,
    void Function(int, int)? onProgress,
  }) async {
    final extension = path.extension(originalName);
    final rawFileName =
        'Chart_${DateTime.now().millisecondsSinceEpoch}$extension';

    // 👑 STRICT HIERARCHY: Every file is isolated under users/{user_id}
    // We maintain the requested folder structure to prevent creating new top-level folders.
    // 👑 Path construction: DIRECTLY under users/userId and folderName
    final objectKey = 'users/$userId/$folderName/$rawFileName';

    try {
      debugPrint('☁️ [R2] Uploading to bucket: $bucketName');
      debugPrint('☁️ [R2] Object key: $objectKey');

      final fileSize = fileBytes.length;

      final mimeType =
          lookupMimeType(originalName) ?? 'application/octet-stream';

      // 👑 PROGRESS WRAPPER: Convert file into a stream that we can monitor
      final stream = Stream.fromIterable([fileBytes]);

      if (onProgress != null) {
        onProgress(fileSize, fileSize);
      }

      await _minio.putObject(
        bucketName,
        objectKey,
        stream,
        size: fileSize,
        metadata: {'Content-Type': mimeType},
      );

      // Generating the public-facing URL
      final publicUrl =
          '${dotenv.env['R2_PUBLIC_URL'] ?? 'https://crown.nexassearch.com'}/$objectKey';
      debugPrint('✅ [R2] Upload success! URL: $publicUrl');
      return publicUrl;
    } catch (e, stackTrace) {
      debugPrint('❌ [R2] Upload FAILED: $e');
      debugPrint('❌ [R2] Stack: $stackTrace');
      return null;
    }
  }

  /// Bulk upload helper
  Future<List<String>> uploadBatch(
    List<Map<String, dynamic>> files, {
    required String userId,
    required String folderName,
  }) async {
    final List<Future<String?>> uploads = [];
    for (int i = 0; i < files.length; i++) {
      uploads.add(
        uploadMedia(
          files[i]['bytes'] as Uint8List,
          originalName: files[i]['name'] as String,
          userId: userId,
          folderName: folderName,
        ),
      );
    }

    final results = await Future.wait(uploads);
    return results.whereType<String>().toList();
  }

  /// 👑 Deletes a file directly from R2 using its public URL
  Future<bool> deleteMediaFromUrl(String publicUrl) async {
    try {
      final prefix =
          '${dotenv.env['R2_PUBLIC_URL'] ?? 'https://crown.nexassearch.com'}/';
      if (!publicUrl.startsWith(prefix)) {
        debugPrint(
          '⚠️ [R2] URL is not in our bucket. Ignoring delete: $publicUrl',
        );
        return true;
      }

      final objectKey = publicUrl.substring(prefix.length);
      debugPrint('🗑️ [R2] Deleting object key: $objectKey');

      await _minio.removeObject(bucketName, objectKey);
      debugPrint('✅ [R2] Delete success!');
      return true;
    } catch (e) {
      debugPrint('❌ [R2] Delete FAILED: $e');
      return false;
    }
  }
}
