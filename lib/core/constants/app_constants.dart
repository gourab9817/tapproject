class AppConstants {
  // Build-time injected values. Pass via --dart-define or --dart-define-from-file
  // Examples of keys:
  // - BASE_URL
  // - BONDS_LIST_URL
  // - BOND_DETAIL_URL
  // If a key is missing, defaultValue will be empty string.
  static const String baseUrl = String.fromEnvironment('BASE_URL', defaultValue: '');
  static const String bondsListUrl = String.fromEnvironment('BONDS_LIST_URL', defaultValue: '');
  static const String bondDetailUrl = String.fromEnvironment('BOND_DETAIL_URL', defaultValue: '');

  // Convenience helper to validate config at runtime (optional usage)
  static void ensureConfigured() {
    assert(
      bondsListUrl.isNotEmpty && bondDetailUrl.isNotEmpty,
      'API endpoints are not configured. Pass values via --dart-define or --dart-define-from-file.'
    );
  }
  
  // API endpoints
  static const String bonds = '/bonds';
  static const String bondDetail = '/bond';
  
  // Timeout values
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Animation durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration pageTransitionDuration = Duration(milliseconds: 250);
  
  // UI constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  
  // Search
  static const int searchDebounceMs = 500;
}
