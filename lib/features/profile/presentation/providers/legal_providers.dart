import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node_app/features/profile/data/repositories/legal_terms_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final legalTermsRepositoryProvider = Provider<LegalTermsRepository>((ref) {
  return LegalTermsRepository(Supabase.instance.client);
});
