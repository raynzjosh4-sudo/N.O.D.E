import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node_app/core/database/app_database.dart';
import 'package:node_app/features/inventory/presentation/providers/inventory_notifier.dart';
import 'package:node_app/features/profile/data/repositories/pdf_repository_impl.dart';
import 'package:node_app/features/profile/domain/entities/pdf_document.dart';
import 'package:node_app/features/profile/domain/repositories/pdf_repository.dart';
import 'package:node_app/features/auth/presentation/providers/user_providers.dart';

final pdfRepositoryProvider = Provider<PdfRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return PdfRepositoryImpl(db);
});

final userPdfsProvider = FutureProvider<List<PdfDocument>>((ref) async {
  final user = await ref.watch(userProfileProvider.future);
  if (user == null) return [];
  final repo = ref.watch(pdfRepositoryProvider);
  final result = await repo.getUserPdfs(user.id);
  return result.fold((_) => [], (docs) => docs);
});
