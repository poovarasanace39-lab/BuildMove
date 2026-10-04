import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

/// Storage service wrapping SharedPreferences for persistent local state.
class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  // Token Management
  Future<void> saveToken(String token) async {
    await _prefs.setString(AppConstants.keyAuthToken, token);
  }

  String? getToken() {
    return _prefs.getString(AppConstants.keyAuthToken);
  }

  Future<void> clearToken() async {
    await _prefs.remove(AppConstants.keyAuthToken);
  }

  // User Role Management
  Future<void> saveUserRole(String role) async {
    await _prefs.setString(AppConstants.keyUserRole, role);
  }

  String? getUserRole() {
    return _prefs.getString(AppConstants.keyUserRole);
  }

  // User ID
  Future<void> saveUserId(String userId) async {
    await _prefs.setString(AppConstants.keyUserId, userId);
  }

  String? getUserId() {
    return _prefs.getString(AppConstants.keyUserId);
  }

  // Dev Mode Flag
  Future<void> setDevMode(bool isDev) async {
    await _prefs.setBool(AppConstants.keyIsDevMode, isDev);
  }

  bool isDevMode() {
    return _prefs.getBool(AppConstants.keyIsDevMode) ?? true; // Defaults to true in dev
  }

  // Language Selected Flag
  Future<void> setHasSelectedLanguage(bool value) async {
    await _prefs.setBool(AppConstants.keyHasSelectedLanguage, value);
  }

  bool hasSelectedLanguage() {
    return _prefs.getBool(AppConstants.keyHasSelectedLanguage) ?? false;
  }

  // Theme Mode (light, dark, system)
  Future<void> saveThemeMode(String mode) async {
    await _prefs.setString(AppConstants.keyAppThemeMode, mode);
  }

  String getThemeMode() {
    return _prefs.getString(AppConstants.keyAppThemeMode) ?? 'system';
  }

  // Clear Session
  Future<void> clearSession() async {
    await _prefs.remove(AppConstants.keyAuthToken);
    await _prefs.remove(AppConstants.keyUserRole);
    await _prefs.remove(AppConstants.keyUserId);
  }
}
