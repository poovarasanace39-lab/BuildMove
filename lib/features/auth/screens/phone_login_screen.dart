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

class PhoneLoginScreen extends ConsumerStatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  ConsumerState<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends ConsumerState<PhoneLoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  String? _phoneError;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _validateAndSubmit() async {
    final text = _phoneController.text.trim();
    if (text.length != 10) {
      setState(() {
        _phoneError = 'Please enter a valid 10-digit mobile number';
      });
      return;
    }

    setState(() {
      _phoneError = null;
    });

    final success = await ref.read(authProvider.notifier).sendOtp(text);
    if (success && mounted) {
      context.push(AppRoutes.otpVerification);
    }
  }

  void _handleQuickDemoLogin(UserRole role) async {
    await ref.read(authProvider.notifier).quickDemoLogin(role);
    if (!mounted) return;

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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          TextButton.icon(
            onPressed: () => context.push(AppRoutes.languageSelection),
            icon: const Icon(Icons.language, size: 18, color: AppColors.secondary),
            label: Text(
              Localizations.localeOf(context).languageCode.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondary),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo & App Name Header
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.local_shipping_rounded, color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(context.tr('app_name'), style: AppTypography.titleLarge),
                      Text(
                        context.tr('tagline'),
                        style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 36),

              Text(context.tr('login_title'), style: AppTypography.displayMedium),
              const SizedBox(height: 8),
              Text(
                context.tr('login_subtitle'),
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 28),

              // Phone Number Input
              AppTextField(
                controller: _phoneController,
                label: context.tr('phone_label'),
                hint: context.tr('phone_hint'),
                keyboardType: TextInputType.phone,
                errorText: _phoneError ?? authState.error?.message,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(AppConstants.phoneLengthIndia),
                ],
                prefixIcon: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  alignment: Alignment.centerLeft,
                  width: 75,
                  child: Text(
                    AppConstants.defaultCountryCode,
                    style: AppTypography.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Send OTP Button
              AppButton(
                text: context.tr('send_otp'),
                isLoading: authState.isLoading,
                onPressed: _validateAndSubmit,
              ),

              const SizedBox(height: 36),

              // Development / Demo Shortcuts Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.developer_mode_rounded, size: 18, color: AppColors.primaryDark),
                        const SizedBox(width: 8),
                        Text(
                          context.tr('quick_demo_login'),
                          style: AppTypography.titleSmall.copyWith(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'One-tap preview for all 3 system roles (no Firebase SMS required in development):',
                      style: AppTypography.bodySmall,
                    ),
                    const SizedBox(height: 12),

                    // Customer Shortcut
                    _demoRoleButton(
                      title: context.tr('role_customer'),
                      subtitle: '9876543210 • Ramesh (Civil Eng)',
                      role: UserRole.customer,
                      color: AppColors.customerRole,
                      icon: Icons.engineering_rounded,
                    ),
                    const SizedBox(height: 8),

                    // Driver Shortcut
                    _demoRoleButton(
                      title: context.tr('role_driver'),
                      subtitle: '9840123456 • Murugan (Tata Ace)',
                      role: UserRole.driver,
                      color: AppColors.driverRole,
                      icon: Icons.local_shipping_rounded,
                    ),
                    const SizedBox(height: 8),

                    // Admin Shortcut
                    _demoRoleButton(
                      title: context.tr('role_admin'),
                      subtitle: '9999900000 • Priya (Control Tower)',
                      role: UserRole.admin,
                      color: AppColors.adminRole,
                      icon: Icons.admin_panel_settings_rounded,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _demoRoleButton({
    required String title,
    required String subtitle,
    required UserRole role,
    required Color color,
    required IconData icon,
  }) {
    return InkWell(
      onTap: () => _handleQuickDemoLogin(role),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.labelLarge.copyWith(color: color)),
                  Text(subtitle, style: AppTypography.bodySmall),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 13, color: AppColors.slateMuted),
          ],
        ),
      ),
    );
  }
}
