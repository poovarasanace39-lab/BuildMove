import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/errors/app_failure.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/storage_service.dart';
import '../../../models/enums.dart';
import '../../../models/user_model.dart';
import '../../../services/auth/auth_service_interface.dart';
import '../../../services/auth/dev_auth_service.dart';
import '../../../services/auth/firebase_auth_service.dart';

// Storage Provider
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize SharedPreferences in main() first');
});

final storageServiceProvider = Provider<StorageService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return StorageService(prefs);
});

// API Client Provider
final apiClientProvider = Provider<ApiClient>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return ApiClient(storageService: storage);
});

// Auth Service Provider (defaults to DevAuthService in development)
final authServiceProvider = Provider<IAuthService>((ref) {
  final storage = ref.watch(storageServiceProvider);
  final isDev = storage.isDevMode();

  if (isDev) {
    return DevAuthService(storage);
  } else {
    final client = ref.watch(apiClientProvider);
    return FirebaseAuthService(apiClient: client);
  }
});

// Auth State Data Class
class AuthState {
  final UserModel? currentUser;
  final bool isLoading;
  final AppFailure? error;
  final String? pendingVerificationId;
  final String? pendingPhone;

  const AuthState({
    this.currentUser,
    this.isLoading = false,
    this.error,
    this.pendingVerificationId,
    this.pendingPhone,
  });

  bool get isAuthenticated => currentUser != null;

  AuthState copyWith({
    UserModel? currentUser,
    bool clearCurrentUser = false,
    bool? isLoading,
    AppFailure? error,
    bool clearError = false,
    String? pendingVerificationId,
    String? pendingPhone,
  }) {
    return AuthState(
      currentUser: clearCurrentUser ? null : (currentUser ?? this.currentUser),
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      pendingVerificationId: pendingVerificationId ?? this.pendingVerificationId,
      pendingPhone: pendingPhone ?? this.pendingPhone,
    );
  }
}

// Auth Notifier
final authProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    // Initial check will be triggered
    Future.microtask(() => checkSession());
    return const AuthState(isLoading: true);
  }

  Future<void> checkSession() async {
    final authService = ref.read(authServiceProvider);
    try {
      final user = await authService.getCurrentUser();
      if (user != null) {
        state = state.copyWith(currentUser: user, isLoading: false, clearError: true);
      } else {
        state = state.copyWith(clearCurrentUser: true, isLoading: false, clearError: true);
      }
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> sendOtp(String phone) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final authService = ref.read(authServiceProvider);

    final result = await authService.sendOtp(phone);
    return result.fold(
      onSuccess: (verificationId) {
        state = state.copyWith(
          isLoading: false,
          pendingVerificationId: verificationId,
          pendingPhone: phone,
        );
        return true;
      },
      onFailure: (failure) {
        state = state.copyWith(isLoading: false, error: failure);
        return false;
      },
    );
  }

  Future<bool> verifyOtp(String otp) async {
    final verificationId = state.pendingVerificationId ?? 'dev_verification_id';
    final phone = state.pendingPhone ?? '9876543210';

    state = state.copyWith(isLoading: true, clearError: true);
    final authService = ref.read(authServiceProvider);

    final result = await authService.verifyOtp(
      phone: phone,
      otp: otp,
      verificationId: verificationId,
    );

    return result.fold(
      onSuccess: (authResponse) {
        clearRoleState();
        state = state.copyWith(
          isLoading: false,
          currentUser: authResponse.user,
        );
        return true;
      },
      onFailure: (failure) {
        state = state.copyWith(isLoading: false, error: failure);
        return false;
      },
    );
  }

  void clearRoleState() {
    // Reset any state associated with previously active role
  }

  Future<void> quickDemoLogin(UserRole role) async {
    clearRoleState();
    state = state.copyWith(isLoading: true, clearError: true);
    final authService = ref.read(authServiceProvider);
    final user = await authService.devSwitchRole(role);
    state = state.copyWith(isLoading: false, currentUser: user);
  }

  Future<void> devSwitchRole(UserRole role) async {
    await quickDemoLogin(role);
  }

  Future<void> logout() async {
    clearRoleState();
    state = state.copyWith(isLoading: true);
    final authService = ref.read(authServiceProvider);
    await authService.logout();
    state = const AuthState(currentUser: null, isLoading: false);
  }
}
