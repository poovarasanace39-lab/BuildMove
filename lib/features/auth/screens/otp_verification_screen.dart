import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../models/enums.dart';
import '../providers/auth_provider.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  int _secondsRemaining = AppConstants.otpTimeoutSeconds;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _secondsRemaining = AppConstants.otpTimeoutSeconds;
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  void _handleVerify() async {
    final otp = _otpController.text.trim();
    if (otp.length != 6) return;

    final success = await ref.read(authProvider.notifier).verifyOtp(otp);
    if (success && mounted) {
      final user = ref.read(authProvider).currentUser;
      if (user != null) {
        _redirectUser(user.role);
      }
    }
  }

  void _redirectUser(UserRole role) {
    switch (role) {
      case UserRole.customer:
        context.go(AppRoutes.customerHome);
        break;
      case UserRole.driver:
        context.go(AppRoutes.driverHome);
        break;
      case UserRole.admin:
        context.go(AppRoutes.adminDashboard);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final phone = authState.pendingPhone ?? '9876543210';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.tr('otp_title'), style: AppTypography.displayMedium),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: AppTypography.bodyMedium,
                  children: [
                    TextSpan(text: context.tr('otp_subtitle')),
                    TextSpan(
                      text: phone,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Dev Mode Hint Banner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, color: AppColors.primaryDark, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        context.tr('dev_bypass_hint'),
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // OTP Input Field
              AppTextField(
                controller: _otpController,
                label: '6-Digit Verification Code',
                hint: 'Enter 6 digits',
                keyboardType: TextInputType.number,
                errorText: authState.error?.message,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                onChanged: (val) {
                  if (val.length == 6) {
                    _handleVerify();
                  }
                },
              ),
              const SizedBox(height: 24),

              // Verify Button
              AppButton(
                text: context.tr('verify_and_login'),
                isLoading: authState.isLoading,
                onPressed: _handleVerify,
              ),

              const SizedBox(height: 24),

              // Resend Timer Row
              Center(
                child: _secondsRemaining > 0
                    ? Text(
                        'Resend code in ${_secondsRemaining}s',
                        style: AppTypography.bodySmall,
                      )
                    : TextButton(
                        onPressed: () {
                          _startCountdown();
                          ref.read(authProvider.notifier).sendOtp(phone);
                        },
                        child: Text(
                          context.tr('resend_otp'),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
