import '../../core/errors/app_failure.dart';
import '../../core/network/api_result.dart';
import '../../core/storage/storage_service.dart';
import '../../models/enums.dart';
import '../../models/user_model.dart';
import 'auth_service_interface.dart';

/// Development authentication service.
/// Uses mock phone OTP verification (default code: 123456)
/// and allows instant role switching between Customer, Driver, and Admin.
class DevAuthService implements IAuthService {
  final StorageService _storageService;

  DevAuthService(this._storageService);

  // Pre-configured mock personas
  static final Map<UserRole, UserModel> mockUsers = {
    UserRole.customer: UserModel(
      id: 'usr_cust_001',
      phone: '9876543210',
      name: 'Ramesh Sundaram (Site Engineer)',
      email: 'ramesh.build@infra.in',
      role: UserRole.customer,
      isVerified: true,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    UserRole.driver: UserModel(
      id: 'usr_drv_002',
      phone: '9840123456',
      name: 'Murugan K. (Tata Ace Owner/Driver)',
      email: 'murugan.trans@gmail.com',
      role: UserRole.driver,
      isVerified: true,
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
    ),
    UserRole.admin: UserModel(
      id: 'usr_adm_003',
      phone: '9999900000',
      name: 'Priya Sharma (Fleet Ops Admin)',
      email: 'ops.admin@buildmove.in',
      role: UserRole.admin,
      isVerified: true,
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
    ),
  };

  @override
  Future<ApiResult<String>> sendOtp(String phone) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (phone.length != 10) {
      return const Failure(ValidationFailure('Please enter a valid 10-digit mobile number'));
    }
    // Return mock verificationId
    return const Success('dev_mock_verification_id_999');
  }

  @override
  Future<ApiResult<AuthResponse>> verifyOtp({
    required String phone,
    required String otp,
    required String verificationId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (otp != '123456') {
      return const Failure(AuthFailure('Invalid OTP. In demo mode, use 123456.'));
    }

    // Role mapping based on phone number for demo
    UserRole role = UserRole.customer;
    if (phone.endsWith('2') || phone == '9840123456') {
      role = UserRole.driver;
    } else if (phone.endsWith('3') || phone == '9999900000') {
      role = UserRole.admin;
    }

    final user = mockUsers[role]!.copyWith(phone: phone);
    const mockToken = 'dev_mock_jwt_token_buildmove_2026';

    await _storageService.saveToken(mockToken);
    await _storageService.saveUserRole(user.role.name);
    await _storageService.saveUserId(user.id);

    return Success(AuthResponse(user: user, token: mockToken));
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final token = _storageService.getToken();
    if (token == null) return null;

    final roleName = _storageService.getUserRole();
    final role = UserRole.fromString(roleName);
    return mockUsers[role];
  }

  @override
  Future<void> logout() async {
    await _storageService.clearSession();
  }

  @override
  Future<UserModel> devSwitchRole(UserRole targetRole) async {
    final user = mockUsers[targetRole]!;
    await _storageService.saveToken('dev_mock_jwt_token_${targetRole.name}');
    await _storageService.saveUserRole(targetRole.name);
    await _storageService.saveUserId(user.id);
    return user;
  }
}
