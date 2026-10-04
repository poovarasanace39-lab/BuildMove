/// Core application constants for BuildMove
class AppConstants {
  AppConstants._();

  static const String appName = 'BuildMove';
  static const String appTagline = 'Heavy Material Logistics • Made Simple';
  static const String appVersion = '1.0.0 (Phase 1)';

  // Supported Locales
  static const String localeEn = 'en';
  static const String localeTa = 'ta';

  // Shared Preferences Keys
  static const String keyAppLocale = 'bm_locale';
  static const String keyAuthToken = 'bm_auth_token';
  static const String keyUserRole = 'bm_user_role';
  static const String keyUserId = 'bm_user_id';
  static const String keyIsDevMode = 'bm_is_dev_mode';
  static const String keyHasSelectedLanguage = 'bm_has_selected_lang';
  static const String keyAppThemeMode = 'bm_theme_mode';

  // Demo / Dev Mode Constants
  static const String devDefaultOtp = '123456';
  static const int otpTimeoutSeconds = 45;

  // Phone Validation
  static const int phoneLengthIndia = 10;
  static const String defaultCountryCode = '+91';

  // Currencies & Measurements
  static const String currencySymbol = '₹';
  static const String unitTons = 'Tons';
  static const String unitKg = 'Kg';
  static const String unitBags = 'Bags';
  static const String unitKm = 'km';
}
