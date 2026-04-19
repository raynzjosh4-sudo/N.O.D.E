import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:node_app/features/auth/google/service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});
