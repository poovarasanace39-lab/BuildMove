import '../../core/errors/app_failure.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_result.dart';
import '../../models/enums.dart';
import '../../models/user_model.dart';
import 'auth_service_interface.dart';

/// Production Firebase Phone Authentication Service.
///
/// REQUIRED SETUP BEFORE PRODUCTION USE:
/// 1. Add `google-services.json` to `android/app/`
/// 2. Add `GoogleService-Info.plist` to `ios/Runner/`
/// 3. Add `firebase_core` and `firebase_auth` to `pubspec.yaml`
/// 4. Enable Phone Auth provider in Firebase Console
/// 5. Verify the Firebase ID token in FastAPI backend `/api/v1/auth/verify-firebase-token`
class FirebaseAuthService implements IAuthService {
  final ApiClient _apiClient;

  FirebaseAuthService({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<ApiResult<String>> sendOtp(String phone) async {
    // When Firebase Auth is configured:
    // await FirebaseAuth.instance.verifyPhoneNumber(
    //   phoneNumber: '+91$phone',
    //   verificationCompleted: ...,
    //   verificationFailed: ...,
    //   codeSent: (verificationId, resendToken) => ...,
    //   codeAutoRetrievalTimeout: ...,
    // );

    return const Failure(AuthFailure(
      'Firebase Auth credentials not yet configured. Please switch to Development Mode or provide google-services.json.',
      code: 'FIREBASE_NOT_CONFIGURED',
    ));
  }

  @override
  Future<ApiResult<AuthResponse>> verifyOtp({
    required String phone,
    required String otp,
    required String verificationId,
  }) async {
    // When Firebase Auth is configured:
    // final credential = PhoneAuthProvider.credential(
    //   verificationId: verificationId,
    //   smsCode: otp,
    // );
    // final userCred = await FirebaseAuth.instance.signInWithCredential(credential);
    // final idToken = await userCred.user?.getIdToken();
    //
    // Call FastAPI backend to verify idToken & obtain app JWT with server-assigned role:
    // final response = await _apiClient.post(ApiEndpoints.authVerifyFirebaseToken, body: {'id_token': idToken});

    return const Failure(AuthFailure(
      'Firebase Auth is not configured. Use demo login with 123456.',
      code: 'FIREBASE_NOT_CONFIGURED',
    ));
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final res = await _apiClient.get('/auth/me');
      return UserModel.fromJson(res as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> logout() async {
    // await FirebaseAuth.instance.signOut();
  }

  @override
  Future<UserModel> devSwitchRole(UserRole targetRole) {
    throw UnsupportedError('devSwitchRole is not available in production FirebaseAuthService');
  }
}
