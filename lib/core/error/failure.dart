class Failure {
  final String message;
  final StackTrace? stackTrace;

  const Failure(this.message, [this.stackTrace]);

  @override
  String toString() => 'Failure(message: $message)';

  String toFriendlyMessage() {
    final lowerMessage = message.toLowerCase();

    // 🧠 SMART ERROR MAPPING: Translate tech-speak to wholesale/business-speak
    if (lowerMessage.contains('network') || 
        lowerMessage.contains('socket') || 
        lowerMessage.contains('clientexception') ||
        lowerMessage.contains('connection refused') ||
        lowerMessage.contains('522')) {
      return 'Regional Hub connection issue. Re-optimizing...';
    }
    
    if (lowerMessage.contains('postgres') || 
        lowerMessage.contains('sql') || 
        lowerMessage.contains('database') ||
        lowerMessage.contains('column') ||
        lowerMessage.contains('relation')) {
      return 'Our supply database is taking a quick break. Retrying...';
    }
    
    if (lowerMessage.contains('auth') || 
        lowerMessage.contains('permission') ||
        lowerMessage.contains('jwt') ||
        lowerMessage.contains('403') ||
        lowerMessage.contains('unauthorized')) {
      
      // 🔒 SPECIFIC AUTH MAPPINGS: Branded, clear, and guided
      if (lowerMessage.contains('invalid login credentials') || 
          lowerMessage.contains('invalid_credentials') ||
          lowerMessage.contains('invalid_grant')) {
        return 'Invalid email or password. Please verify and try again.';
      }
      
      if (lowerMessage.contains('email not confirmed')) {
        return 'Registration incomplete. Please verify your email before logging in.';
      }

      if (lowerMessage.contains('user already registered') || 
          lowerMessage.contains('already exists')) {
        return 'This email is already associated with a N.O.D.E account.';
      }

      if (lowerMessage.contains('too many requests') || 
          lowerMessage.contains('rate limit')) {
        return 'Security Lock: Too many attempts. Please try again in a few minutes.';
      }

      if (lowerMessage.contains('invalid token') || 
          lowerMessage.contains('invalid code') ||
          lowerMessage.contains('otp_expired')) {
        return 'The verification code is incorrect or has expired. Please try again.';
      }

      if (lowerMessage.contains('weak_password')) {
        return 'Security Requirement: Password must be stronger (minimum 6 characters).';
      }

      return 'Authentication session expired. Please sign in again.';
    }

    
    if (lowerMessage.contains('timeout') || lowerMessage.contains('deadline')) {
      return 'Request timed out while reaching the global server.';
    }

    if (lowerMessage.contains('duplicate') || lowerMessage.contains('already exists')) {
      return 'This entry already exists in our registry.';
    }

    if (lowerMessage.contains('camera') || 
        lowerMessage.contains('scanner') || 
        lowerMessage.contains('mobile_scanner')) {
      return 'Scanner access restricted. Please check N.O.D.E permissions.';
    }

    if (lowerMessage.contains('file') || 
        lowerMessage.contains('path') || 
        lowerMessage.contains('directory') ||
        lowerMessage.contains('os error')) {
      return 'Storage system issue. Please ensure your device has space.';
    }

    if (lowerMessage.contains('null') || 
        lowerMessage.contains('unexpected') || 
        lowerMessage.contains('format')) {
      return 'Data synchronization anomaly. Re-aligning with server...';
    }

    if (lowerMessage.contains('500') || lowerMessage.contains('internal server error')) {
      return 'Global Hub is under heavy load. One moment...';
    }

    // Default friendly message
    return 'We encountered a small hurdle. One moment...';
  }

  /// 🛡️ GLOBAL SAFE FACTORY: Ensures NO technical jargon ever reaches the UI
  static Failure fromException(dynamic e) {
    if (e is Failure) return e;
    
    final msg = e.toString();
    // Wrap raw strings/exceptions into a ServerFailure which uses the friendly mapper
    return ServerFailure(msg);
  }
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, [super.stackTrace]);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message, [super.stackTrace]);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No Internet Connection']);
}
