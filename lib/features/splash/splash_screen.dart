import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/routing/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../models/enums.dart';
import '../auth/providers/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _handleNavigation();
  }

  Future<void> _handleNavigation() async {
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;

    final storage = ref.read(storageServiceProvider);
    final hasSelectedLang = storage.hasSelectedLanguage();

    if (!hasSelectedLang) {
      context.go(AppRoutes.languageSelection);
      return;
    }

    final authState = ref.read(authProvider);
    if (authState.isAuthenticated && authState.currentUser != null) {
      _navigateForRole(authState.currentUser!.role);
    } else {
      context.go(AppRoutes.login);
    }
  }

  void _navigateForRole(UserRole role) {
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
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Brand Icon Container
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x40000000),
                      blurRadius: 16,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.local_shipping_rounded,
                  size: 52,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                context.tr('app_name'),
                style: AppTypography.displayLarge.copyWith(
                  color: Colors.white,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 8),

              // Subtitle Tagline
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  context.tr('tagline'),
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textTertiary,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // Loading Spinner
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                AppConstants.appVersion,
                style: const TextStyle(
                  color: AppColors.slateMuted,
                  fontSize: 11,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
