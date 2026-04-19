import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node_app/core/services/cloud_media_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:node_app/features/profile/data/repositories/pdf_repository_impl.dart';
import 'package:node_app/features/profile/domain/entities/pdf_document.dart';
import 'package:node_app/features/profile/domain/repositories/pdf_repository.dart';
import 'package:node_app/features/profile/presentation/providers/profile_providers.dart';

final pdfRepositoryProvider = Provider<PdfRepository>((ref) {
  return PdfRepositoryImpl(Supabase.instance.client, CloudMediaService());
});

final userPdfsProvider = FutureProvider<List<PdfDocument>>((ref) async {
  final user = await ref.watch(userProfileProvider.future);
  if (user == null) return [];
  final repo = ref.watch(pdfRepositoryProvider);
  final result = await repo.getUserPdfs(user.id);
  return result.fold((_) => [], (docs) => docs);
});
