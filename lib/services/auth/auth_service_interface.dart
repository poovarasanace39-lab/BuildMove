import '../../core/network/api_result.dart';
import '../../models/user_model.dart';
import '../../models/enums.dart';

abstract class IAuthService {
  /// Request an OTP for a given 10-digit Indian phone number.
  Future<ApiResult<String>> sendOtp(String phone);

  /// Verify OTP and return authenticated UserModel with JWT token.
  Future<ApiResult<AuthResponse>> verifyOtp({
    required String phone,
    required String otp,
    required String verificationId,
  });

  /// Check whether an active session exists in storage.
  Future<UserModel?> getCurrentUser();

  /// Log out and invalidate local session.
  Future<void> logout();

  /// Quick switch role in development mode
  Future<UserModel> devSwitchRole(UserRole targetRole);
}

class AuthResponse {
  final UserModel user;
  final String token;

  const AuthResponse({required this.user, required this.token});
}
