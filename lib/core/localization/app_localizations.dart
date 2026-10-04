import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../../features/auth/providers/auth_provider.dart';
import 'app_translations.dart';

/// Provider for active app locale
final appLocaleProvider = NotifierProvider<AppLocaleNotifier, Locale>(() {
  return AppLocaleNotifier();
});

class AppLocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    try {
      final prefs = ref.watch(sharedPreferencesProvider);
      final savedCode = prefs.getString(AppConstants.keyAppLocale);
      if (savedCode != null && (savedCode == 'en' || savedCode == 'ta')) {
        return Locale(savedCode);
      }
    } catch (_) {
      _loadSavedLocale();
    }
    return const Locale(AppConstants.localeEn);
  }

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString(AppConstants.keyAppLocale);
    if (savedCode != null && (savedCode == 'en' || savedCode == 'ta')) {
      state = Locale(savedCode);
    }
  }

  Future<void> setLocale(String languageCode) async {
    if (languageCode != 'en' && languageCode != 'ta') return;
    state = Locale(languageCode);
    try {
      final prefs = ref.read(sharedPreferencesProvider);
      await prefs.setString(AppConstants.keyAppLocale, languageCode);
    } catch (_) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.keyAppLocale, languageCode);
    }
  }
}

/// Helper extension on BuildContext to fetch translated strings easily
extension AppLocalizationContext on BuildContext {
  String tr(String key) {
    final locale = Localizations.maybeLocaleOf(this) ?? const Locale('en');
    final code = locale.languageCode == 'ta' ? 'ta' : 'en';
    final dict = AppTranslations.values[code] ?? AppTranslations.values['en']!;
    return dict[key] ?? AppTranslations.values['en']?[key] ?? key;
  }
}
